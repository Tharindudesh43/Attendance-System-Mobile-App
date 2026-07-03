import 'package:attendance_system_flutter_application/Providers/riverpod.dart';
import 'package:attendance_system_flutter_application/Widgets/SubjectAttendancePrecentage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class _Palette {
  static const bg = Color(0xFFF7F8FA);
  static const cardStart = Color(0xFFFFFFFF);
  static const cardEnd = Color(0xFFF1F4F6);
  static const accentPrimary = Color(0xFF026D94);
  static const accentSecondary = Color(0xFF48C2F2);
  static const accentTertiary = Color(0xFF0FB39A);
  static const textDark = Color(0xFF1B2430);
  static const textMuted = Color(0xFF6B7684);
  static const shimmerBase = Color(0xFFE7E9EC);
  static const shimmerHighlight = Color(0xFFF5F6F8);
}

class Analyticspage extends ConsumerStatefulWidget {
  const Analyticspage({Key? key}) : super(key: key);

  @override
  ConsumerState<Analyticspage> createState() => _AnalyticspageState();
}

class _AnalyticspageState extends ConsumerState<Analyticspage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;

  late ScrollController _missedatscrollController;
  final double itemHeight = 130;
  int _currIndex = 0;
  late String currentTime;
  late Timer timer;
  Timer? _timer;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _missedatscrollController = ScrollController();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_missedatscrollController.hasClients) {
        setState(() {
          _currIndex = (_currIndex + 1) % 3;
        });

        _missedatscrollController.animateTo(
          _currIndex * itemHeight,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });

    _scrollController.addListener(() {
      final page = (_scrollController.offset / 200).round();
      if (_currentPage != page) {
        setState(() {
          _currentPage = page;
        });
      }
    });
    updateTime();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateTime());

    ref.refresh(userAttendanceCountProvider);
    ref.refresh(userHistoryProvider);
  }

  int getWeekOfMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    return ((date.day + firstDayOfMonth.weekday - 1) / 7).ceil();
  }

  List<dynamic> computeWeeklyAttendance(List<dynamic> data) {
    List<dynamic> weeklyCounts = [0, 0, 0, 0, 0]; // 5 weeks max

    for (var record in data) {
      DateTime recordDate = DateTime.parse(record['date']);
      if (recordDate.month == DateTime.now().month &&
          recordDate.year == DateTime.now().year) {
        int week = getWeekOfMonth(recordDate); // 1..5
        if (week >= 1 && week <= 5) {
          weeklyCounts[week - 1] += 1; // week 1 = index 0
        }
      }
    }

    if (weeklyCounts[4] == 0) weeklyCounts.removeAt(4);

    return weeklyCounts;
  }

  List<dynamic> computeMonthlyAttendance(List<dynamic> data) {
    List<dynamic> monthlyCounts = [0, 0, 0, 0]; // 4 months

    for (var record in data) {
      DateTime recordDate = DateTime.parse(record['date']);
      if (recordDate.year == 2025) {
        int month = 1; // 1..12
        if (month >= 1 && month <= 4) {
          monthlyCounts[month - 1] += 1; // month 1 = index 0
        }
      }
    }
    return monthlyCounts;
  }

  void updateTime() {
    final now = DateTime.now();
    final formattedtime = DateFormat('HH:mm').format(now);
    setState(() {
      currentTime = formattedtime;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _timer?.cancel();
    _missedatscrollController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String getWeekDay(DateTime date) {
    const weekDays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return weekDays[date.weekday - 1];
  }

  String getWeekRange(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    final friday = monday.add(const Duration(days: 4));

    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    final monthName = months[monday.month - 1];
    return "$monthName ${monday.day} - ${friday.day}";
  }

  String getFormattedDate(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${date.day} ${months[date.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final attendanceCount = ref.watch(userAttendanceCountProvider);
    final history = ref.watch(userHistoryProvider);
    return Scaffold(
      backgroundColor: _Palette.bg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 5,
                top: 14,
              ),
              child: _WeekStripHeaderCard(
                currentTime: currentTime,
                isAM: DateTime.now().hour >= 0 && DateTime.now().hour < 12,
                now: DateTime.now(),
              ),
            ),

            const SizedBox(height: 6),
            _SectionTitle(title: "Subject-wise Attendance"),
            Column(
              children: [
                attendanceCount.when(
                  data: (itemList) {
                    if (itemList.isEmpty) {
                      return const _EmptyState(
                        message: "No Attendance Data Available!",
                      );
                    }

                    return Column(
                      children: [
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: itemList.length,
                            itemBuilder: (context, index) {
                              final item = itemList[index];
                              return SubjectAttendancePie(
                                subjectName: item["subject"] ?? "N/A",
                                attended: item["student_count"] ?? 0,
                                absent:
                                    item["lectures_count"] -
                                        item['student_count'] ??
                                    0,
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            itemList.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              height: 6,
                              width: _currentPage == index ? 16 : 8,
                              decoration: BoxDecoration(
                                gradient: _currentPage == index
                                    ? const LinearGradient(
                                        colors: [
                                          _Palette.accentPrimary,
                                          _Palette.accentSecondary,
                                        ],
                                      )
                                    : null,
                                color: _currentPage == index
                                    ? null
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const _SubjectPieShimmer(),
                  error: (e, st) => _ErrorState(message: "Error: $e"),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: history.when(
                    data: (itemList) {
                      if (itemList.isEmpty) {
                        return const _EmptyState(
                          message: "No Attendance Weekly Data!",
                        );
                      }

                      final weeklyData = computeWeeklyAttendance(itemList);

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _weeklyAttendanceChart(weeklyData: weeklyData),
                          ],
                        ),
                      );
                    },
                    loading: () =>
                        const _ChartCardShimmer(title: "Weekly Attendance"),
                    error: (e, st) => _ErrorState(message: "Error: $e"),
                  ),
                ),
              ],
            ),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: history.when(
                    data: (itemList) {
                      if (itemList.isEmpty) {
                        return const _EmptyState(
                          message: "No Attendance Monthly Data!",
                        );
                      }

                      final monthlyData = computeMonthlyAttendance(itemList);

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _monthlyAttendanceChart(
                              monthlyData: monthlyData.cast<int>(),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () =>
                        const _ChartCardShimmer(title: "Monthly Attendance"),
                    error: (e, st) => _ErrorState(message: "Error: $e"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _weeklyAttendanceChart({required List<dynamic> weeklyData}) {
    final maxY = (weeklyData.reduce((a, b) => a > b ? a : b)) + 5;
    return _ChartCard(
      title:
          "Weekly Attendance (${DateFormat('MMMM yyyy').format(DateTime.now())})",
      child: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.black.withOpacity(0.06), strokeWidth: 1),
          ),
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY.toDouble(),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.transparent,
              tooltipPadding: EdgeInsets.zero,
              tooltipMargin: 0,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.toY.toInt().toString(),
                  const TextStyle(
                    color: _Palette.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  if (value > 25) return const SizedBox.shrink();
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: _Palette.textMuted,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  const weekLabels = ['W1', 'W2', 'W3', 'W4', 'W5'];
                  if (value.toInt() < weekLabels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        weekLabels[value.toInt()],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: _Palette.textDark,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: weeklyData.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.toDouble(),
                  width: 22,
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [_Palette.accentPrimary, _Palette.accentSecondary],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
              showingTooltipIndicators: [0],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _monthlyAttendanceChart({
    required List<int> monthlyData,
    List<String>? monthLabels,
  }) {
    final data = List<int>.filled(4, 0);
    for (int i = 0; i < monthlyData.length && i < 4; i++) {
      data[i] = monthlyData[i];
    }

    final maxValue = data.isEmpty ? 0 : data.reduce((a, b) => a > b ? a : b);
    final maxY = (maxValue + 5).toDouble().clamp(5, 1000000);

    final total = data.fold<int>(0, (sum, v) => sum + v);

    final labels = monthLabels ?? _last4MonthsShortLabels();

    return _ChartCard(
      title:
          "Monthly Attendance (${DateFormat('yyyy').format(DateTime.now())})",
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_Palette.accentTertiary, Color(0xFF0B8C77)],
              ),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: _Palette.accentTertiary.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              "Total: $total",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 3,
          minY: 0,
          maxY: maxY.toDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.black.withOpacity(0.06), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: _Palette.textMuted,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index > 3) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      labels[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: _Palette.textDark,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: _Palette.accentTertiary,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    _Palette.accentTertiary.withOpacity(0.25),
                    _Palette.accentTertiary.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              gradient: const LinearGradient(
                colors: [_Palette.accentTertiary, _Palette.accentSecondary],
              ),
              spots: [
                FlSpot(0, data[0].toDouble()),
                FlSpot(1, data[1].toDouble()),
                FlSpot(2, data[2].toDouble()),
                FlSpot(3, data[3].toDouble()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> _last4MonthsShortLabels() {
    final now = DateTime.now();
    // Oldest -> newest
    return List.generate(4, (i) {
      final d = DateTime(now.year, now.month - (3 - i), 1);
      return DateFormat('MMM').format(d);
    });
  }
}


class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: _Palette.textMuted,
          ),
        ),
      ),
    );
  }
}

class _WeekStripHeaderCard extends StatelessWidget {
  final String currentTime;
  final bool isAM;
  final DateTime now;

  const _WeekStripHeaderCard({
    required this.currentTime,
    required this.isAM,
    required this.now,
  });

  String get _greeting {
    final h = now.hour;
    if (h < 5) return "Good Night";
    if (h < 12) return "Good Morning";
    if (h < 17) return "Good Afternoon";
    return "Good Evening";
  }

  IconData get _greetingIcon {
    final h = now.hour;
    if (h < 5 || h >= 19) return Icons.nightlight_round;
    if (h < 12) return Icons.wb_twilight_rounded;
    return Icons.wb_sunny_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final monday = now.subtract(Duration(days: now.weekday - 1));
    const dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_Palette.accentSecondary, _Palette.accentPrimary],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(_greetingIcon, size: 15, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                _greeting,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _Palette.textMuted,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _Palette.accentPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  DateFormat('MMMM yyyy').format(now),
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: _Palette.accentPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [_Palette.accentPrimary, _Palette.accentTertiary],
                ).createShader(bounds),
                child: Text(
                  currentTime,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'BebasNeue-Regular',
                    color: Colors.white,
                    height: 1,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Text(
                  isAM ? "AM" : "PM",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _Palette.textMuted,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final d = monday.add(Duration(days: i));
              final isToday =
                  d.day == now.day &&
                  d.month == now.month &&
                  d.year == now.year;

              return Column(
                children: [
                  Text(
                    dayLetters[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isToday
                          ? _Palette.accentPrimary
                          : _Palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: isToday
                          ? const LinearGradient(
                              colors: [
                                _Palette.accentPrimary,
                                _Palette.accentTertiary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isToday ? null : _Palette.bg,
                      shape: BoxShape.circle,
                      boxShadow: isToday
                          ? [
                              BoxShadow(
                                color: _Palette.accentPrimary.withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      d.day.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isToday ? Colors.white : _Palette.textDark,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? footer;

  const _ChartCard({required this.title, required this.child, this.footer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_Palette.cardStart, _Palette.cardEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14.5,
                  color: _Palette.accentPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(height: 200, child: child),
          if (footer != null) ...[const SizedBox(height: 12), footer!],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Icon(
            Icons.insert_chart_outlined_rounded,
            size: 42,
            color: _Palette.accentPrimary.withOpacity(0.4),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: _Palette.accentPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 34,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


class _Shimmer extends StatefulWidget {
  final Widget child;
  const _Shimmer({required this.child});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final t = _controller.value;
            return LinearGradient(
              colors: const [
                _Palette.shimmerBase,
                _Palette.shimmerHighlight,
                _Palette.shimmerBase,
              ],
              stops: const [0.35, 0.5, 0.65],
              begin: Alignment(-2 + 4 * t, -0.2),
              end: Alignment(-1 + 4 * t, 0.2),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const _ShimmerBlock({this.width, this.height = 16, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _Palette.shimmerBase,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class _SubjectPieShimmer extends StatelessWidget {
  const _SubjectPieShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 220,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _ShimmerBlock(width: 120, height: 14, radius: 6),
                const SizedBox(height: 20),
                _Shimmer(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      color: _Palette.shimmerBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const _ShimmerBlock(width: 90, height: 12, radius: 6),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChartCardShimmer extends StatelessWidget {
  final String title;
  const _ChartCardShimmer({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_Palette.cardStart, _Palette.cardEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                color: _Palette.accentPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (i) {
                final heights = [90.0, 140.0, 70.0, 160.0, 110.0];
                return _ShimmerBlock(width: 26, height: heights[i], radius: 8);
              }),
            ),
          ),
          const SizedBox(height: 14),
          const _ShimmerBlock(width: 100, height: 24, radius: 999),
        ],
      ),
    );
  }
}
