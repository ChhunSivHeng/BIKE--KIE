import 'dart:convert';

import 'package:bikkie/model/station.dart';
import 'package:http/http.dart' as http;

import '../../dtos/station_dto.dart';
import '../../firebase/firebase_database.dart';
import 'station_repository.dart';

class StationRepositoryFirebase implements StationRepository {
  @override
  Future<List<Station>> getStations() async {
    final stationsUri = FirebaseConfig.baseUri.replace(path: "/stations.json");

    final http.Response response = await http.get(stationsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> stationJson = json.decode(response.body);

      List<Station> result = [];

      for (final entry in stationJson.entries) {
        result.add(StationDto.fromJson(entry.key, entry.value));
      }

      return result;
    } else {
      throw Exception('Fail to load stations');
    }
  }

  @override
  Future<void> removeBikeFromStation(String stationId, int slotIndex) async {
    final url = FirebaseConfig.baseUri.replace(path: "/stations/$stationId/availableBikes/$slotIndex.json");

    final response = await http.put(
      url,
      body: 'null',
      headers: {'Content-Type': 'application/json'}
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove bike from station');
    }
  }
}
