import 'dart:ui';

import 'package:buhuiwangshi/services/ai.dart';
import 'package:buhuiwangshi/services/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            child: _isVoiceInput
                ? VoiceInputBar(
                    onToggleInputMode: _toggleInputMode,
                    onSubmitted: _handleSubmitted,
                    loading: _isLoading,
                  )
                : TextInputBar(
                    onToggleInputMode: _toggleInputMode,
                    onSubmitted: _handleSubmitted,
                    loading: _isLoading,
                  ),
          ),
          // 加载指示器
          AnimatedContainer(
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 120),
            width: _isLoading ? 48 : 0,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
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
        // 切换到语音输入的按钮
        prefixIcon: !_isComposing && !widget.loading
            ? IconButton(
                icon: Icon(Icons.mic_none,
                    color: Theme.of(context).colorScheme.secondary),
                onPressed: widget.onToggleInputMode,
              )
            : null,
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

/// 语音输入栏
/// 用于处理语音输入
class VoiceInputBar extends StatefulWidget {
  final VoidCallback onToggleInputMode;
  final Function(String, Function()?) onSubmitted;
  final bool loading;

  const VoiceInputBar({
    super.key,
    required this.onToggleInputMode,
    required this.onSubmitted,
    required this.loading,
  });

  @override
  State<VoiceInputBar> createState() => _VoiceInputBarState();
}

class _VoiceInputBarState extends State<VoiceInputBar> {
  // 是否正在说话
  bool _isSpeaking = false;
  // 是否取消了语音输入
  bool _isCancelled = false;
  // 是否需要发送语音
  bool _needSendVoice = false;
  // 最后识别的语音文字
  String _lastVoiceWords = '';

  @override
  void initState() {
    super.initState();
    // 初始化语音识别服务
    SpeechToTextService.init();
  }

  /// 开始语音输入
  Future<void> _onStartVoice(_) async {
    setState(() {
      _isSpeaking = true;
      _isCancelled = false;
      _needSendVoice = true;
    });

    // 触发震动反馈
    HapticFeedback.heavyImpact();

    // 开始监听语音输入
    await SpeechToTextService.startListening((result) {
      setState(() {
        _lastVoiceWords = result.recognizedWords;
      });

      // 如果需要发送语音，则调用回调函数
      if (_needSendVoice) {
        widget.onSubmitted(result.recognizedWords, () {});
      }
    });
  }

  /// 处理手势更新（检测是否取消语音输入）
  void _handlePanUpdate(DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    final bool isOutside = !box.size.contains(localPosition);

    setState(() {
      _isCancelled = isOutside;
    });
  }

  /// 结束语音输入
  Future<void> _onEndVoice(_) async {
    // 如果取消，则不发送语音
    _needSendVoice = !_isCancelled;

    // 停止语音监听
    await SpeechToTextService.stopListening();

    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTapDown: widget.loading ? null : _onStartVoice,
        onPanUpdate: widget.loading ? null : _handlePanUpdate,
        onTapUp: widget.loading ? null : _onEndVoice,
        onPanEnd: widget.loading ? null : _onEndVoice,
        child: _buildVoiceInputContainer(),
      ),
    );
  }

  /// 构建语音输入容器
  Widget _buildVoiceInputContainer() {
    Color color;
    if (widget.loading) {
      color = Theme.of(context).colorScheme.secondary.withOpacity(0.2);
    } else if (_isSpeaking) {
      color = _isCancelled
          ? Theme.of(context).colorScheme.error.withOpacity(0.5)
          : Theme.of(context).colorScheme.primary.withOpacity(0.5);
    } else {
      color = Theme.of(context).colorScheme.secondary.withOpacity(0.2);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          if (!widget.loading) _buildKeyboardIcon(),
          _buildVoiceInputText(),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  /// 构建切换到键盘输入的图标
  Widget _buildKeyboardIcon() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isSpeaking ? 0.0 : 1.0,
      child: IconButton(
        key: const ValueKey('keyboard'),
        icon: Icon(Icons.keyboard,
            color: Theme.of(context).colorScheme.secondary),
        onPressed: widget.onToggleInputMode,
      ),
    );
  }

  /// 构建语音输入文本显示
  Widget _buildVoiceInputText() {
    return Expanded(
      child: Center(
        child: Text(
          _getVoiceInputText(),
          maxLines: 1,
          style: TextStyle(
            color: _isSpeaking
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.secondary,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  /// 获取语音输入文本
  String _getVoiceInputText() {
    if (widget.loading) {
      return "⏳$_lastVoiceWords";
    } else if (_isSpeaking) {
      return _isCancelled ? "松开取消" : "松开发送";
    }
    return _lastVoiceWords.isNotEmpty ? _lastVoiceWords : "按住说话";
  }
}
