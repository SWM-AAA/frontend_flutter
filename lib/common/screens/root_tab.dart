import 'package:flutter/material.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/custom_map/screens/bottom_navigation_test_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController tabController;
  int bottomNavigationBarCurrentIndex = 1;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: bottomNavigationBarCurrentIndex,
    );

    tabController.addListener(bottomNavigationBarTabListener);
  }

  void bottomNavigationBarTabListener() {
    setState(() {
      bottomNavigationBarCurrentIndex = tabController.index;
    });
  }

  @override
  void dispose() {
    super.dispose();

    tabController.removeListener(bottomNavigationBarTabListener);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Zeppy',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        type: BottomNavigationBarType.fixed,
        onTap: (int selectedIndex) {
          tabController.animateTo(
            selectedIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        currentIndex: bottomNavigationBarCurrentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map_outlined,
            ),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: '마이페이지',
          ),
        ],
      ),
      child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            BottomNavigationTestScreen(testScreenName: '지도 스크린'),
            BottomNavigationTestScreen(testScreenName: '홈 스크린'),
            BottomNavigationTestScreen(testScreenName: '마이페이지 스크린'),
          ]),
    );
  }
}
