import 'dart:html' as html;
import 'dart:convert';


Future<String> saveTextFile(String filename, String content) async {
final bytes = utf8.encode(content);
final blob = html.Blob([bytes], 'text/plain');
final url = html.Url.createObjectUrlFromBlob(blob);
final anchor = html.AnchorElement(href: url)
..setAttribute('download', filename)
..click();
html.Url.revokeObjectUrl(url);
return 'downloaded:$filename';
}