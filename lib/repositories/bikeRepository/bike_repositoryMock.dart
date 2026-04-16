import '../../model/bike.dart';
import 'bike_repository.dart';

class BikeRepositoryMock implements BikeRepository {
	int _callCount = 0;
	final List<Bike> _bikes = [
		Bike(id: 'bike_1', stationId: 'station_1', status: BikeStatus.available, batteryLevel: 100),
		Bike(id: 'bike_2', stationId: 'station_1', status: BikeStatus.available, batteryLevel: 80),
		Bike(id: 'bike_3', stationId: 'station_2', status: BikeStatus.empty, batteryLevel: 0),
	];

	Future<void> _simulateNetwork() async {
		_callCount++;
		await Future.delayed(const Duration(seconds: 3));
		if (_callCount % 2 == 0) {
			throw Exception('Mock API Error');
		}
	}

	@override
	Future<List<Bike>> getBikesByStation(String stationId) async {
		await _simulateNetwork();
		return _bikes.where((b) => b.stationId == stationId).toList();
	}

	@override
	Future<void> updateBikeStatus({required String bikeId, required BikeStatus status}) async {
		await _simulateNetwork();
		final index = _bikes.indexWhere((b) => b.id == bikeId);
		if (index != -1) {
			final current = _bikes[index];
			_bikes[index] = Bike(
				id: current.id,
				stationId: current.stationId,
				status: status,
				batteryLevel: current.batteryLevel,
			);
		}
	}
}
