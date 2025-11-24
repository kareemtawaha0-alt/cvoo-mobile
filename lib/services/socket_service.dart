import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SocketService {
  IO.Socket? socket; final _s = const FlutterSecureStorage();
  Future<void> connect() async {
    socket = IO.io('http://127.0.0.1:4000', IO.OptionBuilder().setTransports(['websocket']).build());
    socket!.onConnect((_) async { final uid = await _s.read(key:'userId'); socket!.emit('join', uid); });
  }
}