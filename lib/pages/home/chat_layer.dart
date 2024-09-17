import 'package:buhuiwangshi/services/ai.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:flutter/material.dart';

class ChatLayer extends StatelessWidget {
  const ChatLayer({super.key});

  @override
  Widget build(BuildContext context) {
    // 这个 SingleChildScrollView 能够跟随键盘滚动的原因如下：
    // 1. reverse: true 使得滚动视图从底部开始，这对于聊天界面很有用
    // 2. MediaQuery.of(context).viewInsets.bottom 获取键盘高度
    // 3. Padding 根据键盘高度调整底部内边距
    // 4. 当键盘弹出时，这些组合使得 ChatInputBar 能够自动上移，避免被键盘遮挡
    return SingleChildScrollView(
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
    );
  }
}

/// 聊天输入框
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  bool _isVoiceInput = false;
  bool _isSpeaking = false;

  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
      _isLoading = true;
    });

    await AiService.use(
        prompt: text,
        onCallback: () {
          print('回调');
        });

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleInputMode() {
    setState(() {
      _isVoiceInput = !_isVoiceInput;
      if (_isVoiceInput) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isVoiceInput ? _buildVoiceInput() : _buildTextInput(),
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: !_isVoiceInput
                  ? (_isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _isComposing
                              ? () => _handleSubmitted(_textController.text)
                              : null,
                        ))
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return TextField(
      controller: _textController,
      onChanged: (text) {
        setState(() {
          _isComposing = text.isNotEmpty;
        });
      },
      onSubmitted: _handleSubmitted,
      decoration: InputDecoration(
        hintText: '试试 "下午一点提醒我起床"',
        hintStyle: const TextStyle(color: labelColor),
        prefixIcon: IconButton(
          icon: const Icon(Icons.mic_none),
          onPressed: _toggleInputMode,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(width: 2, color: textColor2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            width: 2,
            color: primaryColor,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
      ),
    );
  }

  Widget _buildVoiceInput() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTapDown: (_) {
          setState(() {
            _isSpeaking = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isSpeaking = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _isSpeaking = false;
          });
        },
        splashColor: inversePrimaryColor,
        highlightColor: inversePrimaryColor,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: textColor2, width: 2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isSpeaking ? 0.0 : 1.0,
                  child: IconButton(
                    key: const ValueKey('keyboard'),
                    icon: const Icon(Icons.keyboard),
                    onPressed: _toggleInputMode,
                  )),
              Expanded(
                child: Center(
                  child: Text(
                    _isSpeaking ? "松开结束" : "按住说话",
                    style: const TextStyle(color: textColor, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
