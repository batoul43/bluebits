import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/surveys/surveys_student/data/models/student_surveys_models.dart';
import 'package:bluebits_app/features/surveys/surveys_student/presentation/logic/student_survey_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSurveysScreen extends StatefulWidget {
  const StudentSurveysScreen({super.key});

  @override
  State<StudentSurveysScreen> createState() => _StudentSurveysScreenState();
}

class _StudentSurveysScreenState extends State<StudentSurveysScreen> {
  List<SurveyForm> _cachedSurveys = [];
  bool _isLoadingDialogOpen = false;

  String _selectedFormId = '';

  @override
  void initState() {
    super.initState();
    context.read<StudentSurveyCubit>().fetchActiveForms();
  }

  void _closeLoadingDialog(BuildContext context) {
    if (_isLoadingDialogOpen) {
      _isLoadingDialogOpen = false;
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('الاستبيانات والتقييمات'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<StudentSurveyCubit, StudentSurveyState>(
        listener: (context, state) {
          if (state is StudentSurveyActionSuccess) {
            _closeLoadingDialog(context);
            _showSnackBar(context, state.message, ColorsManager.green);
          } else if (state is StudentSurveyError) {
            _closeLoadingDialog(context);
            _showSnackBar(context, state.message, theme.colorScheme.error);
          } else if (state is StudentSurveyDetailLoaded) {
            _closeLoadingDialog(context);
            _showResponseDetailsDialog(
              context,
              state.surveyDetail,
              theme,
              size,
            );
          } else if (state is StudentResponsesLoaded) {
            _closeLoadingDialog(context);
            _showMyResponsesBottomSheet(context, state.responses, theme, size);
          } else if (state is StudentSurveyStatsLoaded) {
            _closeLoadingDialog(context);
            _showDynamicSubmitSurveyDialog(
              context,
              _selectedFormId,
              state.statsModel,
              theme,
              size,
            );
          }
        },
        builder: (context, state) {
          if (state is StudentSurveysLoaded) {
            _cachedSurveys = state.surveys;
          }

          return Column(
            children: [
              _buildTopActionHeader(context, theme),
              Expanded(child: _buildMainContent(state, theme, size)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopActionHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _showLoadingDialog(context, theme);
                context.read<StudentSurveyCubit>().fetchMyResponses();
              },
              icon: const Icon(Icons.history),
              label: const Text('سجل ردودي'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<StudentSurveyCubit>().fetchActiveForms();
              },
              icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
              label: Text(
                'تحديث',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: theme.colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    StudentSurveyState state,
    ThemeData theme,
    Size size,
  ) {
    if (state is StudentSurveyLoading && _cachedSurveys.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    } else if (state is StudentSurveyError && _cachedSurveys.isEmpty) {
      return _buildErrorState(context, state.message, theme);
    } else if (_cachedSurveys.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _cachedSurveys.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildSurveyCard(context, _cachedSurveys[index], theme, size);
      },
    );
  }

  Widget _buildSurveyCard(
    BuildContext context,
    SurveyForm survey,
    ThemeData theme,
    Size size,
  ) {
    final String academicYear = survey.academicYear ?? 'غير محدد';
    final String semesterName = survey.semesterId?.name ?? '';
    final String title = 'استبيان - $semesterName';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? ColorsManager.blueGrey.withOpacity(0.1)
                : Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () =>
              _showSurveyOptionsDialog(context, survey, title, theme, size),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorsManager.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: ColorsManager.green,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'نشط (Active)',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: ColorsManager.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.assignment_turned_in_outlined,
                        color: theme.colorScheme.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: ColorsManager.greyText,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "العام الدراسي: $academicYear",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSurveyOptionsDialog(
    BuildContext context,
    SurveyForm survey,
    String title,
    ThemeData theme,
    Size size,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('ماذا تريد أن تفعل؟', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _selectedFormId = survey.id ?? '';
                      String yearId = survey.yearId?.id ?? '';

                      _showLoadingDialog(context, theme);
                      context
                          .read<StudentSurveyCubit>()
                          .fetchSubjectsStatsByYearAndForm(
                            yearId: yearId,
                            formId: _selectedFormId,
                          );
                    },
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('إرسال تقييم جديد'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showLoadingDialog(context, theme);
                      context.read<StudentSurveyCubit>().fetchMyResponseForForm(
                        survey.id ?? '',
                      );
                    },
                    icon: Icon(Icons.history, color: theme.colorScheme.primary),
                    label: Text(
                      'عرض إجابتي السابقة',
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDynamicSubmitSurveyDialog(
    BuildContext parentContext,
    String formId,
    StudentSurveyModels statsModel,
    ThemeData theme,
    Size size,
  ) {
    List<dynamic> rawSubjects = [];

    // تم إصلاح المنطق ليعتمد على الردود التي تكون بصيغة Maps
    if (statsModel.data?.subjects != null &&
        statsModel.data!.subjects!.isNotEmpty) {
      rawSubjects = statsModel.data!.subjects!;
    } else if (statsModel.data?.stats != null &&
        statsModel.data!.stats!.isNotEmpty) {
      rawSubjects = statsModel.data!.stats!;
    } else if (statsModel.data?.subjectResponses != null &&
        statsModel.data!.subjectResponses!.isNotEmpty) {
      rawSubjects = statsModel.data!.subjectResponses!;
    }

    if (rawSubjects.isEmpty) {
      _showSnackBar(
        parentContext,
        'لم يتم العثور على مواد لهذه السنة.',
        theme.colorScheme.error,
      );
      return;
    }

    Map<String, Map<String, dynamic>> evaluations = {};
    for (var sub in rawSubjects) {
      if (sub is Map) {
        // 1. استخراج معرّف المادة بشكل آمن
        String subjectId = '';
        if (sub['subjectId'] is Map) {
          subjectId =
              (sub['subjectId']['_id'] ?? sub['subjectId']['id'])?.toString() ??
              '';
        } else if (sub['_id'] is Map) {
          subjectId = (sub['_id']['_id'] ?? sub['_id']['id'])?.toString() ?? '';
        } else {
          subjectId =
              sub['subjectId']?.toString() ??
              sub['_id']?.toString() ??
              sub['id']?.toString() ??
              '';
        }

        // 2. استخراج اسم المادة بشكل آمن
        String subjectName = 'مادة غير معروفة';
        if (sub['subjectId'] is Map) {
          subjectName =
              sub['subjectId']['name']?.toString() ??
              sub['subjectId']['title']?.toString() ??
              subjectName;
        } else if (sub['_id'] is Map) {
          subjectName =
              sub['_id']['name']?.toString() ??
              sub['_id']['title']?.toString() ??
              subjectName;
        } else {
          subjectName =
              sub['subjectName']?.toString() ??
              sub['name']?.toString() ??
              sub['title']?.toString() ??
              subjectName;
        }

        if (subjectId.isNotEmpty) {
          evaluations[subjectId] = {
            'name': subjectName,
            'isCarrying': false,
            'preferredDaysBefore': 3.0,
            'difficultyRating': 3.0,
          };
        }
      }
    }

    // التحقق مجدداً بعد الفلترة
    if (evaluations.isEmpty) {
      _showSnackBar(
        parentContext,
        'حدث خطأ في قراءة بيانات المواد من الخادم.',
        theme.colorScheme.error,
      );
      return;
    }

    showDialog(
      context: parentContext,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: size.width * 0.95,
                height: size.height * 0.8,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'تقييم مواد الفصل',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'يرجى تقييم جميع المواد المطلوبة',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1.5),

                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: evaluations.length,
                        itemBuilder: (context, index) {
                          String currentSubjectId = evaluations.keys.elementAt(
                            index,
                          );
                          Map<String, dynamic> currentEval =
                              evaluations[currentSubjectId]!;

                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.2,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.book,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          currentEval['name'],
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      'هل أنت حامل للمادة؟',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    value: currentEval['isCarrying'],
                                    activeColor: theme.colorScheme.primary,
                                    onChanged: (bool value) {
                                      setState(() {
                                        currentEval['isCarrying'] = value;
                                      });
                                    },
                                  ),

                                  Text(
                                    'الأيام المفضلة قبل الامتحان: ${currentEval['preferredDaysBefore'].toInt()}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Slider(
                                    value: currentEval['preferredDaysBefore'],
                                    min: 1,
                                    max: 7,
                                    divisions: 6,
                                    activeColor: theme.colorScheme.primary,
                                    label: currentEval['preferredDaysBefore']
                                        .toInt()
                                        .toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        currentEval['preferredDaysBefore'] =
                                            value;
                                      });
                                    },
                                  ),

                                  Text(
                                    'مستوى الصعوبة (1 سهل - 5 صعب): ${currentEval['difficultyRating'].toInt()}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Slider(
                                    value: currentEval['difficultyRating'],
                                    min: 1,
                                    max: 5,
                                    divisions: 4,
                                    activeColor: ColorsManager.orange,
                                    label: currentEval['difficultyRating']
                                        .toInt()
                                        .toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        currentEval['difficultyRating'] = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: theme.colorScheme.error),
                              foregroundColor: theme.colorScheme.error,
                            ),
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('إلغاء'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: theme.colorScheme.primary,
                            ),
                            onPressed: () {
                              List<Map<String, dynamic>> finalSubjectResponses =
                                  [];

                              evaluations.forEach((subjectId, evalData) {
                                finalSubjectResponses.add({
                                  "subjectId": subjectId,
                                  "isCarrying": evalData['isCarrying'],
                                  "preferredDaysBefore":
                                      evalData['preferredDaysBefore'].toInt(),
                                  "difficultyRating":
                                      evalData['difficultyRating'].toInt(),
                                });
                              });

                              Map<String, dynamic> requestData = {
                                "formId": formId,
                                "subjectResponses": finalSubjectResponses,
                              };

                              Navigator.pop(ctx);
                              _showLoadingDialog(parentContext, theme);
                              parentContext
                                  .read<StudentSurveyCubit>()
                                  .submitSurveyResponse(requestData);
                            },
                            child: const Text(
                              'إرسال التقييمات',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMyResponsesBottomSheet(
    BuildContext context,
    List<SurveyResponseModel> responses,
    ThemeData theme,
    Size size,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: size.height * 0.7,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.history,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'سجل ردودك السابقة',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: responses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.speaker_notes_off_outlined,
                              size: 60,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا يوجد ردود سابقة حتى الآن',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: responses.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final response = responses[index];
                          final int subjectsCount =
                              response.subjectResponses?.length ?? 0;
                          final String formTitle = response.formName != null
                              ? 'النموذج: ${response.formName}'
                              : 'رد استبيان رقم: ${index + 1}';

                          String dateText = "غير متوفر";
                          if (response.createdAt != null &&
                              response.createdAt!.length >= 10) {
                            dateText = response.createdAt!.substring(0, 10);
                          }

                          return Card(
                            elevation: 0,
                            color: theme.colorScheme.surface,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.15,
                                ),
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.pop(ctx);
                                _showHistoryResponseDetailsDialog(
                                  context,
                                  response,
                                  theme,
                                  size,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.task_alt,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(
                                    formTitle,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          dateText,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(
                                          Icons.library_books,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$subjectsCount مواد',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResponseDetailsDialog(
    BuildContext context,
    StudentSurveyModels surveyModel,
    ThemeData theme,
    Size size,
  ) {
    List<dynamic> subjectResponses = [];
    if (surveyModel.data?.response?.subjectResponses != null) {
      subjectResponses = surveyModel.data!.response!.subjectResponses!;
    }

    _buildProfessionalDetailsDialog(
      context: context,
      theme: theme,
      size: size,
      title: 'إجابتك السابقة',
      subtitle: 'النموذج النشط',
      subjectResponses: subjectResponses,
    );
  }

  void _showHistoryResponseDetailsDialog(
    BuildContext context,
    SurveyResponseModel response,
    ThemeData theme,
    Size size,
  ) {
    final List<dynamic> subjectResponses = response.subjectResponses ?? [];

    _buildProfessionalDetailsDialog(
      context: context,
      theme: theme,
      size: size,
      title: 'تفاصيل التقييم المرسل',
      subtitle: response.formName ?? 'نموذج غير معروف',
      subjectResponses: subjectResponses,
    );
  }

  void _buildProfessionalDetailsDialog({
    required BuildContext context,
    required ThemeData theme,
    required Size size,
    required String title,
    String? subtitle,
    required List<dynamic> subjectResponses,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            width: size.width * 0.95,
            constraints: BoxConstraints(maxHeight: size.height * 0.85),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.assignment_turned_in_rounded,
                    size: 36,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 20),
                const Divider(thickness: 1.2),
                const SizedBox(height: 12),
                Flexible(
                  child: subjectResponses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'لا توجد تفاصيل مواد في هذا الرد',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: subjectResponses.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final item = subjectResponses[index];

                            String subjectName = 'مادة غير معروفة';
                            if (item['subjectId'] is Map) {
                              subjectName =
                                  item['subjectId']['name']?.toString() ??
                                  subjectName;
                            } else if (item['subjectId'] is String) {
                              subjectName =
                                  'معرف: ${item['subjectId'].toString().substring(0, 6)}...';
                            }

                            final int difficulty =
                                (item['difficultyRating'] as num?)?.toInt() ??
                                0;
                            final int days =
                                (item['preferredDaysBefore'] as num?)
                                    ?.toInt() ??
                                0;
                            final bool isCarrying = item['isCarrying'] == true;

                            return Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.2,
                                  ),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.menu_book_rounded,
                                            color: theme.colorScheme.primary,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            subjectName,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.4,
                                                ),
                                          ),
                                        ),
                                        if (isCarrying)
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.red.shade200,
                                              ),
                                            ),
                                            child: Text(
                                              'حمل',
                                              style: TextStyle(
                                                color: Colors.red.shade700,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Divider(height: 1),
                                    ),
                                    Row(
                                      children: [
                                        _buildDetailItem(
                                          icon: Icons.calendar_today_rounded,
                                          title: 'أيام الدراسة',
                                          value: '$days أيام',
                                          iconColor: Colors.teal,
                                        ),
                                        Container(
                                          height: 35,
                                          width: 1.5,
                                          color: Colors.grey.shade300,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                        ),
                                        _buildDetailItem(
                                          icon: Icons.bar_chart_rounded,
                                          title: 'مستوى الصعوبة',
                                          value: '$difficulty من 5',
                                          iconColor: ColorsManager.orange,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      'إغلاق',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog(BuildContext context, ThemeData theme) {
    _isLoadingDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      ),
    ).then((_) => _isLoadingDialogOpen = false);
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: ColorsManager.greyText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد استبيانات متاحة حالياً',
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<StudentSurveyCubit>().fetchActiveForms(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
