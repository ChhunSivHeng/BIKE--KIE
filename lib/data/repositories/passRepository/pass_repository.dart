import '../../../model/pass.dart';

abstract class PassRepository {
  Future<List<Pass>> getPasses();
}
