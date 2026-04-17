import '../../model/station.dart';

final List<Station> mockStations = <Station>[
  const Station(
    id: 'toul_kork',
    name: 'Toul Kork',
    totalSlots: 20,
    latitude: 11.5715,
    longitude: 104.8904,
    availableBikes: 12,
  ),
  const Station(
    id: 'olympic',
    name: 'Olympic',
    totalSlots: 20,
    latitude: 11.5569,
    longitude: 104.9156,
    availableBikes: 3,
  ),
  const Station(
    id: 'orussey',
    name: 'Orussey',
    totalSlots: 20,
    latitude: 11.5639,
    longitude: 104.9242,
    availableBikes: 8,
  ),
];
