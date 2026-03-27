import 'package:attendance_system_flutter_application/Providers/riverpod.dart';
import 'package:attendance_system_flutter_application/Widgets/SubjectAttendancePrecentage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:async';

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

    //Auto-scroll
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

  // Week calculation
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

    // Optional: remove last week if empty
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

  // Returns the weekday name, e.g., "Friday"
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
    // Calculate Monday of current week
    final monday = date.subtract(Duration(days: date.weekday - 1));
    // Calculate Friday of current week
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

  // Returns formatted date, e.g., "11 September"
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

  Widget build(BuildContext context) {
    final ref = this.ref;
    final attendanceCount = ref.watch(userAttendanceCountProvider);
    final history = ref.watch(userHistoryProvider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 5,
                top: 10,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 233, 236, 215),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "${currentTime} ${DateTime.now().hour >= 0 && DateTime.now().hour < 12 ? "AM" : "PM"}",
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'BebasNeue-Regular',
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 72, 194, 242),
                            border: Border.all(
                              color: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ), // Border color
                              width: 3, // Thickness of the border
                            ),
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Rounded corners
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  getWeekDay(DateTime.now()),
                                  style: const TextStyle(
                                    fontSize: 27,
                                    fontFamily: 'BebasNeue-Regular',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                Text(
                                  getFormattedDate(DateTime.now()),
                                  style: const TextStyle(
                                    fontSize: 27,
                                    fontFamily: 'BebasNeue-Regular',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                attendanceCount.when(
                  data: (itemList) {
                    if (itemList.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            "No Attendance Data Available!",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(2, 109, 148, 1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
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
                                color: _currentPage == index
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      child: const Center(
                        child: SpinKitThreeBounce(
                          color: Colors.blue,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  error: (e, st) => Center(child: Text("Error: $e")),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: [
                const SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: history.when(
                    data: (itemList) {
                      if (itemList.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text(
                              "No Attendance Weekly Data!",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(2, 109, 148, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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
                    loading: () => const Center(
                      child: SpinKitThreeBounce(color: Colors.blue, size: 30.0),
                    ),
                    error: (e, st) => Center(child: Text("Error: $e")),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: history.when(
                    data: (itemList) {
                      if (itemList.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text(
                              "No Attendance Monthly Data!",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(2, 109, 148, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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
                    loading: () => const Center(
                      child: SpinKitThreeBounce(color: Colors.blue, size: 30.0),
                    ),
                    error: (e, st) => Center(child: Text("Error: $e")),
                  ),
                ),
              ],
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Chart 1: Weekly Attendance (Bar)
  Widget _weeklyAttendanceChart({required List<dynamic> weeklyData}) {
    final maxY = (weeklyData.reduce((a, b) => a > b ? a : b)) + 5;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 236, 215),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                "Weekly Attendance (${DateFormat('MMMM yyyy').format(DateTime.now())})",
                style: const TextStyle(
                  fontSize: 15,
                  color: Color.fromRGBO(2, 109, 148, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
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
                          color: Colors.black,
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
                            color: Colors.black87,
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
                          colors: [Colors.blue, Colors.lightBlueAccent],
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
          ),
        ],
      ),
    );
  }

  // Chart 3: Monthly Attendance (Line)
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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 236, 215),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                "Monthly Attendance (${DateFormat('yyyy').format(DateTime.now())})",
                style: const TextStyle(
                  fontSize: 15,
                  color: Color.fromRGBO(2, 109, 148, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 3,
                minY: 0,
                maxY: maxY.toDouble(),
                gridData: FlGridData(show: true, drawVerticalLine: false),
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
                            color: Colors.black87,
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
                        if (index < 0 || index > 3)
                          return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            labels[index],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                    ), // area fill (optional)
                    color: Colors.teal,
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
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  "Total: $total",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
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
