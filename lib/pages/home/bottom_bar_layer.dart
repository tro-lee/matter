import 'dart:ui';

import 'package:buhuiwangshi/services/ai.dart';
import 'package:flutter/material.dart';

/// 底部栏层
/// 包含一个模糊背景和聊天输入栏
class BottomBarLayer extends StatelessWidget {
  const BottomBarLayer({super.key});

  @override
  Widget build(BuildContext context) {
    // 这个 SingleChildScrollView 能够跟随键盘滚动的原因如下：
    // 1. reverse: true 使得滚动视图从底部开始，这对于聊天界面很有用
    // 2. MediaQuery.of(context).viewInsets.bottom 获取键盘高度
    // 3. Padding 根据键盘高度调整底部内边距
    // 4. 当键盘弹出时，这些组合使得 ChatInputBar 能够自动上移，避免被键盘遮挡
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 40),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: ChatInputBar(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 聊天输入栏
/// 用于处理语音输入和文本输入，以及显示加载状态
class ChatInputBar extends StatefulWidget {
  final Function()? onSubmitted;

  const ChatInputBar({super.key, this.onSubmitted});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with SingleTickerProviderStateMixin {
  // 是否处于语音输入模式
  bool _isVoiceInput = false;
  // 是否正在加载（处理用户输入）
  bool _isLoading = false;

  /// 切换输入模式（文本/语音）
  void _toggleInputMode() {
    setState(() {
      _isVoiceInput = !_isVoiceInput;
    });
  }

  /// 处理提交的输入（文本或语音）
  Future<void> _handleSubmitted(String text, Function()? onSubmitted) async {
    setState(() {
      _isLoading = true;
    });

    await AiService.use(prompt: text);

    setState(() {
      _isLoading = false;
    });

    onSubmitted?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextInputBar(
              onToggleInputMode: _toggleInputMode,
              onSubmitted: _handleSubmitted,
              loading: _isLoading,
            ),
          ),
          // 加载指示器
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isLoading
                ? const SizedBox(
                    width: 48,
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// 文本输入栏
/// 用于处理文本输入
class TextInputBar extends StatefulWidget {
  final VoidCallback onToggleInputMode;
  final Function(String, Function()?) onSubmitted;
  final bool loading;

  const TextInputBar({
    super.key,
    required this.onToggleInputMode,
    required this.onSubmitted,
    required this.loading,
  });

  @override
  State<TextInputBar> createState() => _TextInputBarState();
}

class _TextInputBarState extends State<TextInputBar> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// 处理文本提交
  void _handleSubmitted(String text) {
    widget.onSubmitted(text, () {
      _textController.clear();
    });
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> hintTexts = [
      '试试 "下午四点提醒我开会"',
      '试试 "安排明天我的娱乐活动"',
      '试试 "设置每天八点读英语的习惯"',
      '试试 "每周二提醒给妈妈打电话"',
    ];

    return TextField(
      controller: _textController,
      onChanged: (text) {
        setState(() {
          _isComposing = text.isNotEmpty;
        });
      },
      onSubmitted: _handleSubmitted,
      decoration: InputDecoration(
        hintText: hintTexts[DateTime.now().microsecond % hintTexts.length],
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize),
        // 发送按钮
        suffixIcon: widget.loading
            ? null
            : IconButton(
                disabledColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
                color: Theme.of(context).colorScheme.primary,
                icon: const Icon(Icons.send),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
              ),
        enabled: !widget.loading,
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
      ),
    );
  }
}
