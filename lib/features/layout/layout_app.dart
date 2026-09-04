import 'package:bluebits_app/core/shares/acadimic_tasks/data/academic_tasks_repository/academic_tasks_repository.dart';
import 'package:bluebits_app/core/shares/acadimic_tasks/data/api_service/acaddemic_tasks_api_service.dart';
import 'package:bluebits_app/core/shares/acadimic_tasks/logic/academic_task_cubit.dart';
import 'package:bluebits_app/core/shares/announcement/data/api_service/announcement_api_service.dart';
import 'package:bluebits_app/core/shares/announcement/data/repository/announcement_repository.dart';
import 'package:bluebits_app/core/shares/announcement/logic/announcement_cubit.dart';
import 'package:bluebits_app/core/shares/lessonslacture/data/api_service/lesson_lecture_api_service.dart';
import 'package:bluebits_app/core/shares/lessonslacture/data/repositry/lesson_lecture_repository.dart';
import 'package:bluebits_app/core/shares/lessonslacture/lessonlecturecubit/lesson_lecture_cubit.dart';
import 'package:bluebits_app/core/shares/question_banks/data/api_service/question_bank_api_service.dart';
import 'package:bluebits_app/core/shares/question_banks/data/repository/question_banks_repository.dart';
import 'package:bluebits_app/core/shares/question_banks/logic/question_bank_cubit.dart';
import 'package:bluebits_app/core/shares/semester/data/api_service/semester_api_service.dart';
import 'package:bluebits_app/core/shares/semester/data/repositry/semester_repositry.dart';
import 'package:bluebits_app/core/shares/semester/semester_cubit/semester_cubit.dart';
import 'package:bluebits_app/core/shares/subjects/data/api_Service/subject_api_service.dart';
import 'package:bluebits_app/core/shares/subjects/data/repositry/subjects_repositry.dart';
import 'package:bluebits_app/core/shares/subjects/subjects_cubit/subject_cubit.dart';
import 'package:bluebits_app/core/shares/years/data/api_service/year_api_service.dart';
import 'package:bluebits_app/core/shares/years/data/repositry/year_repositry.dart';
import 'package:bluebits_app/core/shares/years/presentation/logic/year_cubit.dart';
import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/core/widget/chat_bot_fab.dart';
import 'package:bluebits_app/core/widget/custom_app_bar.dart';
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/screens/admin_control_panel_screen.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/home/presentation/home_screen.dart';
import 'package:bluebits_app/features/lectures/presentation/logic/cubit/lectures_cubit.dart';
import 'package:bluebits_app/features/lectures/presentation/screen/lectures_screen.dart';
import 'package:bluebits_app/features/profile/data/api_service/profile_api.dart';
import 'package:bluebits_app/features/profile/data/repository/profile_repo.dart';
import 'package:bluebits_app/features/profile/presentation/logic/profile_cubit.dart';
import 'package:bluebits_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:bluebits_app/features/question_banks/presentation/logic/cubit/bank_cubit.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/features/question_banks/presentation/screens/question_banks_screen.dart';
import 'package:bluebits_app/features/schedule_setting/data/api_Service/schedule_setting_api_service.dart';
import 'package:bluebits_app/features/schedule_setting/data/repository/schedule_setting_repository.dart';
import 'package:bluebits_app/features/schedule_setting/presentation/logic/schedule_setting_cubit.dart';
import 'package:bluebits_app/features/schedule_setting/presentation/screen/schedule_setting_screen.dart';
import 'package:bluebits_app/features/surveys/surveys_admin/data/api_service/admin_api_service.dart';
import 'package:bluebits_app/features/surveys/surveys_admin/data/repository/admin_survey_repository.dart';
import 'package:bluebits_app/features/surveys/surveys_admin/presentation/logic/admin_survey_cubit.dart';
import 'package:bluebits_app/features/surveys/surveys_admin/presentation/screens/admin_survey_sceen.dart';
import 'package:bluebits_app/features/surveys/surveys_student/data/surveys_api_service/student_surveys_api_service.dart';
import 'package:bluebits_app/features/surveys/surveys_student/data/surveys_repository/student_surveys_repository.dart';
import 'package:bluebits_app/features/surveys/surveys_student/presentation/logic/student_survey_cubit.dart';
import 'package:bluebits_app/features/surveys/surveys_student/presentation/screen/student_surveys_screen.dart';
import 'package:bluebits_app/features/tasks/presentation/logic/cubit/acadimmictask_cubit.dart';
import 'package:bluebits_app/features/tasks/presentation/logic/cubit/task_cubit.dart';
import 'package:bluebits_app/features/tasks/presentation/screens/task_secreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutApp extends StatefulWidget {
  const LayoutApp({super.key});

  @override
  State<LayoutApp> createState() => _LayoutAppState();
}

