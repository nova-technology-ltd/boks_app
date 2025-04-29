import 'package:boks/features/profile/model/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel _userModel = UserModel(
    id: '',
    boksID: '',
    firstName: '',
    lastName: '',
    otherNames: '',
    userName: '',
    image: '',
    phoneNumber: '',
    gender: '',
    dob: '',
    email: '',
    password: '',
    transactionPIN: null,
    token: '',
    isEmailVerified: false,
    connections: [],
    myInvites: [],
    recentTransactions: [],
    inviteCode: '',
    createdAt: null,
    updatedAt: null,
    userWallet: UserWallet(
      accountReference: '',
      accountName: '',
      currencyCode: 'NGN',
      customerEmail: '',
      customerName: '',
      accountNumber: '',
      bankName: '',
      bankCode: '',
      reservationReference: '',
      status: '',
      createdOn: null,
      accountBalance: 0,
    ),
    otpCode: '',
    otpExpires: null
  );

  String? _loggedInUserId;

  UserModel get userModel => _userModel;

  String? get loggedInUserId => _loggedInUserId;

  void setUser(String user) {
    _userModel = UserModel.fromJson(user);
    _loggedInUserId = _userModel.id;
    notifyListeners();
  }

  void setUserFromModel(UserModel userModel) {
    _userModel = userModel;
    _loggedInUserId = userModel.id;
    notifyListeners();
  }
}
