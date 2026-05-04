// lib/features/chat/presentation/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/ui/error_state.dart';
import 'package:tropicaguide/core/ui/loading_state.dart';
import 'package:tropicaguide/features/auth/data/auth_repository_provider.dart';
import 'package:tropicaguide/features/chat/domain/message.dart';
import 'package:tropicaguide/features/chat/presentation/chat_notifier.dart';

/// iMessage-style real-time trip chat screen.
///
/// Current user's messages appear on the right in the primary colour;
/// others appear on the left in a surface bubble with a sender name label.
class ChatScreen extends ConsumerStatefulWidget {
  /// Creates a [ChatScreen].
  const ChatScreen({required this.tripId, super.key});

  /// The trip whose messages are shown.
  final String tripId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
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

  Future<void> _send() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    _controller.clear();
    await ref.read(chatNotifierProvider(widget.tripId).notifier).send(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesStreamProvider(widget.tripId));
    final currentUser = ref.watch(authStateChangesProvider).valueOrNull;

    ref.listen(messagesStreamProvider(widget.tripId), (_, __) {
      _scrollToBottom();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Trip Chat')),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => const LoadingState(),
              error: (e, __) => ErrorState(
                message: e.toString(),
                onRetry: () =>
                    ref.invalidate(messagesStreamProvider(widget.tripId)),
              ),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Say hello!'),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => _MessageBubble(
                    message: messages[i],
                    isMe: messages[i].senderUid == currentUser?.uid,
                  ),
                );
              },
            ),
          ),
          _InputBar(controller: _controller, onSend: _send),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMe,
  });

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final timeStr = DateFormat.jm().format(message.createdAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                bottom: AppSpacing.xs,
              ),
              child: Text(
                message.senderName,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) const Gap(AppSpacing.xs),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(AppSpacing.lg),
                      topRight: const Radius.circular(AppSpacing.lg),
                      bottomLeft: Radius.circular(isMe ? AppSpacing.lg : 4),
                      bottomRight: Radius.circular(isMe ? 4 : AppSpacing.lg),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isMe
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              if (isMe) const Gap(AppSpacing.xs),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isMe ? 0 : AppSpacing.sm,
              right: isMe ? AppSpacing.xs : 0,
              top: AppSpacing.xs,
            ),
            child: Text(
              timeStr,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Message…',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.xl),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
            const Gap(AppSpacing.sm),
            IconButton.filled(
              tooltip: 'Send',
              icon: const Icon(Icons.send_rounded),
              onPressed: onSend,
            ),
          ],
        ),
      ),
    );
  }
}
