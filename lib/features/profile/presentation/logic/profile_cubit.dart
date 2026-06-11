import 'package:bloc/bloc.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/features/profile/data/models/profile_model.dart';
import 'package:bluebits_app/features/profile/data/repository/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.repo}) : super(ProfileInitial());
  final ProfileRepo repo;

  Future<ProfileModel?> loadProfile() async {
    try {
      emit(ProfileLoading());
      final token = await CachHelper.getValue('Token');
      if (token == null) {
        emit(ProfileError(message: 'No token found'));
        return null;
      }
      final profile = await repo.getProfile(token);
      if (profile != null) {
        emit(ProfileLoaded(profile: profile));
        return profile;
      } else {
        emit(ProfileError(message: 'Failed to load profile'));
        return null;
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
      return null;
    }
  }
}
