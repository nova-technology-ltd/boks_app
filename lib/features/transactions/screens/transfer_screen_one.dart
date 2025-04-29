import 'package:boks/features/profile/model/user_provider.dart';
import 'package:boks/features/transactions/components/recipient_search_result_card_style.dart';
import 'package:boks/features/transactions/screens/transfer_money_screen.dart';
import 'package:boks/features/transactions/service/transaction_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants/app_colors.dart';
import '../../../utility/shared_components/custom_back_button.dart';
import '../../../utility/shared_components/custom_text_field.dart';
import '../../../utility/shared_components/show_snack_bar.dart';
import '../../auth/service/auth_service.dart';
import '../components/recent_transfer_section.dart';
import '../components/recent_transfer_section_two.dart';

class TransferScreenOne extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> futureRecentTransfers;
  const TransferScreenOne({super.key, required this.futureRecentTransfers});

  @override
  State<TransferScreenOne> createState() => _TransferScreenOneState();
}

class _TransferScreenOneState extends State<TransferScreenOne> {
  final _searchRecipientController = TextEditingController();
  bool isLoading = false;
  bool isChecking = false;
  bool isExisting = false;
  bool isNotExisting = false;
  bool badStart = false;
  List<Map<String, dynamic>> _searchResults = [];
  String? _currentUserId;

  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    _transactionService.getDataBundle(context);
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    final userData = Provider.of<UserProvider>(context, listen: false).userModel;
    setState(() {
      _currentUserId = userData?.boksID; // Using null-aware operator
    });
  }

  Future<void> _startSearchingForRecipient(BuildContext context, String data) async {
    try {
      setState(() {
        isChecking = true;
        _searchResults = [];
      });

      final results = await _transactionService.searchRecipient(context, data);

      // Filter out the current user from results
      final filteredResults = results.where((user) {
        return user['boksID'] != null &&
            _currentUserId != null &&
            user['boksID'] != _currentUserId;
      }).toList();

      setState(() {
        isChecking = false;
        _searchResults = filteredResults;
      });
    } catch (e) {
      setState(() {
        isChecking = false;
        isExisting = false;
        isNotExisting = false;
        _searchResults = [];
      });
      debugPrint('Error searching for recipient: $e');
    }
  }

  void _handleUserSelection(Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferMoneyScreen(user: user),
      ),
    );
  }

  List<Widget> _buildSearchResultList() {
    return _searchResults.map((user) {
      return RecipientSearchResultCardStyle(
        user: user,
        onClick: () => _handleUserSelection(user),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                "Transfer",
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 45,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.purple[200],
                                        border: Border.all(
                                          width: 1.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                          "images/STK-20240102-WA0149.webp",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 45,
                                      width: 45,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue[200],
                                        border: Border.all(
                                          width: 1.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: Image.asset(
                                          "images/STK-20240102-WA0044.webp",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 45,
                                      width: 45,
                                      margin: const EdgeInsets.only(left: 60),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.orange[200],
                                        border: Border.all(
                                          width: 1.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: Image.asset(
                                          "images/STK-20240102-WA0157.webp",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    "Search for a recipient by entering their full name, mobile number, or email address. You can also type partial information to find matching contacts.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  RecentTransferSectionTwo(futureRecentTransfers: widget.futureRecentTransfers,),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: CustomTextField(
                      hintText: "e.g: username",
                      prefixIcon: const Icon(
                        IconlyLight.search,
                        color: Colors.grey,
                      ),
                      isObscure: false,
                      controller: _searchRecipientController,
                      onChange: (value) {
                        if (_searchRecipientController.text.trim().isEmpty) {
                          setState(() {
                            badStart = false;
                            _searchResults = [];
                          });
                        } else if (_searchRecipientController.text
                            .trim()
                            .startsWith("@")) {
                          setState(() {
                            badStart = true;
                            _searchResults = [];
                          });
                        } else {
                          setState(() {
                            badStart = false;
                            _startSearchingForRecipient(
                              context,
                              _searchRecipientController.text.trim(),
                            );
                          });
                        }
                      },
                    ),
                  ),
                  _searchResults.isNotEmpty ? const SizedBox(height: 10,) : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      badStart
                          ? const Expanded(
                        child: Text(
                          "Please make sure not to start your username with the \"@\" symbol or any numbers.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                          ),
                        ),
                      )
                          : Text(
                        _searchRecipientController.text.trim().isEmpty
                            ? ""
                            : isChecking
                            ? "checking"
                            : isExisting
                            ? "Tag already in use"
                            : isNotExisting
                            ? "Free tag"
                            : "",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color:
                          _searchRecipientController.text
                              .trim()
                              .isEmpty
                              ? Colors.transparent
                              : isChecking
                              ? const Color(AppColors.primaryColor)
                              : isExisting
                              ? Colors.red
                              : isNotExisting
                              ? Colors.green
                              : Colors.transparent,
                        ),
                      ),
                      SizedBox(width: isChecking ? 5 : 0),
                      SizedBox(
                        height: 10,
                        width: 10,
                        child:
                        isChecking
                            ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(AppColors.primaryColor),
                          strokeCap: StrokeCap.round,
                        )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  if (_searchResults.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                              ),
                              child: Column(children: _buildSearchResultList()),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}