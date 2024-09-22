import 'dart:ui';

import 'package:buhuiwangshi/services/ai.dart';
import 'package:buhuiwangshi/services/speech_to_text.dart';
import 'package:buhuiwangshi/utils/system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

/// 聊天输入框
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with SingleTickerProviderStateMixin {
  // 文本输入控制器
  final TextEditingController _textController = TextEditingController();

  // 状态标志
  bool _isComposing = false; // 是否正在输入文本
  bool _isVoiceInput = false; // 是否处于语音输入模式
  bool _isSpeaking = false; // 是否正在进行语音输入
  bool _isLoading = false; // 是否正在加载（例如，等待AI响应）
  bool _isCancelled = false; // 是否取消了语音输入
  bool _needSendVoice = false; // 是否需要发送语音输入

  // 存储最后识别的语音文本
  String _lastVoiceWords = '';

  // 动画控制器，用于输入模式切换动画
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // 初始化动画控制器
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    // 初始化语音识别服务
    SpeechToTextService.init();
  }

  @override
  void dispose() {
    // 释放资源
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // 处理文本提交
  Future<void> _handleSubmitted(String text) async {
    SystemUtils.hideKeyShowUnfocus(); // 失焦

    setState(() {
      _isComposing = false;
      _isLoading = true;
    });

    // 调用AI服务处理输入
    await AiService.use(
      prompt: text,
    );

    setState(() {
      _isLoading = false;
    });

    _textController.clear();
  }

  // 切换输入模式（文本/语音）
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
    final showRightArea = _isVoiceInput && !_isLoading;
    if (!_isVoiceInput) {
      _lastVoiceWords = '';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _isVoiceInput ? _buildVoiceInput() : _buildTextInput(),
          ),
          _buildRightArea(showRightArea),
        ],
      ),
    );
  }

  /// 文本输入
  // 构建文本输入框
  Widget _buildTextInput() {
    final List<String> hintTexts = [
      '试试 "下午四点提醒我开会"',
      '试试 "安排明天我的娱乐活动"',
      '试试 "设置每天八点读英语的习惯"',
      '试试 "每周二提醒给妈妈打电话"',
    ];

    return TextField(
      readOnly: _isLoading,
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
        prefixIcon: IconButton(
          icon: Icon(Icons.mic_none,
              color: Theme.of(context).colorScheme.secondary),
          onPressed: _toggleInputMode,
        ),
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

  /// 语音输入
  // 开始语音识别
  Future<void> _onStartVoice() async {
    HapticFeedback.heavyImpact();
    await SpeechToTextService.startListening((result) {
      setState(() {
        _lastVoiceWords = result.recognizedWords;
      });
      if (_needSendVoice) {
        _handleSubmitted(result.recognizedWords);
      }
    });
  }

  // 结束语音识别
  Future<void> _onEndVoice() async {
    await SpeechToTextService.stopListening();
  }

  // 构建语音输入界面
  Widget _buildVoiceInput() {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTapDown: (_) async {
          setState(() {
            _isSpeaking = true;
            _isCancelled = false;
          });
          await _onStartVoice();
        },
        onPanUpdate: _handlePanUpdate,
        onTapUp: _handleTapCancel,
        onPanEnd: _handleTapCancel,
        child: _buildVoiceInputContainer(),
      ),
    );
  }

  // 处理手势滑动更新
  void _handlePanUpdate(DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    final bool isOutside = !box.size.contains(localPosition);

    setState(() {
      _isCancelled = isOutside;
    });
  }

  // 处理手势抬起或结束
  void _handleTapCancel(_) {
    if (!_isCancelled) {
      _needSendVoice = true;
    }
    _onEndVoice();

    setState(() {
      _isSpeaking = false;
      _isCancelled = false;
    });
  }

  // 构建语音输入容器
  Widget _buildVoiceInputContainer() {
    Color color;
    if (_isSpeaking) {
      color = Theme.of(context).colorScheme.primary.withOpacity(0.5);
      if (_isCancelled) {
        color = Theme.of(context).colorScheme.error.withOpacity(0.5);
      }
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
          _buildKeyboardIcon(),
          _buildVoiceInputText(),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  /// 其他样式配置

  // 构建键盘图标
  Widget _buildKeyboardIcon() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isSpeaking ? 0.0 : 1.0,
      child: IconButton(
        key: const ValueKey('keyboard'),
        icon: Icon(Icons.keyboard,
            color: Theme.of(context).colorScheme.secondary),
        onPressed: _toggleInputMode,
      ),
    );
  }

  // 构建语音输入文本
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

  // 获取语音输入文本
  String _getVoiceInputText() {
    if (_isSpeaking) {
      return _isCancelled ? "松开发送" : "松开取消";
    }
    return _lastVoiceWords.isNotEmpty ? _lastVoiceWords : "按住说话";
  }

  /// 右侧区域

  // 构建右侧区域（发送按钮或加载指示器）
  Widget _buildRightArea(bool showRightArea) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: showRightArea ? 0 : 48,
      height: 48,
      child: showRightArea
          ? null
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isLoading
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
                      disabledColor: Colors.black12,
                      color: Theme.of(context).colorScheme.primary,
                      icon: const Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                    ),
            ),
    );
  }
}
