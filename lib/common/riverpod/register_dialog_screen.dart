import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/custom_map/components/const/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userNameProvider = StateProvider<String>((ref) => 'No name');
final userProfileImagePathProvider = StateProvider<String>((ref) => MY_PROFILE_IMAGE_PATH);

class RegisteredUserInfoModel {
  String userName;
  String userProfileImagePath;

  RegisteredUserInfoModel({
    required this.userName,
    required this.userProfileImagePath,
  });
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userProfileImagePath': userProfileImagePath,
    };
  }

  factory RegisteredUserInfoModel.fromMap(Map<String, dynamic> map) {
    return RegisteredUserInfoModel(
      userName: map['userName'] ?? '',
      userProfileImagePath: map['userProfileImagePath' ?? ''],
    );
  }
}

final registeredUserInfoProvider =
    StateNotifierProvider<RegisteredUserInfoNotifier, RegisteredUserInfoModel>((ref) => RegisteredUserInfoNotifier());

class RegisteredUserInfoNotifier extends StateNotifier<RegisteredUserInfoModel> {
  RegisteredUserInfoNotifier()
      : super(RegisteredUserInfoModel(
          userName: 'No name',
          userProfileImagePath: MY_PROFILE_IMAGE_PATH,
        )) {
    _loadRegisteredUserInfo();
  }

  // Load user profile from storage
  Future<void> _loadRegisteredUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName') ?? 'No name';
    final userProfileImagePath = prefs.getString('userProfileImagePath') ?? MY_PROFILE_IMAGE_PATH;
    state = RegisteredUserInfoModel(userName: userName, userProfileImagePath: userProfileImagePath);
  }

  Future<void> _saveUserProfileToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', state.userName);
    await prefs.setString('userProfileImagePath', state.userProfileImagePath);
  }

  void setUserName(String name) {
    state = RegisteredUserInfoModel(userName: name, userProfileImagePath: state.userProfileImagePath);
    _saveUserProfileToStorage();
  }

  void setUserImage(String imagePath) {
    state = RegisteredUserInfoModel(userName: state.userName, userProfileImagePath: imagePath);
    _saveUserProfileToStorage();
  }
}
