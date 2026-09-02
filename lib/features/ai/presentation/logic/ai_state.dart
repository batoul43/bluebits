part of 'ai_cubit.dart';

abstract class AiState {}

class AiInitial extends AiState {}

class AiLoading extends AiState {}

// حالة عند طرح سؤال واستلام الجواب بنجاح
class AiQuestionAnswered extends AiState {
  final AskResponseModel response;
  AiQuestionAnswered(this.response);
}

// حالة عند جلب قائمة جميع المحادثات
class AiConversationsLoaded extends AiState {
  final List<ConversationModel> conversations;
  AiConversationsLoaded(this.conversations);
}

// حالة عند جلب تفاصيل محادثة واحدة (تحتوي على الرسائل السابقة)
class AiConversationDetailLoaded extends AiState {
  final ConversationDetailsModel conversationDetail;
  AiConversationDetailLoaded(this.conversationDetail);
}

// حالة عند تنفيذ إجراء بنجاح (مثل حذف محادثة)
class AiActionSuccess extends AiState {
  final String message;
  AiActionSuccess(this.message);
}

// حالة حدوث خطأ
class AiError extends AiState {
  final String message;
  AiError(this.message);
}
