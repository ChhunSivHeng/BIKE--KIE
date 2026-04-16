import '../../model/pass.dart';
import 'pass_repository.dart';

class PassRepositoryMock implements PassRepository {
  int _callCount = 0;

  Future<void> _simulateNetwork() async {
    _callCount++;
    await Future.delayed(const Duration(seconds: 3));
    if (_callCount % 2 == 0) {
      throw Exception('Mock API Error');
    }
  }

  @override
  Future<List<Pass>> getPasses() async {
    await _simulateNetwork();
    final now = DateTime.now();
    return [
      Pass(id: 'pass_1', type: PassType.day, price: 5.0, startDate: now, endDate: now.add(const Duration(days: 1)), isActive: true),
      Pass(id: 'pass_2', type: PassType.monthly, price: 50.0, startDate: now, endDate: now.add(const Duration(days: 30)), isActive: true),
      Pass(id: 'pass_3', type: PassType.annual, price: 500.0, startDate: now, endDate: now.add(const Duration(days: 365)), isActive: true),
    ];
  }
}
