import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dtos/renting_dto.dart';
import '../../firebase/firebase_database.dart';
import '../../../model/renting.dart';
import 'renting_repository.dart';

/// Firebase implementation of BookingRepository.
///
/// This repository uses Firebase Realtime Database REST endpoints
/// and keeps repository details separate from the view model.
class RentingRepositoryFirebase implements RentingRepository {
  @override
  Future<Renting> createRenting({
    required String bikeId,
    required String stationId,
  }) async {
    final renting = Renting(
      id: '',
      bikeId: bikeId,
      stationId: stationId,
      rentingTime: DateTime.now(),
      expiryTime: DateTime.now().add(const Duration(minutes: 15)),
      isActive: true,
    );
    final uri = FirebaseConfig.baseUri.replace(path: '/bookings.json');
    print("WOW: ${json.encode(RentingDto.toJson(renting))}");
    final response = await http.post(
      uri,
      body: json.encode(RentingDto.toJson(renting)),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final id = body['name'] as String?;
      if (id == null) {
        throw Exception('Firebase did not return booking id');
      }
      return Renting(
        id: id,
        bikeId: renting.bikeId,
        stationId: renting.stationId,
        rentingTime: renting.rentingTime,
        expiryTime: renting.expiryTime,
        isActive: renting.isActive,
      );
    }

    throw Exception('Failed to create booking (${response.statusCode})');
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
    if (body == null) {
      return [];
    }

    return body.entries
        .map(
          (entry) => RentingDto.fromJson(
            entry.key,
            entry.value as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
