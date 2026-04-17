import 'package:flutter/foundation.dart';
import '../../../../model/station.dart';

class BookingViewModel extends ChangeNotifier {
  final Station? _station;

  BookingViewModel({Station? station}) : _station = station;

  Station? get station => _station;
}
