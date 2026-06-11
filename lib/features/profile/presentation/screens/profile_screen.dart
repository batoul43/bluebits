import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluebits_app/features/profile/presentation/logic/profile_cubit.dart';
import 'package:bluebits_app/features/profile/data/api_service/profile_api.dart';
import 'package:bluebits_app/features/profile/data/repository/profile_repo.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProfileCubit(repo: ProfileRepo(profileApi: ProfileApi()))
            ..loadProfile(),
      child: Scaffold(
        appBar: AppBar(title: const Text('البروفايل')),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final p = state.profile;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: p.photo != null && p.photo!.isNotEmpty
                            ? NetworkImage(p.photo!) as ImageProvider
                            : const AssetImage('assets/images/avatar.png'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'الاسم: ${p.name ?? '-'}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'البريد: ${p.email ?? '-'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().loadProfile(),
                      child: const Text('تحديث'),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text('خطأ: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
