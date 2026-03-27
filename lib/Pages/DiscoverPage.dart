import 'package:attendance_system_flutter_application/Models/Notification_Model.dart';
import 'package:attendance_system_flutter_application/Pages/AnalyticsPage.dart';
import 'package:attendance_system_flutter_application/Pages/HistoryPage.dart';
import 'package:attendance_system_flutter_application/Pages/OptionPage.dart';
import 'package:attendance_system_flutter_application/Pages/ProfilePage.dart';
import 'package:attendance_system_flutter_application/Providers/NotificationProvider.dart';
import 'package:attendance_system_flutter_application/Providers/riverpod.dart';
import 'package:attendance_system_flutter_application/Services/Firebase_Services.dart';
import 'package:attendance_system_flutter_application/Services/NotificationServices.dart';
import 'package:attendance_system_flutter_application/Widgets/Notification_Box.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:animated_icon/animated_icon.dart';

class Discoverpage extends ConsumerStatefulWidget {
  int pagenumber = 0;
  Discoverpage({required this.pagenumber, Key? key}) : super(key: key);

  @override
  ConsumerState<Discoverpage> createState() => _DiscoverpageState();
}

class _DiscoverpageState extends ConsumerState<Discoverpage> {
  late PageController _pageController;
  late NotchBottomBarController _controller;

  int _selectedIndex = 0;
  final int maxCount = 4;

  @override
  void initState() {
    _selectedIndex = widget.pagenumber;
    _pageController = PageController(initialPage: _selectedIndex);
    _controller = NotchBottomBarController(index: _selectedIndex);
    super.initState();

    FirebaseServices.getCurrent_User_Details().then((value) {
      ref
          .read(riverpodUserData)
          .UserData_Add(
            birthday: value[0].birthday.toString(),
            userImage: value[0].userimage.toString(),
            id: value[0].id.toString(),
            initialname: value[0].initialname.toString(),
            fullname: value[0].fullname.toString(),
            email: value[0].email.toString(),
            degreename: value[0].degreename.toString(),
            faculty: value[0].faculty.toString(),
            department: value[0].department.toString(),
            mobilenumber: value[0].mobilenumber.toString(),
            registernumber: value[0].registernumber.toString(),
            year: value[0].year.toString(),
            semester: value[0].semester.toString(),
          );
    });

    // Connect NotificationServices to Riverpod
    NotificationServices.onNotificationReceived = (RemoteMessage message) {
      final newNotification = AppNotification(
        id: message.messageId ?? DateTime.now().toString(),
        title: message.notification?.title ?? "No Title",
        body: message.notification?.body ?? "No Body",
        timestamp: DateTime.now(),
      );
      ref.read(notificationProvider.notifier).addNotification(newNotification);
    };
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      Analyticspage(),
      Optionpage(),
      HistoryPage(),
      ProfilePage(),
    ];
    final notifications = ref.watch(notificationProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(2, 109, 148, 1),
          actions: [
            Consumer(
              builder: (context, ref, child) {
                // Watch the notification provider
                final notifications = ref.watch(notificationProvider);
                // Count unread notifications
                final unreadCount = notifications
                    .where((n) => !n.isViewed)
                    .length;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => NotificationBox(ref: ref),
                        );
                      },
                      icon: const Icon(Icons.notifications),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          title: _selectedIndex == 1
              ? Text("Options")
              : _selectedIndex == 2
              ? Text("History")
              : _selectedIndex == 3
              ? Text("Profile")
              : (ref.watch(riverpodUserData).UserData == null ||
                    ref.watch(riverpodUserData).UserData.isEmpty)
              ? Text(
                  "Loading..",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                )
              : Text(
                  "${(DateTime.now().hour >= 5 && DateTime.now().hour < 12)
                          ? "Good Morning, "
                          : (DateTime.now().hour >= 12 && DateTime.now().hour < 17)
                          ? "Good Afternoon, "
                          : (DateTime.now().hour >= 17 && DateTime.now().hour < 21)
                          ? "Good Evening, "
                          : "Good Night, "} ${ref.watch(riverpodUserData).UserData[0].initialname}" ??
                      "No Name",
                  style: TextStyle(
                    color: Color.fromARGB(255, 253, 253, 253),
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
          foregroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(color: const Color.fromRGBO(2, 109, 148, 1)),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: const Color.fromRGBO(245, 245, 245, 1),
                  ),
                ),
              ],
            ),
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: bottomBarPages,
            ),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: (bottomBarPages.length <= maxCount)
            ? AnimatedNotchBottomBar(
                notchBottomBarController: _controller,
                color: Color.fromRGBO(2, 109, 148, 1),
                showLabel: true,
                textOverflow: TextOverflow.visible,
                maxLine: 1,
                shadowElevation: 5,
                kBottomRadius: 28.0,
                notchColor: Color.fromRGBO(148, 190, 211, 1),
                removeMargins: false,
                bottomBarWidth: 500,
                bottomBarHeight: 50,
                showShadow: false,
                showBlurBottomBar: true,
                blurOpacity: 1.0,
                durationInMilliSeconds: 300,
                itemLabelStyle: const TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.red,
                  decorationStyle: TextDecorationStyle.double,
                ),
                elevation: 7,
                bottomBarItems: [
                  BottomBarItem(
                    inActiveItem: const Icon(
                      Icons.home,
                      size: 27,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    activeItem: AnimateIcon(
                      key: UniqueKey(),
                      onTap: () {},
                      iconType: IconType.continueAnimation,
                      height: 300,
                      width: 300,
                      color: const Color.fromARGB(255, 0, 26, 32),
                      animateIcon: AnimateIcons.home,
                    ),
                  ),
                  BottomBarItem(
                    inActiveItem: const Icon(
                      Icons.online_prediction_rounded,
                      size: 27,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    activeItem: AnimateIcon(
                      key: UniqueKey(),
                      onTap: () {},
                      iconType: IconType.continueAnimation,
                      height: 300,
                      width: 300,
                      color: const Color.fromARGB(255, 0, 26, 32),
                      animateIcon: AnimateIcons.qrCode,
                    ),
                  ),
                  BottomBarItem(
                    inActiveItem: const Icon(
                      Icons.history_rounded,
                      size: 27,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    activeItem: AnimateIcon(
                      key: UniqueKey(),
                      onTap: () {},
                      iconType: IconType.continueAnimation,
                      height: 300,
                      width: 300,
                      color: const Color.fromARGB(255, 0, 26, 32),
                      animateIcon: AnimateIcons.activity,
                    ),
                  ),
                  BottomBarItem(
                    inActiveItem: const Icon(
                      Icons.person_4_sharp,
                      size: 27,
                      color: Color.fromARGB(255, 238, 238, 238),
                    ),
                    activeItem: AnimateIcon(
                      key: UniqueKey(),
                      onTap: () {},
                      iconType: IconType.continueAnimation,
                      height: 300,
                      width: 300,
                      color: const Color.fromARGB(255, 0, 26, 32),
                      animateIcon: AnimateIcons.menu,
                    ),
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                    _pageController.jumpToPage(index);
                  });
                },
                kIconSize: 24.0,
              )
            : null,
      ),
    );
  }
}
