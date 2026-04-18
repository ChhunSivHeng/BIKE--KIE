import '../../../model/pass.dart';
import '../../mock/mockData.dart';
import 'pass_repository.dart';

class PassRepositoryMock implements PassRepository {
  int _callCount = 0;

  Future<void> _simulateNetwork() async {
    _callCount++;
    await Future.delayed(const Duration(seconds: 1));
    if (_callCount % 2 == 0) {
      throw Exception('Error');
    }
  }

  @override
  Future<List<Pass>> getPasses() async {
    await _simulateNetwork();
    return List<Pass>.unmodifiable(MockData.passRepositoryPasses);
  }
}
