import 'package:bluebits_app/features/ai/data/api_Service/ai_api_service.dart';
import 'package:bluebits_app/features/ai/data/models/ask_response_model.dart';
import 'package:bluebits_app/features/ai/data/models/conversation_detail_and_message_model.dart';
import 'package:bluebits_app/features/ai/data/models/conversation_model.dart';

import 'package:bluebits_app/core/shares/question_banks/data/models/general_question_bank.dart'; // تأكد من مسار الاستيراد الصحيح

class AiRepository {
  final AiApiService apiService;

  AiRepository(this.apiService);

  /// إرسال سؤال جديد أو إكمال محادثة
  Future<ApiResponse<AskResponseModel>> askQuestion(
    String token,
    String question, {
    String? conversationId,
  }) async {
    final response = await apiService.askQuestion(
      token,
      question,
      conversationId: conversationId,
    );
    print('-------------------------------------------');
    print('repoAi - AskQuestion: $response');
    print('-------------------------------------------');
    return ApiResponse<AskResponseModel>.fromJson(
      response,
      (data) => AskResponseModel.fromJson(data),
    );
  }

  /// جلب جميع المحادثات
  Future<ApiResponse<List<ConversationModel>>> getAllConversations(
    String token,
  ) async {
    final response = await apiService.getAllConversations(token);
    print('-------------------------------------------');
    print('repoAi - GetAllConversations: $response');
    print('-------------------------------------------');
    return ApiResponse<List<ConversationModel>>.fromJson(
      response,
      (data) =>
          (data as List).map((e) => ConversationModel.fromJson(e)).toList(),
    );
  }

  /// جلب تفاصيل محادثة محددة
  Future<ApiResponse<ConversationDetailsModel>> getConversationById(
    String token,
    String conversationId,
  ) async {
    final response = await apiService.getConversationById(
      token,
      conversationId,
    );
    print('-------------------------------------------');
    print('repoAi - GetConversationById: $response');
    print('-------------------------------------------');
    return ApiResponse<ConversationDetailsModel>.fromJson(
      response,
      (data) => ConversationDetailsModel.fromJson(data),
    );
  }

  /// حذف محادثة محددة
  Future<ApiResponse<dynamic>> deleteConversation(
    String token,
    String conversationId,
  ) async {
    final response = await apiService.deleteConversation(token, conversationId);
    print('-------------------------------------------');
    print('repoAi - DeleteConversation: $response');
    print('-------------------------------------------');
    return ApiResponse<dynamic>.fromJson(
      response,
      (data) => data, // البيانات هنا تكون null كما هو موضح في الـ JSON المرفق
    );
  }
}
