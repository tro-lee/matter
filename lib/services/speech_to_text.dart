import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  static final SpeechToText _speechToText = SpeechToText();
  static bool _isInitialized = false;

  static Future<bool> init() async {
    if (!_isInitialized) {
      _isInitialized = await _speechToText.initialize();
    }
    return _isInitialized;
  }

  static Future<void> startListening(
      Function(SpeechRecognitionResult) onResult) async {
    if (!_isInitialized) {
      await init();
    }
    await _speechToText.listen(onResult: onResult);
  }

  static Future<void> stopListening() async {
    await _speechToText.stop();
  }

  static bool get isListening => _speechToText.isListening;
}
