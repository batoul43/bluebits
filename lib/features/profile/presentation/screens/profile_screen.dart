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
  static const String _profileImageBaseUrl = "https://bluebits24.onrender.com/";
  Data? _profileData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshData(context);
    });
  }

  // فحص شامل لمعرفة ما إذا كانت الحالة الحالية عبارة عن أي حالة تحميل/رفع
  bool _isLoadingState(ProfileState state) {
    return state is ProfileLoading ||
        state is ProfileUpdateLoading ||
        state.runtimeType.toString().toLowerCase().contains('loading');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              _showSnackBar(context, state.message, theme.colorScheme.error);
            } else if (state is ProfileImageUploadSuccess) {
              _showSnackBar(context, "تم تحديث الصورة بنجاح", Colors.green);
              _refreshData(context);
            } else if (state is ProfileUpdateSuccess) {
              _showSnackBar(context, "تم تعديل الاسم بنجاح", Colors.green);
              _refreshData(context);
            } else if (state is ProfileUpdateError) {
              _showSnackBar(context, state.message, theme.colorScheme.error);
            }
          },
          builder: (context, state) {
            if (state is ProfileSuccess) {
              _profileData = state.data;
            } else if (state is ProfileUpdateSuccess) {
              _profileData = state.updatedData;
            }

            final bool isLoading = _isLoadingState(state);

            if (isLoading && _profileData == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              );
            }

            if (_profileData != null) {
              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async => await _refreshData(context),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * 0.03,
                        vertical: mediaQuery.height * 0.01,
                      ),
                      child: Column(
                        children: [
                          const PageHeader(title: 'الملف الشخصي', subtitle: ''),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: mediaQuery.width * 0.04,
                                vertical: mediaQuery.height * 0.02,
                              ),
                              children: [
                                _buildProfileAvatarHeader(
                                  context: context,
                                  profileData: _profileData!,
                                  isLoading: isLoading,
                                  mediaQuery: mediaQuery,
                                ),
                                SizedBox(height: mediaQuery.height * 0.03),
                                _buildInfoCard(
                                  _profileData!,
                                  theme,
                                  mediaQuery,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLoading)
                    LinearProgressIndicator(color: theme.colorScheme.primary),
                ],
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

  // --- عناصر الواجهة (UI Components) ---

  Widget _buildProfileAvatarHeader({
    required BuildContext context,
    required Data profileData,
    required bool isLoading,
    required Size mediaQuery,
  }) {
    final theme = Theme.of(context);
    final double avatarRadius = mediaQuery.width * 0.16;
    final double cameraButtonPadding = mediaQuery.width * 0.025;
    final double cameraIconSize = mediaQuery.width * 0.05;

    final String? imagePath = profileData.profileImage;
    final ImageProvider avatarImage =
        (imagePath != null && imagePath.isNotEmpty)
        ? NetworkImage(_profileImageUrl(imagePath))
        : const AssetImage('assets/images/avatar.png') as ImageProvider;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. صورة الملف الشخصي
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: theme.colorScheme.surface,
            backgroundImage: avatarImage,
          ),

          // 2. مؤشر التحميل شفاف يظهر فوق الصورة أثناء الرفع مباشرة
          if (isLoading)
            Container(
              width: avatarRadius * 2,
              height: avatarRadius * 2,
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                  width: mediaQuery.width * 0.08,
                  height: mediaQuery.width * 0.08,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: mediaQuery.width * 0.008,
                  ),
                ),
              ),
            ),

          // 3. زر الكاميرا (يتم تعطيل الضغط بـ AbsorbPointer عند التحميل)
          Positioned(
            bottom: 0,
            right: mediaQuery.width * 0.01,
            child: AbsorbPointer(
              absorbing: isLoading,
              child: InkWell(
                onTap: () => _pickAndUpload(context),
                borderRadius: BorderRadius.circular(100),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(cameraButtonPadding),
                  decoration: BoxDecoration(
                    color: isLoading ? Colors.grey : theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.scaffoldBackgroundColor,
                      width: 2.5,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: cameraIconSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Data profile, ThemeData theme, Size mediaQuery) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mediaQuery.width * 0.04),
      ),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.all(mediaQuery.width * 0.05),
        child: Column(
          children: [
            _infoTile(
              Icons.person,
              "الاسم",
              profile.name ?? "غير متوفر",
              theme,
              mediaQuery,
              onEdit: () => _showEditNameDialog(context, profile.name),
            ),
            Divider(color: theme.colorScheme.primary.withOpacity(0.1)),
            _infoTile(
              Icons.email,
              "البريد",
              profile.email ?? "غير متوفر",
              theme,
              mediaQuery,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String title,
    String value,
    ThemeData theme,
    Size mediaQuery, {
    VoidCallback? onEdit,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.02),
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
        size: mediaQuery.width * 0.06,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.grey,
          fontSize: mediaQuery.width * 0.035,
        ),
      ),
      subtitle: Text(
        value,
        style: theme.textTheme.titleMedium?.copyWith(
          fontSize: mediaQuery.width * 0.04,
        ),
      ),
      trailing: onEdit != null
          ? IconButton(
              icon: Icon(
                Icons.edit,
                color: theme.colorScheme.primary,
                size: mediaQuery.width * 0.055,
              ),
              onPressed: onEdit,
            )
          : null,
    );
  }

  String _profileImageUrl(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    return '$_profileImageBaseUrl${imagePath.replaceFirst(RegExp(r'^/+'), '')}';
  }

  // --- الدوال والعمليات (Logic Functions) ---

  void _showSnackBar(BuildContext context, String? message, Color color) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message ?? 'حدث خطأ غير متوقع'),
          backgroundColor: color,
        ),
      );
    }
  }

  Future<void> _showEditNameDialog(
    BuildContext context,
    String? currentName,
  ) async {
    final TextEditingController controller = TextEditingController(
      text: currentName ?? '',
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تعديل الاسم'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'الاسم الجديد'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isEmpty) {
                  _showSnackBar(context, 'الرجاء إدخال اسم جديد', Colors.red);
                  return;
                }
                Navigator.pop(context);

                if (_profileData != null) {
                  setState(() {
                    _profileData!.name = newName;
                  });
                }

                _updateName(context, newName);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateName(BuildContext context, String newName) async {
    String? token = await CachHelper.getValue('Token');
    if (!mounted || !context.mounted) return;
    if (token == null) {
      _showSnackBar(context, 'لم يتم العثور على توكن المستخدم', Colors.red);
      return;
    }
    context.read<ProfileCubit>().updateProfile({'name': newName}, token);
  }

  Future<void> _pickAndUpload(BuildContext context) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (!mounted || !context.mounted) return;
      if (image == null) return;

      final imageFile = File(image.path);
      if (!await imageFile.exists()) {
        if (!mounted || !context.mounted) return;
        _showSnackBar(context, 'تعذر الوصول إلى الصورة المختارة', Colors.red);
        return;
      }

      String? token = await CachHelper.getValue('Token');
      if (!mounted || !context.mounted) return;
      if (token == null) {
        _showSnackBar(context, 'لم يتم العثور على توكن المستخدم', Colors.red);
        return;
      }

      context.read<ProfileCubit>().uploadImage(imageFile, token);
    } catch (e) {
      if (!mounted || !context.mounted) return;
      _showSnackBar(context, 'حدث خطأ أثناء اختيار الصورة: $e', Colors.red);
    }
  }
}

Future<void> _refreshData(BuildContext context) async {
  String? token = await CachHelper.getValue('Token');
  if (context.mounted && token != null) {
    context.read<ProfileCubit>().loadProfile(token);
  }
}
