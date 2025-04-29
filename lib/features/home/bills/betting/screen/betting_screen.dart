import 'package:boks/features/home/bills/betting/components/betting_service_list_bottom_sheet.dart';
import 'package:boks/features/home/bills/betting/provider/selected_betting_service_provider.dart';
import 'package:boks/features/home/bills/betting/service/betting_services.dart';
import 'package:boks/utility/constants/app_icons.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:boks/utility/shared_components/success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utility/constants/app_colors.dart';
import '../../../../../utility/constants/app_strings.dart';
import '../../../../../utility/shared_components/amount_card.dart';
import '../../../../../utility/shared_components/custom_back_button.dart';
import '../../../../../utility/shared_components/custom_button.dart';
import '../../../../../utility/shared_components/custom_text_field.dart';
import '../../../../../utility/shared_components/enter_pin_bottom_sheet.dart';

class BettingScreen extends StatefulWidget {
  const BettingScreen({super.key});

  @override
  State<BettingScreen> createState() => _BettingScreenState();
}

class _BettingScreenState extends State<BettingScreen> {
  final BettingService _bettingService = BettingService();
  final _priceController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _futureBettingService;

  @override
  void initState() {
    _futureBettingService = _bettingService.allBettingServiceProvider(context);
    super.initState();
  }

  String selectedType = "";
  final _userIDController = TextEditingController();
  final prices = ["1000", "3000", "6000", "8000", "10000", "12000", "14000"];
  String statusMessage = "";
  bool isLoading = false;
  

  Future<void> _funBettingAccount(
    BuildContext context,
    String bettingCompany,
    String customerId,
    String amount,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      String response = await _bettingService.fundBetting(context: context, bettingCompany: bettingCompany, customerId: customerId, amount: amount,);
      if (response == "ORDER_COMPLETED") {
        setState(() {
          isLoading = false;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuccessScreen(title: "Success!", subMessage: "You have successfully funded your betting account", onClick: (){Navigator.pop(context);})));
        });
      } else if (response == "ORDER_RECEIVED") {
        setState(() {
          isLoading = false;
          showSnackBar(context: context, message: ("You request is being processed. This usually happens when wrong details are provided and are being verified"), title: "Request Pending");
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        statusMessage = "verification failed";
      });
      print("Something went wrong: ${e}");
    }
  }


  String selectedPrice = '';
  Future<void> _showPINBottomSheet(BuildContext context) async {
    // showCupertinoModalPopup(
    //   context: context,
    //   builder: (context) {
    //     return EnterPinBottomSheet();
    //   },
    // );
  }

  Future<void> _showBettingServices(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return BettingServiceListBottomSheet(
          futureService: _futureBettingService,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems =
        Provider.of<SelectedBettingServiceProvider>(context).selectedProvider;
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
                "Betting",
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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        // color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color:
                                        selectedItems!.imageUrl == ""
                                            ? Colors.grey.withOpacity(0.2)
                                            : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      selectedItems.imageUrl == "" ? 10.0 : 0,
                                    ),
                                    child: Image.asset(
                                      selectedItems.imageUrl == ""
                                          ? AppIcons.bettingIcon
                                          : selectedItems.imageUrl,
                                      color:
                                          selectedItems.imageUrl == ""
                                              ? Colors.grey
                                              : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      selectedItems.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Selected Service",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () => _showBettingServices(context),
                              icon: Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      // height: 160,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 25,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User ID",
                                  style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w500
                                  ),
                                ),
                                CustomTextField(
                                  hintText: "User ID",
                                  prefixIcon: null,
                                  isObscure: false,
                                  controller: _userIDController,
                                  onChange: (value) {
                                    setState(() {
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        for (int i = 0; i < prices.length; i += 4)
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int j = 0; j < 4; j++)
                                if (i + j < prices.length)
                                  Expanded(
                                    child: HexagonWithText(
                                      price: prices[i + j],
                                      onClick: () {
                                        setState(() {
                                          selectedPrice =
                                          prices[i + j];
                                          _priceController.text =
                                              selectedPrice;
                                        });
                                      },
                                      selectedPrice: selectedPrice,
                                    ),
                                  )
                                else
                                  Expanded(child: Container()),
                              // Empty container for alignment
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText:
                          "min~${AppStrings.nairaSign}1000, max~${AppStrings.nairaSign}50000",
                      prefixIcon: null,
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      isObscure: false,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomButton(
                title: "Pay",
                onClick: () {
                  if (selectedItems.id != "" && _userIDController.text.trim().isNotEmpty && _priceController.text.trim().isNotEmpty) {
                    _funBettingAccount(context, selectedItems.id, _userIDController.text.trim(), _priceController.text.trim());
                  } else {
                    showSnackBar(context: context, message: "Please be sure to provide all necessary information, before proceeding to pay", title: "All Fields are required");
                  }
                },
                isLoading: isLoading ? true : false,
              ),
            ),
          ),
          if (isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0)
              ),
            )
        ],
      ),
    );
  }
}
