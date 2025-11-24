// mobile/lib/services/save_text.dart
import 'save_text_web.dart' if (dart.library.io) 'save_text_io.dart' as saver;


Future<String> saveTextFile(String filename, String content) => saver.saveTextFile(filename, content);