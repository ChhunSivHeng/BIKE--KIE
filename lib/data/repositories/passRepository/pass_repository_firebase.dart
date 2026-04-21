import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dtos/pass_dto.dart';
import '../../firebase/firebase_database.dart';
import '../../../model/pass.dart';
import 'pass_repository.dart';

/// Firebase implementation of PassRepository using Realtime Database
class PassRepositoryFirebase implements PassRepository {
  /// Get all available passes from Firebase
  @override
  Future<List<Pass>> getPasses() async {
    try {
      final uri = FirebaseConfig.baseUri.replace(path: '/passes.json');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? body =
            json.decode(response.body) as Map<String, dynamic>?;
        if (body == null || body.isEmpty) {
          return [];
        }

        return body.entries
            .map(
              (entry) => PassDto.fromJson({
                ...entry.value as Map<String, dynamic>,
                'id': entry.key,
              }).toModel(),
            )
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load passes: $e');
    }
  }

  /// Create a new temporary ticket in Firebase
  ///
  /// Flow:
  /// 1. Generate unique ticket ID (ticket_timestamp_userId)
  /// 2. POST to /passes/{ticketId}
  /// 3. Return Pass object with ID from Firebase
  @override
  Future<Pass> createTicket({
    required String userId,
    required PassType type,
    required double price,
  }) async {
    try {
      final ticketId =
          'ticket_${DateTime.now().millisecondsSinceEpoch}_$userId';
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 1));

      final pass = Pass(
        id: ticketId,
        type: type,
        price: price,
        startDate: now,
        endDate: endDate,
        isActive: true,
      );

      final uri = FirebaseConfig.baseUri.replace(
        path: '/tickets/$ticketId.json',
      );
      final response = await http.put(
        uri,
        body: json.encode(PassDto.fromModel(pass).toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return pass;
      }

      throw Exception('Failed to create ticket (${response.statusCode})');
    } catch (e) {
      throw Exception('Error creating ticket: $e');
    }
  }
}
