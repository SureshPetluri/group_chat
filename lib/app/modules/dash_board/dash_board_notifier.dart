import 'package:academic/app/modules/dash_board/dash_board_state.dart';
import 'package:academic/app/modules/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../group_chat/group_chat_notifier.dart';
import '../group_chat/group_chat_screen.dart';

class DashBoardNotifier extends StateNotifier<DashBoardState> {
  DashBoardNotifier() : super(DashBoardState());

  List<Widget> pages = [
    const HomeScreen(),
    const GroupScreen()
  ];
  onItemSelected(int index,WidgetRef ref){
    state = state.copyWith(selectedIndex: index);

    if(index==1){
      ref.read(groupChatProvider.notifier).fetchGroups();
    }
  }

}

final dashBoardProvider =
    StateNotifierProvider<DashBoardNotifier, DashBoardState>(
  (ref) => DashBoardNotifier(),
);