class _LayoutAppState extends State<LayoutApp> {
  final ValueNotifier<int> _selectedDrawerIndex = ValueNotifier(0);
  final ProfileCubit _profileCubit = ProfileCubit(
    repo: ProfileRepo(profileApi: ProfileApi()),
  );

  late final List<Widget> _pages;

  static const String _profileImageBaseUrl = 'https://bluebits24.onrender.com/';

  // تمت إضافة هذه المتغيرات للاحتفاظ بالبيانات القديمة حتى نجاح التحديث
  String _cachedAccountName = "مستخدم";
  String _cachedAccountEmail = "غير متوفر";
  ImageProvider _cachedAvatar = const AssetImage('assets/images/avatar.png');

  @override
  void initState() {
    super.initState();
    _pages = [
      BlocProvider(
        create: (context) => AnnouncementCubit(
          repository: AnnouncementRepository(AnnouncementApiService()),
        )..fetchAllAnnouncements(),
        child: const HomeScreen(),
      ),
      BlocProvider(
        create: (context) => LecturesCubit()..backToYears(),
        child: const LecturesScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BankCubit()..backTOYear()),
          BlocProvider(
            create: (context) => QuestionBankCubit(
              repository: QuestionBankRepository(QuestionBankApiService()),
            ),
          ),
        ],
        child: QuestionBanksScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TaskCubit()..loadTasks()),
          BlocProvider(create: (context) => AcadimmictaskCubit()..backTOYear()),
          BlocProvider(
            create: (context) => AcademicTaskCubit(
              repository: AcademicTaskRepository(AcademicTaskApiService()),
            ),
          ),
        ],
        child: TasksScreen(),
      ),
      const ProfileScreen(),
      const AdminControlPanelScreen(),
      const AdminSurveyScreen(),
      const StudentSurveysScreen(),
      const ScheduleSettingsScreen(),
    ];

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final token = await CachHelper.getValue('Token');
    if (token != null) {
      _profileCubit.loadProfile(token);
    }
  }

  @override
  void dispose() {
    _selectedDrawerIndex.dispose();
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _profileCubit,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                YearCubit(repository: YearRepository(YearApiService()))
                  ..fetchAllYears(),
          ),
          BlocProvider(
            create: (context) => SemesterCubit(
              repository: SemesterRepository(SemesterApiService()),
            )..fetchAllSemesters(),
          ),
          BlocProvider(
            create: (context) =>
                SubjectCubit(SubjectRepository(SubjectApiService())),
          ),
          BlocProvider(
            create: (context) => LessonLectureCubit(
              repository: LessonLectureRepository(LessonLectureApiService()),
            )..fetchAllLectures(),
          ),
          BlocProvider(
            create: (context) => AdminSurveyCubit(
              repository: AdminSurveyRepository(AdminSurveyApiService()),
            ),
          ),
          BlocProvider(
            create: (context) => StudentSurveyCubit(
              repository: StudentSurveyRepository(StudentSurveyApiService()),
            ),
          ),
          BlocProvider(
            create: (context) => ScheduleSettingCubit(
              repository: ScheduleSettingRepository(
                ScheduleSettingApiService(),
              ),
            ),
          ),
        ],
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLogoutFailed) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is AuthLogoutSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
              );
            }
          },
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            drawer: _buildSideDrawer(screenWidth, context),
            appBar: CustomAppBar(),
            floatingActionButton: ChatBotFab(),
            body: SafeArea(
              child: ValueListenableBuilder(
                valueListenable: _selectedDrawerIndex,
                builder: (context, selectedDrawerIndex, child) {
                  return Stack(
                    children: List<Widget>.generate(
                      _pages.length,
                      (index) => Offstage(
                        offstage: index != selectedDrawerIndex,
                        child: _pages[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerTile(
    int index,
    IconData icon,
    String title,
    double width,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StatefulBuilder(
      builder: (context, setStateDrowerTile) {
        bool isSelected = _selectedDrawerIndex.value == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Material(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            child: ListTile(
              leading: Icon(
                icon,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface.withOpacity(0.7),
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                setStateDrowerTile(() {
                  _selectedDrawerIndex.value = index;
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSideDrawer(double width, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      width: width * 0.75,
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              // نقوم بتحديث البيانات المخزنة فقط إذا نجحت العملية
              // أما إذا كانت الحالة جاري التحميل، سيتم استخدام البيانات المخزنة القديمة
              if (state is ProfileSuccess) {
                _cachedAccountName = state.data.name ?? _cachedAccountName;
                _cachedAccountEmail = state.data.email ?? _cachedAccountEmail;

                if (state.data.profileImage != null &&
                    state.data.profileImage!.isNotEmpty) {
                  final imagePath = state.data.profileImage!;
                  final imageUrl =
                      imagePath.startsWith('http://') ||
                          imagePath.startsWith('https://')
                      ? imagePath
                      : '$_profileImageBaseUrl${imagePath.replaceFirst(RegExp(r'^/+'), '')}';
                  _cachedAvatar = NetworkImage(imageUrl);
                }
              }

              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: colorScheme.surface),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  backgroundImage: _cachedAvatar,
                  onBackgroundImageError: (exception, stackTrace) {
                    // التقاط خطأ جلب الصورة بصمت لتجنب انهيار الواجهة
                  },
                ),
                accountName: Text(
                  _cachedAccountName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                accountEmail: Text(
                  _cachedAccountEmail,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: ColorsManager.greyText,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerTile(
                  0,
                  Icons.home_outlined,
                  "الرئيسية",
                  width,
                  context,
                ),
                _buildDrawerTile(
                  1,
                  Icons.book_outlined,
                  "المحاضرات",
                  width,
                  context,
                ),
                _buildDrawerTile(
                  2,
                  Icons.quiz_outlined,
                  "بنوك الأسئلة",
                  width,
                  context,
                ),
                _buildDrawerTile(
                  3,
                  Icons.task_alt,
                  "قائمة المهام",
                  width,
                  context,
                ),
                _buildDrawerTile(
                  4,
                  Icons.person_outline,
                  "الملف الشخصي",
                  width,
                  context,
                ),
                _buildDrawerTile(
                  5,
                  Icons.admin_panel_settings,
                  "لوحة التحكم",
                  width,
                  context,
                ),
                _buildDrawerTile(
                  6,
                  Icons.poll_outlined,
                  "إدارة الاستبيانات",
                  width,
                  context,
                ),
                _buildDrawerTile(
                  7,
                  Icons.assignment,
                  "استبيان المقررات",
                  width,
                  context,
                ),
                _buildDrawerTile(
                  8,
                  Icons.edit_calendar_outlined,
                  "إعدادات الجدولة",
                  width,
                  context,
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: colorScheme.error),
            title: Text(
              "تسجيل الخروج",
              style: TextStyle(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
