

import 'package:academic/app/modules/group_chat/group_chat_state.dart';

class EditGroupState {
  final String imageBase64;
  final String imageName;
  final GroupModel groupMembers;

  EditGroupState({
    this.imageBase64 = '',
    this.imageName = '',
    this.groupMembers = const GroupModel(),
  });

  EditGroupState copyWith({
    String? imageBase64,
    String? imageName,
    GroupModel? groupMembers,
  }) {
    return EditGroupState(
      imageBase64: imageBase64 ?? this.imageBase64,
      imageName: imageName ?? this.imageName,
      groupMembers: groupMembers ?? this.groupMembers,
    );
  }
}
