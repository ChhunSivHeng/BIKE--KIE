import '../../../model/pass.dart';

abstract class PassRepository {
  Future<List<Pass>> getPasses();
  
  Future<Pass> createTicket({
    required String userId,
    required PassType type,
    required double price,
  });
}
