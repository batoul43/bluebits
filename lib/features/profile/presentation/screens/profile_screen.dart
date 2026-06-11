import 'dart:io';
import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/page_headers.dart';
import 'package:bluebits_app/features/profile/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bluebits_app/features/profile/presentation/logic/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String baseUrl = "http://bluebits24.onrender.com/";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // استخدام MediaQuery للحصول على أبعاد الشاشة
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              _showSnackBar(context, state.message, theme.colorScheme.error);
            } else if (state is ProfileImageUploadSuccess) {
              _showSnackBar(context, "تم تحديث الصورة بنجاح", Colors.green);
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              );
            }

            if (state is ProfileSuccess) {
              final Data p = state.data;
              return RefreshIndicator(
                onRefresh: () async => await _refreshData(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      PageHeader(title: 'الملف الشخصي', subtitle: ''),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                            vertical: size.height * 0.02,
                          ),
                          children: [
                            _buildProfileHeader(context, p, size),
                            SizedBox(height: size.height * 0.03),
                            _buildInfoCard(p, theme),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return InkWell(
              onTap: () async => await _refreshData(context),
              child: Center(
                child: Text(
                  'اضغط لتحديث البيانات',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- دوال البناء ---

  Widget _buildProfileHeader(BuildContext context, Data p, Size size) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: size.width * 0.15, // حجم ديناميكي للصورة
            backgroundColor: Theme.of(context).colorScheme.surface,
            backgroundImage:
                p.profileImage != null && p.profileImage!.isNotEmpty
                ? NetworkImage(baseUrl + p.profileImage!)
                : const AssetImage('assets/images/avatar.png') as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () => _pickAndUpload(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Data p, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _infoTile(Icons.person, "الاسم", p.name ?? "غير متوفر", theme),
            Divider(color: theme.colorScheme.primary.withOpacity(0.1)),
            _infoTile(Icons.email, "البريد", p.email ?? "غير متوفر", theme),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value, ThemeData theme) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
      ),
      subtitle: Text(value, style: theme.textTheme.titleMedium),
    );
  }

  // --- دوال منطقية ---

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<void> _pickAndUpload(BuildContext context) async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    String? token = await CachHelper.getValue('Token');
    if (image != null && token != null) {
      context.read<ProfileCubit>().uploadImage(File(image.path), token);
    }
  }
}

Future<void> _refreshData(BuildContext context) async {
  String? token = await CachHelper.getValue('Token');
  if (token != null) {
    context.read<ProfileCubit>().loadProfile(token);
  }
}
