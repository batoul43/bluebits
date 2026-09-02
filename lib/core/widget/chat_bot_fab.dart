import 'package:bluebits_app/features/ai/presentation/logic/ai_cubit.dart';
import 'package:bluebits_app/features/ai/presentation/screen/ai_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBotFab extends StatelessWidget {
  final VoidCallback? onPressed;

  const ChatBotFab({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed:
          onPressed ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  // هنا نقوم بتمرير الـ Cubit الموجود مسبقاً في LayoutApp إلى الشاشة الجديدة
                  value: context.read<AiCubit>(),
                  child: const AiChatScreen(),
                ),
              ),
            );
          },
      child: const Icon(Icons.smart_toy_outlined),
    );
  }
}
