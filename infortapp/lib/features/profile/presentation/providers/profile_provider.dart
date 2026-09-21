import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../auth/domain/user.dart';
import '../../data/profile_api.dart';

final profileApiProvider = Provider<ProfileApi>((ref) {
  return ProfileApi(ref.watch(apiClientProvider));
});

final profileControllerProvider = Provider<ProfileController>((ref) {
  return ProfileController(ref.watch(profileApiProvider));
});

class ProfileController {
  ProfileController(this._api);

  final ProfileApi _api;

  Future<FounderUser> update({String? name, String? phone}) async {
    final response = await _api.update(name: name, phone: phone);
    return FounderUser.fromJson(response['data'] as Map<String, dynamic>);
  }
}
