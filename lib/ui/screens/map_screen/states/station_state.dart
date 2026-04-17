import '../../../../model/station.dart';
export '../../../../model/station.dart';

enum Status { loading, success, error }

class StationState {
  final Status status;
  final List<Station> stations;
  final String? error;

  const StationState._({
    required this.status,
    required this.stations,
    required this.error,
  });

  factory StationState.loading() => const StationState._(
    status: Status.loading,
    stations: <Station>[],
    error: null,
  );

  factory StationState.success(List<Station> data) => StationState._(
    status: Status.success,
    stations: List<Station>.unmodifiable(data),
    error: null,
  );

  factory StationState.error(String message) => StationState._(
    status: Status.error,
    stations: const <Station>[],
    error: message,
  );
}
