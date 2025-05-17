import 'package:flutter/foundation.dart';
import 'package:termin_amo/models/user_type.dart';

class UserProvider with ChangeNotifier {
  UserType _userType = UserType.normal;

  UserType get userType => _userType;

  void toggleUserType() {
    _userType = _userType == UserType.normal ? UserType.business : UserType.normal;
    notifyListeners();
  }
}