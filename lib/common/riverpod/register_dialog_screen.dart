import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/custom_map/components/const/data.dart';

final userNameProvider = StateProvider<String>((ref) => 'No name');
final userProfileImagePathProvider = StateProvider<String>((ref) => MY_PROFILE_IMAGE_PATH);
