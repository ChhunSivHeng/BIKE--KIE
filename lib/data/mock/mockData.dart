import '../../model/bike.dart';
import '../../model/station.dart' as app_model;
import '../../model/pass.dart' as pass_model;

class MockData {
  const MockData._();

  static const List<Map<String, Object>> _stationRaw = <Map<String, Object>>[
    <String, Object>{
      'id': 'toul_kork',
      'name': 'Toul Kork',
      'latitude': 11.5715,
      'longitude': 104.8904,
      'totalSlots': 20,
      'availableBikes': [],
    },
    <String, Object>{
      'id': 'olympic',
      'name': 'Olympic',
      'latitude': 11.5569,
      'longitude': 104.9156,
      'totalSlots': 20,
      'availableBikes': [],
    },
    <String, Object>{
      'id': 'orussey',
      'name': 'Orussey',
      'latitude': 11.5639,
      'longitude': 104.9242,
      'totalSlots': 20,
      'availableBikes': [],
    },
  ];

  static const List<Map<String, Object>> _passRaw = <Map<String, Object>>[
    <String, Object>{
      'id': 'pass_day',
      'type': 'day',
      'price': 5.0,
      'durationDays': 1,
      'isActive': false,
    },
    <String, Object>{
      'id': 'pass_monthly',
      'type': 'monthly',
      'price': 29.0,
      'durationDays': 30,
      'isActive': false,
    },
    <String, Object>{
      'id': 'pass_annual',
      'type': 'annual',
      'price': 199.0,
      'durationDays': 365,
      'isActive': false,
    },
  ];

  static List<Map<String, Object>> get stations => _stationRaw
      .map(
        (m) => <String, Object>{
          'id': m['id'] as String,
          'name': m['name'] as String,
          'latitude': (m['latitude'] as num).toDouble(),
          'longitude': (m['longitude'] as num).toDouble(),
          'availableBikes': (m['availableBikes'] as num).toInt(),
        },
      )
      .toList(growable: false);

  static List<app_model.Station> get stationRepositoryStations => _stationRaw
      .map(
        (m) => app_model.Station(
          id: m['id'] as String,
          name: m['name'] as String,
          totalSlots: (m['totalSlots'] as num).toInt(),
          availableBikes: (m['availableBikes'] as List<Bike>),
          latitude: (m['latitude'] as num).toDouble(),
          longitude: (m['longitude'] as num).toDouble(),
        ),
      )
      .toList(growable: false);

  static List<pass_model.Pass> get passRepositoryPasses {
    final now = DateTime.now();
    return _passRaw
        .map((m) {
          final type = switch (m['type'] as String) {
            'day' => pass_model.PassType.day,
            'monthly' => pass_model.PassType.monthly,
            'annual' => pass_model.PassType.annual,
            _ => pass_model.PassType.day,
          };

          final durationDays = (m['durationDays'] as num).toInt();

          return pass_model.Pass(
            id: m['id'] as String,
            type: type,
            price: (m['price'] as num).toDouble(),
            startDate: now,
            endDate: now.add(Duration(days: durationDays)),
            isActive: m['isActive'] as bool,
          );
        })
        .toList(growable: false);
  }
}
