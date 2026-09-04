import 'package:bluebits_app/features/ai/data/models/conversation_detail_and_message_model.dart';
import 'package:bluebits_app/features/ai/presentation/logic/ai_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluebits_app/core/theming/colors.dart';

class AiChatScreen extends StatefulWidget {
  final String? conversationId;
  final String? initialTitle;

  const AiChatScreen({super.key, this.conversationId, this.initialTitle});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<MessageModel> _messages = [];
  String? _currentConversationId;

  @override
  void initState() {
    super.initState();
    _currentConversationId = widget.conversationId;

    if (_currentConversationId != null && _currentConversationId!.isNotEmpty) {
      context.read<AiCubit>().fetchConversationById(_currentConversationId!);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(MessageModel(role: 'user', content: text));
    });

    _messageController.clear();
    _scrollToBottom();

    context.read<AiCubit>().askQuestion(
      text,
      conversationId: _currentConversationId,
    );
  }

  void _confirmDeleteConversation(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("حذف المحادثة"),
        content: const Text("هل أنت متأكد من حذف هذه المحادثة نهائياً؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AiCubit>().deleteConversation(id);

              // تفريغ الشاشة إذا كانت المحادثة المحذوفة هي المفتوحة حالياً
              if (_currentConversationId == id) {
                setState(() {
                  _currentConversationId = null;
                  _messages.clear();
                });
              }
            },
            child: const Text(
              "حذف",
              style: TextStyle(color: ColorsManager.redaccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // استخدام EndDrawer بدلاً من BottomSheet لتجربة مستخدم أفضل وأكثر نظافة
      endDrawer: _buildHistoryDrawer(screenWidth, screenHeight, isDark),
      appBar: _buildAppBar(screenWidth, isDark),
      body: BlocConsumer<AiCubit, AiState>(
        listener: _aiCubitListener,
        builder: (context, state) {
          final isLoading = state is AiLoading;

          return Column(
            children: [
              Expanded(
                child: _messages.isEmpty && !isLoading
                    ? _buildEmptyState(screenWidth, isDark)
                    : _buildChatList(screenWidth, isDark, isLoading),
              ),
              _buildInputArea(screenWidth, screenHeight, isDark, isLoading),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // WIDGET BUILDERS (CLEAN CODE)
  // ==========================================

  AppBar _buildAppBar(double screenWidth, bool isDark) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              color: (isDark ? ColorsManager.cyan : ColorsManager.blue)
                  .withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              color: isDark ? ColorsManager.cyan : ColorsManager.blue,
              size: screenWidth * 0.055,
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.initialTitle ?? "بلوبتس رفيق الدرب",
                  style: TextStyle(
                    fontSize: screenWidth * 0.042,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "المساعد الذكي للبرمجة والتعلم",
                  style: TextStyle(
                    fontSize: screenWidth * 0.028,
                    color: ColorsManager.greyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.history, size: screenWidth * 0.06),
            tooltip: "المحادثات السابقة",
            onPressed: () {
              context.read<AiCubit>().fetchAllConversations();
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryDrawer(
    double screenWidth,
    double screenHeight,
    bool isDark,
  ) {
    return Drawer(
      backgroundColor: isDark
          ? ColorsManager.deepNavy
          : ColorsManager.lightBlue,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              width: double.infinity,
              color: isDark ? ColorsManager.darkBlue : ColorsManager.blue,
              child: Text(
                "سجل المحادثات",
                style: TextStyle(
                  color: ColorsManager.whiteText,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<AiCubit, AiState>(
                buildWhen: (previous, current) =>
                    current is AiConversationsLoaded ||
                    current is AiLoading ||
                    current is AiError,
                builder: (context, state) {
                  if (state is AiLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AiConversationsLoaded) {
                    final conversations = state.conversations;
                    if (conversations.isEmpty) {
                      return Center(
                        child: Text(
                          "لا توجد محادثات سابقة",
                          style: TextStyle(
                            color: ColorsManager.greyText,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      itemCount: conversations.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = conversations[index];
                        final isSelected = _currentConversationId == item.id;
                        return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            selected: isSelected,
                            selectedTileColor:
                                (isDark
                                        ? ColorsManager.cyan
                                        : ColorsManager.blue)
                                    .withOpacity(0.1),
                            leading: Icon(
                              Icons.chat_bubble_outline,
                              color: isDark
                                  ? ColorsManager.cyan
                                  : ColorsManager.blue,
                              size: screenWidth * 0.05,
                            ),
                            title: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: isDark
                                    ? ColorsManager.whiteText
                                    : ColorsManager.blackText,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: ColorsManager.redaccent,
                                size: screenWidth * 0.05,
                              ),
                              onPressed: () =>
                                  _confirmDeleteConversation(item.id),
                            ),
                            onTap: () {
                              Navigator.pop(context); // إغلاق الـ Drawer
                              setState(() {
                                _currentConversationId = item.id;
                              });
                              context.read<AiCubit>().fetchConversationById(
                                item.id,
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text("حدث خطأ أثناء تحميل السجل"));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentConversationId = null;
                    _messages.clear();
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text("محادثة جديدة"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, screenHeight * 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(double screenWidth, bool isDark, bool isLoading) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(screenWidth * 0.04),
      itemCount: _messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _messages.length) {
          return _buildChatBubble(_messages[index], screenWidth, isDark);
        } else {
          return _buildLoadingBubble(screenWidth, isDark);
        }
      },
    );
  }

  Widget _buildEmptyState(double screenWidth, bool isDark) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: (isDark ? ColorsManager.cyan : ColorsManager.blue)
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                size: screenWidth * 0.18,
                color: isDark ? ColorsManager.cyan : ColorsManager.blue,
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            Text(
              "مرحباً بك في بلوبتس الذكي!",
              style: TextStyle(
                fontSize: screenWidth * 0.048,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? ColorsManager.whiteText
                    : ColorsManager.blueText,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              "كيف يمكنني مساعدتك في رحلتك البرمجية اليوم؟",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: ColorsManager.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(
    MessageModel message,
    double screenWidth,
    bool isDark,
  ) {
    final isUser = message.role == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: screenWidth * 0.03),
        constraints: BoxConstraints(maxWidth: screenWidth * 0.78),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.03,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? (isDark ? ColorsManager.cyan : ColorsManager.blue)
              : (isDark ? ColorsManager.deepNavy : ColorsManager.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: !isUser && !isDark
              ? Border.all(color: ColorsManager.blue.withOpacity(0.1))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUser ? Icons.person : Icons.auto_awesome,
                  size: screenWidth * 0.035,
                  color: isUser
                      ? (isDark ? ColorsManager.darkBlue : ColorsManager.white)
                      : (isDark ? ColorsManager.cyan : ColorsManager.blue),
                ),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  isUser ? "أنت" : "بلوبتس AI",
                  style: TextStyle(
                    fontSize: screenWidth * 0.028,
                    fontWeight: FontWeight.bold,
                    color: isUser
                        ? (isDark
                              ? ColorsManager.darkBlue
                              : ColorsManager.white)
                        : (isDark ? ColorsManager.cyan : ColorsManager.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.015),
            SelectableText(
              message.content,
              style: TextStyle(
                fontSize: screenWidth * 0.036,
                height: 1.4,
                color: isUser
                    ? (isDark ? ColorsManager.darkBlue : ColorsManager.white)
                    : (isDark
                          ? ColorsManager.whiteText
                          : ColorsManager.blackText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBubble(double screenWidth, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: screenWidth * 0.03),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.03,
        ),
        decoration: BoxDecoration(
          color: isDark ? ColorsManager.deepNavy : ColorsManager.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: screenWidth * 0.04,
              height: screenWidth * 0.04,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: isDark ? ColorsManager.cyan : ColorsManager.blue,
              ),
            ),
            SizedBox(width: screenWidth * 0.025),
            Text(
              "يفكر بلوبتس...",
              style: TextStyle(
                fontSize: screenWidth * 0.032,
                color: ColorsManager.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(
    double screenWidth,
    double screenHeight,
    bool isDark,
    bool isLoading,
  ) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: isDark ? ColorsManager.darkBlue : ColorsManager.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !isLoading,
                maxLines: 4,
                minLines: 1,
                style: TextStyle(
                  fontSize: screenWidth * 0.036,
                  color: isDark
                      ? ColorsManager.whiteText
                      : ColorsManager.blackText,
                ),
                decoration: InputDecoration(
                  hintText: "اسأل بلوبتس أي شيء...",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015,
                  ),
                  fillColor: isDark
                      ? ColorsManager.deepNavy
                      : ColorsManager.lightBlue,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Material(
              color: isDark ? ColorsManager.cyan : ColorsManager.blue,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: isLoading ? null : _sendMessage,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Icon(
                    Icons.send_rounded,
                    color: isDark
                        ? ColorsManager.darkBlue
                        : ColorsManager.white,
                    size: screenWidth * 0.05,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BLOC LISTENER LOGIC
  // ==========================================

  void _aiCubitListener(BuildContext context, AiState state) {
    if (state is AiQuestionAnswered) {
      setState(() {
        _currentConversationId = state.response.conversationId;
        _messages.add(
          MessageModel(role: 'model', content: state.response.answer),
        );
      });
      _scrollToBottom();
    } else if (state is AiConversationDetailLoaded) {
      setState(() {
        _messages.clear();
        _messages.addAll(
          state.conversationDetail.messages as Iterable<MessageModel>,
        );
      });
      _scrollToBottom();
    } else if (state is AiActionSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: ColorsManager.green, // باستخدام اللون الأخضر للنجاح
        ),
      );
    } else if (state is AiError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: ColorsManager.redaccent,
        ),
      );
    }
  }
}
