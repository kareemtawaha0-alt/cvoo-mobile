// هذا الملف يستخدم فقط لتفادي MissingPluginException في الويب

Future<dynamic> getApplicationDocumentsDirectory() async {
  throw UnsupportedError('getApplicationDocumentsDirectory is not supported on web.');
}
