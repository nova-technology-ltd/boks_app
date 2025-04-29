import 'package:boks/features/auth/service/auth_service.dart';
import 'package:boks/features/profile/model/user_model.dart';
import 'package:boks/features/profile/model/user_provider.dart';
import 'package:boks/features/transactions/service/transaction_services.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:boks/utility/shared_components/custom_loader.dart';
import 'package:boks/utility/shared_components/custom_text_field.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:boks/utility/shared_components/success_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utility/constants/app_colors.dart';
import '../../../utility/constants/app_strings.dart';
import '../../../utility/shared_components/custom_back_button.dart';

class TransferMoneyScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const TransferMoneyScreen({super.key, required this.user});

  @override
  State<TransferMoneyScreen> createState() => _TransferMoneyScreenState();
}

class _TransferMoneyScreenState extends State<TransferMoneyScreen> {
  final _addNoteController = TextEditingController();
  String _displayAmount = "0.0";
  final AuthService _authService = AuthService();

  void _onKeypadPress(String value) {
    setState(() {
      if (_displayAmount == "0.0" && value != ".") {
        _displayAmount = value;
      } else {
        String newAmount = _displayAmount + value;
        double parsedAmount = double.tryParse(newAmount) ?? 0.0;
        if (parsedAmount <= 20000.0) {
          _displayAmount = newAmount;
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_displayAmount.isNotEmpty) {
        _displayAmount = _displayAmount.substring(0, _displayAmount.length - 1);
        if (_displayAmount.isEmpty || _displayAmount == "0") {
          _displayAmount = "0.0";
        }
      }
    });
  }

  void _onSendClick(UserModel user) {
    setState(() {
      if (_displayAmount != "0.0" &&
          _displayAmount != "0" &&
          _displayAmount.isNotEmpty) {
        if (user.userWallet!.accountBalance < int.parse(_displayAmount)) {
          showSnackBar(
            context: context,
            message:
                "Your account balance is insufficient to complete this transaction.",
            title: "Insufficient Funds",
          );
        } else {
          _sendMoney(
            context: context,
            recipientBoxID: widget.user['boksID'],
            amount: _displayAmount,
            narration: _addNoteController.text.trim(),
          );
        }
      } else {
        showSnackBar(
          context: context,
          message: "Please provide the amount you want to transfer.",
          title: "Amount Required",
        );
      }
    });
  }

  final TransactionService _transactionService = TransactionService();
  bool isSending = false;

  Future<void> _sendMoney({
    required BuildContext context,
    required recipientBoxID,
    required amount,
    required narration,
  }) async {
    try {
      setState(() {
        isSending = true;
      });
      int response = await _transactionService.sendMoney(
        context: context,
        recipientBoxID: recipientBoxID,
        amount: amount,
        narration: narration,
      );
      if (response == 200 || response == 201) {
        setState(() {
          isSending = false;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => SuccessScreen(
                    title: "Success!",
                    subMessage: "You have successfully transferred some funds",
                    onClick: () {
                      Navigator.pop(context);
                    },
                  ),
            ),
          );
        });
        // await _authService.userProfile(context);
      } else {
        setState(() {
          isSending = false;
        });
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message:
            "Sorry, but we could not process your request at the moment, please try again later. Thank You",
        title: "Something Went Wrong",
      );
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _textFieldFocusNode = FocusNode();
    _textFieldFocusNode.addListener(() {
      if (_textFieldFocusNode.hasFocus) {
        setState(() {
          isKeypadVisible = false;
        });
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              isKeypadVisible = true;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  bool isKeypadVisible = true;
  late FocusNode _textFieldFocusNode;

  @override
  Widget build(BuildContext context) {
    final fullName =
        "${widget.user['firstName']} ${widget.user["lastName"]} ${widget.user["otherNames"]}";
    final user = Provider.of<UserProvider>(context).userModel;
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: CustomBackButton(context: context),
              centerTitle: true,
              title: const Text(
                "Transfer Money",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset("images/splash_screen_logo.png"),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // height: 55,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      // color: Colors.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 5,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: widget.user['image'].isEmpty ? Center(
                              child: Icon(
                                IconlyBold.profile,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ) : Image.network(widget.user['image'], fit: BoxFit.cover, errorBuilder: (context, err, st) {
                              return Center(
                                child: Icon(
                                  IconlyBold.profile,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                              );
                            },),
                          ),
                          const SizedBox(height: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                fullName.length > 21
                                    ? "${fullName.substring(0, 21)}.."
                                    : fullName,
                                style: TextStyle(fontSize: 13),
                              ),
                              Text(
                                formatNumberWithAsterisks(
                                  int.parse(widget.user['phoneNumber']),
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: AppStrings.nairaSign,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${_formatPrice(double.parse(_displayAmount))}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 45,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          AppColors.primaryColor,
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'NGN',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: "add note",
                    prefixIcon: null,
                    isObscure: false,
                    color: Colors.grey.withOpacity(0.05),
                    focusNode: _textFieldFocusNode,
                    controller: _addNoteController,
                  ),
                  const SizedBox(height: 10),
                  if (isKeypadVisible) buildKeypad(user, isSending),
                ],
              ),
            ),
          ),
          if (isSending)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
        ],
      ),
    );
  }

  String formatNumberWithAsterisks(int number) {
    String numStr = number.toString();
    if (numStr.length < 2) {
      return numStr;
    }
    String lastTwoDigits = numStr.substring(numStr.length - 2);
    String asterisks = '*' * (numStr.length - 2);
    List<String> asteriskGroups = [];
    for (int i = 0; i < asterisks.length; i += 3) {
      int end = (i + 3) < asterisks.length ? (i + 3) : asterisks.length;
      asteriskGroups.add(asterisks.substring(i, end));
    }
    return asteriskGroups.join(' ') + ' ' + lastTwoDigits;
  }

  String _formatPrice(double price) {
    try {
      return _formatNumber(price);
    } catch (e) {
      print('Error formatting price: $e');
      return '0';
    }
  }

  String _formatNumber(double number) {
    NumberFormat formatter = NumberFormat("#,###");
    return formatter.format(number);
  }

  Widget buildKeypad(UserModel user, bool isSending) {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['x', '0', 'Send'],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                row
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 5,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (e == 'x') {
                              _onBackspace();
                            } else if (e == "Send") {
                              _onSendClick(user);
                            } else {
                              _onKeypadPress(e);
                            }
                          },
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color:
                                  e == "Send"
                                      ? Color(AppColors.primaryColor)
                                      : Colors.grey.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child:
                                  e == "Send"
                                      ? SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: Transform.rotate(
                                          angle: -1.5,
                                          child:
                                              isSending
                                                  ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          2.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeCap:
                                                                StrokeCap.round,
                                                            strokeWidth: 5,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  )
                                                  : Image.asset(
                                                    "images/arrow-down-from-arc.png",
                                                    color: Colors.white,
                                                  ),
                                        ),
                                      )
                                      : Text(
                                        e,
                                        style: TextStyle(
                                          fontSize: e == "Send" ? 14 : 18,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              e == "Send" ? Colors.white : null,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
      ],
    );
  }
}
