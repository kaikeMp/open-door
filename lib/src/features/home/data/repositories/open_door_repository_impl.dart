import 'package:http/http.dart' as http;

import '../../../../injection_container.dart';
import '../../domain/repositories/open_door_repository.dart';

class OpenDoorRepositoryImpl implements OpenDoorRepository {
  late final http.Client _client;

  OpenDoorRepositoryImpl({http.Client? client})
      : _client = client ?? sl.get<http.Client>();

  @override
  Future<void> openDoor() async {
    final url = Uri.parse('http://192.168.0.35/command?cmd=getdate');
    await _client.get(url).timeout(const Duration(seconds: 5));
    return;
  }
}
