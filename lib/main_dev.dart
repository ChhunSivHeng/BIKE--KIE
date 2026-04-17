import 'package:provider/provider.dart';
import 'data/repositories/stationRepository/station_repositoryMock.dart';
import 'data/repositories/stationRepository/station_repository.dart';
import 'data/repositories/passRepository/pass_repositoryMock.dart';
import 'data/repositories/passRepository/pass_repository.dart';
import 'data/repositories/userRepository/user_repositoryMock.dart';
import 'data/repositories/userRepository/user_repository.dart';
import 'data/repositories/bikeRepository/bike_repositoryMock.dart';
import 'data/repositories/bikeRepository/bike_repository.dart';
import 'main_common.dart';

List<InheritedProvider> get devProviders {
  return [
    Provider<StationRepository>(
      create: (_) => StationRepositoryMock(),
    ),
    Provider<PassRepository>(
      create: (_) => PassRepositoryMock(),
    ),
    Provider<UserRepository>(
      create: (_) => UserRepositoryMock(),
    ),
    Provider<BikeRepository>(
      create: (_) => BikeRepositoryMock(),
    ),
  ];
}

void main() {
  mainCommon(devProviders);
}
