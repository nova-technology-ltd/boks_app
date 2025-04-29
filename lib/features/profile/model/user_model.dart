import 'dart:convert';

class UserModel {
  final String id;
  final String boksID;
  final String firstName;
  final String lastName;
  final String otherNames;
  final String userName;
  final String image;
  final String phoneNumber;
  final String gender;
  final String dob;
  final String email;
  final String password;
  final int? transactionPIN;
  final String token;
  final bool isEmailVerified;
  final List<dynamic> connections;
  final List<dynamic> myInvites;
  final List<dynamic> recentTransactions;
  final String inviteCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserWallet? userWallet;
  final String otpCode;
  final DateTime? otpExpires;

  UserModel({
    required this.id,
    required this.boksID,
    required this.firstName,
    required this.lastName,
    required this.otherNames,
    required this.userName,
    required this.image,
    required this.phoneNumber,
    required this.gender,
    required this.dob,
    required this.email,
    required this.password,
    this.transactionPIN,
    required this.token,
    required this.isEmailVerified,
    required this.connections,
    required this.myInvites,
    required this.recentTransactions,
    required this.inviteCode,
    required this.createdAt,
    required this.updatedAt,
    required this.userWallet,
    required this.otpCode,
    this.otpExpires,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      boksID: map['boksID'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      otherNames: map['otherNames'] ?? '',
      userName: map['userName'] ?? "",
      image: map['image'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      gender: map['gender'] ?? '',
      dob: map['dob'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      transactionPIN: map['transactionPIN'] ?? 0,
      token: map['token'] ?? '',
      isEmailVerified: map['isEmailVerified'] ?? false,
      connections: map['connections'] ?? [],
      myInvites: map['myInvites'] ?? [],
      recentTransactions: map['recentTransactions'] ?? [],
      inviteCode: map['inviteCode'] ?? "",
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      userWallet: map['userWallet'] != null ? UserWallet.fromMap(map['userWallet']) : null,
      otpCode: map['otpCode'] ?? "",
      otpExpires: map['otpExpires'] != null ? DateTime.parse(map['otpExpires']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'boksID': boksID,
      'firstName': firstName,
      'lastName': lastName,
      'otherNames': otherNames,
      'userName': userName,
      'image': image,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dob': dob,
      'email': email,
      'password': password,
      'transactionPIN': transactionPIN,
      'token': token,
      'isEmailVerified': isEmailVerified,
      'connections': connections,
      'myInvites': myInvites,
      'recentTransactions': recentTransactions,
      'inviteCode': inviteCode,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'userWallet': userWallet?.toMap(),
      'otpCode': otpCode,
      'otpExpires': otpExpires?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? id,
    String? boksID,
    String? firstName,
    String? lastName,
    String? otherNames,
    String? userName,
    String? image,
    String? phoneNumber,
    String? gender,
    String? dob,
    String? email,
    String? password,
    int? transactionPIN,
    String? token,
    bool? isEmailVerified,
    List<dynamic>? connections,
    List<dynamic>? myInvites,
    List<dynamic>? recentTransactions,
    String? inviteCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserWallet? userWallet,
    String? otpCode,
    DateTime? otpExpires,
  }) {
    return UserModel(
      id: id ?? this.id,
      boksID: boksID ?? this.boksID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      otherNames: otherNames ?? this.otherNames,
      userName: userName ?? this.userName,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      password: password ?? this.password,
      transactionPIN: transactionPIN ?? this.transactionPIN,
      token: token ?? this.token,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      connections: connections ?? this.connections,
      myInvites: myInvites ?? this.myInvites,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      inviteCode: inviteCode ?? this.inviteCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userWallet: userWallet ?? this.userWallet,
      otpCode: otpCode ?? this.otpCode,
      otpExpires: otpExpires ?? this.otpExpires,
    );
  }
}

class UserWallet {
  final String accountReference;
  final String accountName;
  final String currencyCode;
  final String customerEmail;
  final String customerName;
  final String accountNumber;
  final String bankName;
  final String bankCode;
  final String reservationReference;
  final String status;
  final DateTime? createdOn;
  final double accountBalance;
  final String? id;

  UserWallet({
    required this.accountReference,
    required this.accountName,
    required this.currencyCode,
    required this.customerEmail,
    required this.customerName,
    required this.accountNumber,
    required this.bankName,
    required this.bankCode,
    required this.reservationReference,
    required this.status,
    required this.createdOn,
    required this.accountBalance,
    this.id,
  });

  factory UserWallet.fromMap(Map<String, dynamic> map) {
    return UserWallet(
      accountReference: map['accountReference'] ?? '',
      accountName: map['accountName'] ?? '',
      currencyCode: map['currencyCode'] ?? 'NGN',
      customerEmail: map['customerEmail'] ?? '',
      customerName: map['customerName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      bankName: map['bankName'] ?? '',
      bankCode: map['bankCode'] ?? '',
      reservationReference: map['reservationReference'] ?? '',
      status: map['status'] ?? '',
      createdOn: map['createdOn'] != null ? DateTime.parse(map['createdOn']) : null,
      accountBalance: (map['accountBalance'] ?? 0).toDouble(),
      id: map['_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountReference': accountReference,
      'accountName': accountName,
      'currencyCode': currencyCode,
      'customerEmail': customerEmail,
      'customerName': customerName,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'bankCode': bankCode,
      'reservationReference': reservationReference,
      'status': status,
      'createdOn': createdOn?.toIso8601String(),
      'accountBalance': accountBalance,
      '_id': id,
    };
  }
}