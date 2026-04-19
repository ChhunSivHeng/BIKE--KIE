import 'package:provider/provider.dart';
import 'data/repositories/bookingRepository/booking_repository.dart';
import 'data/repositories/bookingRepository/booking_repository_firebase.dart';
import 'data/repositories/stationRepository/station_repository.dart';
import 'data/repositories/passRepository/pass_repository.dart';
import 'data/repositories/passRepository/pass_repository_firebase.dart';
import 'data/repositories/stationRepository/station_repository_firebase.dart';
import 'data/repositories/userRepository/user_repository.dart';
import 'data/repositories/userRepository/user_repository_firebase.dart';
import 'main_common.dart';

List<InheritedProvider> get devProviders {
  return [
    Provider<StationRepository>(create: (_) => StationRepositoryFirebase()),
    Provider<BookingRepository>(create: (_) => BookingRepositoryFirebase()),
    Provider<PassRepository>(create: (_) => PassRepositoryFirebase()),
    Provider<UserRepository>(create: (_) => UserRepositoryFirebase()),
  ];
}

void main() {
  mainCommon(devProviders);
}
