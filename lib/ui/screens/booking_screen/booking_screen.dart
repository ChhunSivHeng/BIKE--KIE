import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/bookingRepository/booking_repository.dart';
import '../../../data/repositories/userRepository/user_repository.dart';
import '../../../data/repositories/passRepository/pass_repository.dart';
import '../../../model/station.dart';
import 'view_model/booking_model.dart';
import 'widgets/booking_content.dart';

/// Booking screen entry point
///
/// Responsibility:
/// - Accept station parameter from navigation
/// - Inject all required repositories from global Provider
/// - Create BookingViewModel with dependencies
/// - Provide ViewModel to content widget via ChangeNotifierProvider
///
/// Dependency Injection:
/// - BookingRepository, UserRepository, PassRepository come from global Provider (main_dev.dart)
/// - Station comes from route navigation
/// - BookingViewModel loads current user from Firebase on initialization
class BookingScreen extends StatelessWidget {
  final Station? station;

  const BookingScreen({super.key, this.station});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingViewModel(
        station: station,
        bookingRepository: context.read<BookingRepository>(),
        userRepository: context.read<UserRepository>(),
        passRepository: context.read<PassRepository>(),
      ),
      child: const BookingContent(),
    );
  }
}
