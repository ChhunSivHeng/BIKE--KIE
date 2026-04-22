import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dtos/bike_dto.dart';
import '../../dtos/renting_dto.dart';
import '../../firebase/firebase_database.dart';
import '../stationRepository/station_repository.dart';
import '../../../model/bike.dart';
import '../../../model/renting.dart';
import 'renting_repository.dart';

class RentingRepositoryFirebase implements RentingRepository {
  final StationRepository _stationRepository;

  RentingRepositoryFirebase({required StationRepository stationRepository})
    : _stationRepository = stationRepository;

  @override
  Future<Renting> createRenting({
    required String userId,
    required Bike bike,
    required String stationId,
    required int slotIndex,
  }) async {

    final renting = Renting(
      id: '',
      bikeId: bike.id,
      stationId: stationId,
      rentingTime: DateTime.now(),
      expiryTime: DateTime.now().add(const Duration(minutes: 15)),
      isActive: true,
    );

    final bookingUri = FirebaseConfig.baseUri.replace(path: '/bookings.json');

    final bookingResponse = await http.post(
      bookingUri,
      body: json.encode(RentingDto.toJson(renting)),
      headers: {'Content-Type': 'application/json'},
    );

    if (bookingResponse.statusCode != 200) {
      throw Exception(
        'Failed to create booking (${bookingResponse.statusCode})',
      );
    }

    final Map<String, dynamic> bookingBody =
        json.decode(bookingResponse.body) as Map<String, dynamic>;
    final String? rentingId = bookingBody['name'] as String?;
    if (rentingId == null) {
      throw Exception('Firebase did not return a booking id');
    }

    final userUri = FirebaseConfig.baseUri.replace(path: '/users/$userId.json');

    final userResponse = await http.patch(
      userUri,
      body: json.encode({'activeBike': BikeDto.fromModel(bike).toUserJson()}),
      headers: {'Content-Type': 'application/json'},
    );

    if (userResponse.statusCode != 200) {
      throw Exception(
        'Booking created but failed to assign bike to user (${userResponse.statusCode})',
      );
    }

    await _stationRepository.removeBikeFromStation(stationId, slotIndex);

    return Renting(
      id: rentingId,
      bikeId: renting.bikeId,
      stationId: renting.stationId,
      rentingTime: renting.rentingTime,
      expiryTime: renting.expiryTime,
      isActive: renting.isActive,
    );
  }

  @override
  Future<List<Renting>> getRentings() async {
    final uri = FirebaseConfig.baseUri.replace(path: '/bookings.json');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load bookings');
    }

    final Map<String, dynamic>? body =
        json.decode(response.body) as Map<String, dynamic>?;
    if (body == null) return [];

    return body.entries
        .map(
          (entry) => RentingDto.fromJson(
            entry.key,
            entry.value as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  @override
  Future<void> confirmPickup({
    required String rentingId,
    required String userId,
  }) async {
    final bookingUri = FirebaseConfig.baseUri.replace(
      path: '/bookings/$rentingId.json',
    );

    final bookingResponse = await http.patch(
      bookingUri,
      body: json.encode({'pickedUp': true}),
      headers: {'Content-Type': 'application/json'},
    );

    if (bookingResponse.statusCode != 200) {
      throw Exception(
        'Failed to confirm pickup (${bookingResponse.statusCode})',
      );
    }

    final userUri = FirebaseConfig.baseUri.replace(path: '/users/$userId.json');

    final userResponse = await http.patch(
      userUri,
      body: json.encode({'activeBike': null}),
      headers: {'Content-Type': 'application/json'},
    );

    if (userResponse.statusCode != 200) {
      throw Exception(
        'Pickup confirmed but failed to clear user reservation (${userResponse.statusCode})',
      );
    }
  }
}
