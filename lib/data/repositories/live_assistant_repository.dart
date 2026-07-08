import 'package:web_socket_channel/web_socket_channel.dart';

import '../../config/api_config.dart';
import '../token_storage.dart';

/// Opens the Gemini Live citizen-assistant WebSocket. Unlike every other
/// repository in this app, this isn't Dio-based — Dio doesn't do sockets —
/// but auth works exactly the same way: the same `patient_access_token`
/// every HTTP call already sends as a Bearer header goes here as a `?token=`
/// query param instead, since browsers can't set headers on a WS upgrade
/// (mirrors phc_api/routers/live_assistant_ws.py's auth check).
class LiveAssistantRepository {
  final TokenStorage _tokenStorage;

  LiveAssistantRepository(this._tokenStorage);

  Future<WebSocketChannel> connect() async {
    final token = await _tokenStorage.readToken();
    if (token == null) {
      throw StateError('No patient access token — cannot start the assistant');
    }
    final uri = Uri.parse('${ApiConfig.liveAssistantWsUrl}?token=$token');
    return WebSocketChannel.connect(uri);
  }
}
