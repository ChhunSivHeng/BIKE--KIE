import '../model/station.dart' as app_model;

class MockData {
  const MockData._();

  static const List<Map<String, Object>> _stationRaw = <Map<String, Object>>[
    <String, Object>{
      'id': 'toul_kork',
      'name': 'Toul Kork',
      'latitude': 11.5715,
      'longitude': 104.8904,
      'totalSlots': 20,
      'availableBikes': 12,
    },
    <String, Object>{
      'id': 'olympic',
      'name': 'Olympic',
      'latitude': 11.5569,
      'longitude': 104.9156,
      'totalSlots': 20,
      'availableBikes': 3,
    },
    <String, Object>{
      'id': 'orussey',
      'name': 'Orussey',
      'latitude': 11.5639,
      'longitude': 104.9242,
      'totalSlots': 20,
      'availableBikes': 8,
    },
  ];

  static List<Map<String, Object>> get stations => _stationRaw
      .map((m) => <String, Object>{
            'id': m['id'] as String,
            'name': m['name'] as String,
            'latitude': (m['latitude'] as num).toDouble(),
            'longitude': (m['longitude'] as num).toDouble(),
            'availableBikes': (m['availableBikes'] as num).toInt(),
          })
      .toList(growable: false);

  static List<app_model.Station> get stationRepositoryStations => _stationRaw
      .map(
        (m) => app_model.Station(
          id: m['id'] as String,
          name: m['name'] as String,
          totalSlots: (m['totalSlots'] as num).toInt(),
          availableBikes: (m['availableBikes'] as num).toInt(),
        ),
      )
      .toList(growable: false);
}
