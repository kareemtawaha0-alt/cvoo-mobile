// web_downloader_stub.dart
// هذا الملف يُستخدم فقط عندما التطبيق مش شغال على الويب.
// ما في أي كود فعلي هون، الهدف منه تجنب أخطاء "Blob not defined".

class WebDownloader {
  static Future<void> downloadBytes(
      List<int> bytes, String filename, String mimeType) async {
    // لا شيء هنا (يتم تجاهله خارج الويب)
  }
}
