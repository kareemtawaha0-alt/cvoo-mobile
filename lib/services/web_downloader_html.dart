// web_downloader_html.dart
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

class WebDownloader {
  static Future<void> downloadBytes(
      List<int> bytes, String filename, String mimeType) async {
    // 👇 هذا الكود ينشئ ملف مؤقت في المتصفح ويبدأ التحميل
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
