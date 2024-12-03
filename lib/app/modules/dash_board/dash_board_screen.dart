import 'package:academic/app/modules/dash_board/dash_board_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/theme/color_theme.dart';

class DashBoardScreen extends ConsumerWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dashBoard = ref.watch(dashBoardProvider);
    var dashBoardNotifier = ref.read(dashBoardProvider.notifier);
    return Scaffold(
      backgroundColor: background,
      body: dashBoardNotifier.pages.elementAt(dashBoard.selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
                color: dashBoard.selectedIndex == 0 ? background : appBarColor,
                size: dashBoard.selectedIndex == 0 ? 25 : 20,
              ),
              label: "Users"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.group_add,
                color: dashBoard.selectedIndex == 1 ? background : appBarColor,
                size: dashBoard.selectedIndex == 1 ? 25 : 20,
              ),
              label: "Groups")
        ],
        currentIndex: dashBoard.selectedIndex,
        selectedLabelStyle: const TextStyle(color: background, fontSize: 14),
        selectedItemColor: background,
        selectedFontSize: 14,
        selectedIconTheme: const IconThemeData(color: background, size: 25),
        unselectedLabelStyle: const TextStyle(color: appBarColor, fontSize: 12),
        unselectedIconTheme: const IconThemeData(color: appBarColor, size: 20),
        onTap:(int index)=> dashBoardNotifier.onItemSelected(index,ref),
      ),
    );
  }
}
