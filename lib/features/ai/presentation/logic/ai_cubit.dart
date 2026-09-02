import 'package:bluebits_app/core/helpers/cachhelper.dart'; // مسار الـ CachHelper الخاص بك
import 'package:bluebits_app/features/ai/data/models/ask_response_model.dart'; // مسارات المودلز الخاصة بك
import 'package:bluebits_app/features/ai/data/models/conversation_detail_and_message_model.dart';
import 'package:bluebits_app/features/ai/data/models/conversation_model.dart';
import 'package:bluebits_app/features/ai/data/repository/ai_repository.dart'; // مسار الريبوزيتوري الخاص بك
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ai_state.dart';

class AiCubit extends Cubit<AiState> {
  final AiRepository repository;

  AiCubit({required this.repository}) : super(AiInitial());

  // 1. إرسال سؤال جديد أو إكمال محادثة
  Future<void> askQuestion(String question, {String? conversationId}) async {
    emit(AiLoading());
    try {
      print('-----------------------------------');
      // نجلب التوكن من الكاش كما في LessonLectureCubit
      final token = await CachHelper.getValue('Token') ?? '';

      final responseModel = await repository.askQuestion(
        token,
        question,
        conversationId: conversationId,
      );
      print('Ask Question Response: ${responseModel.message}');
      print('-------------------------------------------');

      if (responseModel.isSuccess == true && responseModel.data != null) {
        emit(AiQuestionAnswered(responseModel.data!));
      } else {
        emit(AiError(responseModel.message));
      }
    } catch (e) {
      emit(AiError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 2. جلب جميع المحادثات
  Future<void> fetchAllConversations() async {
    emit(AiLoading());
    try {
      print('-----------------------------------');
      final token = await CachHelper.getValue('Token') ?? '';

      final responseModel = await repository.getAllConversations(token);
      print('Fetch All Conversations: ${responseModel.message}');
      print('-------------------------------------------');

      if (responseModel.isSuccess == true) {
        // إذا لم تكن هناك بيانات، نرسل قائمة فارغة
        emit(AiConversationsLoaded(responseModel.data ?? []));
      } else {
        emit(AiError(responseModel.message));
      }
    } catch (e) {
      emit(AiError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 3. جلب تفاصيل محادثة واحدة عبر الـ ID
  Future<void> fetchConversationById(String conversationId) async {
    emit(AiLoading());
    try {
      print('-----------------------------------');
      final token = await CachHelper.getValue('Token') ?? '';

      final responseModel = await repository.getConversationById(
        token,
        conversationId,
      );
      print('Fetch Conversation Details: ${responseModel.message}');
      print('-------------------------------------------');

      if (responseModel.isSuccess == true && responseModel.data != null) {
        emit(AiConversationDetailLoaded(responseModel.data!));
      } else {
        emit(AiError(responseModel.message));
      }
    } catch (e) {
      emit(AiError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 4. حذف محادثة
  Future<void> deleteConversation(String conversationId) async {
    emit(AiLoading());
    try {
      print('-----------------------------------');
      final token = await CachHelper.getValue('Token') ?? '';

      final responseModel = await repository.deleteConversation(
        token,
        conversationId,
      );
      print('Delete Conversation Response: ${responseModel.message}');
      print('-------------------------------------------');

      if (responseModel.isSuccess == true) {
        emit(AiActionSuccess(responseModel.message));
        // بعد الحذف الناجح، نقوم بتحديث قائمة المحادثات تلقائياً (كما في LessonLectureCubit)
        fetchAllConversations();
      } else {
        emit(AiError(responseModel.message));
      }
    } catch (e) {
      emit(AiError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }
}
