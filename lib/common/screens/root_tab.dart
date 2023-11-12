import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/common/provider/register_dialog_screen.dart';
import 'package:frontend/common/screens/bottom_navigation_test_screen.dart';
import 'package:frontend/custom_map/screens/map_screen.dart';
import 'package:frontend/friend/screens/request_screen.dart';
import 'package:frontend/friend/screens/search_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController tabController;
  int bottomNavigationBarCurrentIndex = 0;

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
              Icons.people,
            ),
            label: '친구',
          ),
        ],
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          MapScreen(),
          RequestScreen(),
        ],
      ),
    );
  }
}
