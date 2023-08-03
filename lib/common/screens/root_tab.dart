import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/common/riverpod/register_dialog_screen.dart';
import 'package:frontend/common/screens/bottom_navigation_test_screen.dart';
import 'package:frontend/custom_map/screens/map_screen.dart';

class RootTab extends ConsumerStatefulWidget {
  const RootTab({super.key});

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab> with SingleTickerProviderStateMixin {
  late TabController tabController;
  int bottomNavigationBarCurrentIndex = 1;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 2,
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
    final userNameWatch = ref.watch(registeredUserInfoProvider).userName;
    final userProfileImagePathWatch = ref.watch(registeredUserInfoProvider).userProfileImagePath;

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
        ],
      ),
      child: TabBarView(physics: const NeverScrollableScrollPhysics(), controller: tabController, children: [
        MapScreen(userName: userNameWatch.toString(), userProfileImagePath: userProfileImagePathWatch.toString()),
        BottomNavigationTestScreen(testScreenName: '홈 스크린'),
      ]),
    );
  }
}
