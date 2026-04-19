import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dtos/booking_dto.dart';
import '../../firebase/firebase_database.dart';
import '../../../model/booking.dart';
import 'booking_repository.dart';

/// Firebase implementation of BookingRepository.
///
/// This repository uses Firebase Realtime Database REST endpoints
/// and keeps repository details separate from the view model.
class BookingRepositoryFirebase implements BookingRepository {
  @override
  Future<Booking> createBooking({
    required String bikeId,
    required String stationId,
  }) async {
    final booking = Booking(
      id: '',
      bikeId: bikeId,
      stationId: stationId,
      bookingTime: DateTime.now(),
      expiryTime: DateTime.now().add(const Duration(minutes: 15)),
      isActive: true,
    );

    final uri = FirebaseConfig.baseUri.replace(path: '/bookings.json');
    final response = await http.post(
      uri,
      body: json.encode(BookingDto.toJson(booking)),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final id = body['name'] as String?;
      if (id == null) {
        throw Exception('Firebase did not return booking id');
      }
      return Booking(
        id: id,
        bikeId: booking.bikeId,
        stationId: booking.stationId,
        bookingTime: booking.bookingTime,
        expiryTime: booking.expiryTime,
        isActive: booking.isActive,
      );
    }

    throw Exception('Failed to create booking (${response.statusCode})');
  }

  @override
  Future<List<Booking>> getBookings() async {
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
          (entry) => BookingDto.fromJson(
            entry.key,
            entry.value as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
