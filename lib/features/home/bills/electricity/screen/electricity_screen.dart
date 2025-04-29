import 'package:boks/features/home/bills/electricity/component/service_list_bottom_sheet.dart';
import 'package:boks/features/home/bills/electricity/service/electricity_service.dart';
import 'package:boks/utility/constants/app_colors.dart';
import 'package:boks/utility/constants/app_strings.dart';
import 'package:boks/utility/shared_components/amount_card.dart';
import 'package:boks/utility/shared_components/custom_back_button.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:boks/utility/shared_components/custom_text_field.dart';
import 'package:boks/utility/shared_components/enter_pin_bottom_sheet.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:boks/utility/shared_components/success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../provider/selected_electricity_service_provider.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  final ElectricityService _electricityService = ElectricityService();
  final _priceController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  Future<void> _showElectricityServices(BuildContext context) async {
    showCupertinoModalPopup(context: context, builder: (context) {
      return ServiceListBottomSheet(futureService: _futureServices,);
    });
  }
  late Future<List<Map<String, dynamic>>> _futureServices;

  String selectedPrice = '';
  @override
  void initState() {
    _futureServices = _electricityService.allElectricityServiceProvider(context);
    super.initState();
  }
  String selectedType = "";
  final _meterNumberController = TextEditingController();
  final prices = [
    "1000",
    "3000",
    "6000",
    "8000",
    "10000",
    "12000",
    "14000",
  ];
  bool isLoading = false;

  String selectedService = "";
  String statusMessage = "";
  bool isVerifying = false;
  Future<void> _verifyMeterNumber(BuildContext context, String electricCompany, String meterNo) async {
    try {
      setState(() {
        isVerifying = true;
        statusMessage = "verifying";
      });
      int response = await _electricityService.verifyMeterCardNumber(context, electricCompany, meterNo);
      if (response == 100) {
        setState(() {
          isVerifying = false;
          statusMessage = "verified";
        });
      } else {
        setState(() {
          isVerifying = false;
          statusMessage = "invalid meter number";
        });
      }
    } catch (e) {
      setState(() {
        isVerifying = false;
        statusMessage = "verification failed";
      });
      print("Something went wrong: ${e}");
    }
  }
  Future<void> _showPINBottomSheet(BuildContext context) async {
    // showCupertinoModalPopup(context: context, builder: (context) {
    //   return EnterPinBottomSheet();
    // });
  }

  Future<void> _payElectricityBill({
    required BuildContext context,
    required String electricCompany,
    required String meterType,
    required String meterNo,
    required String amount,
    required String phoneNo,}) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await _electricityService.payElectricityBill(context: context, electricCompany: electricCompany, meterType: meterType, meterNo: meterNo, amount: amount, phoneNo: phoneNo,);
      if (response == "ORDER_COMPLETED" || response == "ORDER_RECEIVED") {
        setState(() {
          isLoading = false;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuccessScreen(title: "Success!", subMessage: "You have successfully paid for your electricity", onClick: (){Navigator.pop(context);})));
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context: context, message: "We were unable to complete your request, please try again later. Thank You", title: "Something Went Wrong");
    }
  }
  @override
  Widget build(BuildContext context) {
    final selectedItems =
        Provider.of<SelectedElectricityServiceProvider>(context).selectedProvider;
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
                "Electricity",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("images/splash_screen_logo.png")),
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
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () => _showElectricityServices(context),
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
                                      color: selectedItems!.imageUrl == "" ? Colors.grey.withOpacity(0.2) : Colors.transparent,
                                        shape: BoxShape.circle
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(selectedItems.imageUrl == "" ? 10.0 : 0),
                                      child: Image.asset(selectedItems.imageUrl == "" ? "images/bolt.png": selectedItems.imageUrl, color: selectedItems.imageUrl == "" ? Colors.grey : null,),
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        selectedItems.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      Text(
                                        "Selected Service",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              IconButton(onPressed: () => _showElectricityServices(context),icon: Icon(Icons.arrow_downward_rounded, color: Colors.grey,))
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
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
                            spreadRadius: 3
                          )
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Payment Type",
                                  style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w500
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 35,
                                        width: MediaQuery.of(context).size.width,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: selectedType == "Prepaid" ? Color(AppColors.primaryColor).withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: MaterialButton(
                                          onPressed: (){
                                            setState(() {
                                              selectedType = "Prepaid";
                                            });
                                          },
                                          child: Center(
                                            child: Text(
                                              "Prepaid",
                                              style: TextStyle(
                                                fontSize: 13,
                                                  color: selectedType == "Prepaid" ? Color(AppColors.primaryColor) : Colors.grey
                                                // fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    Expanded(
                                      child: Container(
                                        height: 35,
                                        width: MediaQuery.of(context).size.width,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: selectedType == "Postpaid" ? Color(AppColors.primaryColor).withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: MaterialButton(
                                          onPressed: (){
                                            setState(() {
                                              selectedType = "Postpaid";
                                            });
                                          },
                                          child: Center(
                                            child: Text(
                                              "Postpaid",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: selectedType == "Postpaid" ? Color(AppColors.primaryColor) : Colors.grey
                                                // fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Meter Number",
                                  style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w500
                                  ),
                                ),
                                CustomTextField(hintText: "meter number", prefixIcon: null, isObscure: false, keyboardType: TextInputType.number,controller: _meterNumberController, onChange: (value) {
                                  setState(() {
                                    _verifyMeterNumber(context, selectedItems.id, value);
                                  });
                                },),
                                const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      statusMessage,
                                      style: TextStyle(
                                          color: Colors.grey
                                      ),
                                    ),
                                    isVerifying ? SizedBox(
                                      height: 12,
                                      width: 12,
                                      child: CircularProgressIndicator(
                                        strokeCap: StrokeCap.round,
                                        color: Color(AppColors.primaryColor),
                                        strokeWidth: 2,
                                      ),
                                    ) : const SizedBox.shrink()
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
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
                    const SizedBox(height: 15,),
                    CustomTextField(hintText: "min~${AppStrings.nairaSign}1000, max~${AppStrings.nairaSign}50000", prefixIcon: null, isObscure: false, controller: _priceController,),
                    const SizedBox(height: 10,),
                    CustomTextField(hintText: "Phone Number", prefixIcon: Icon(IconlyBold.call, color: Colors.grey,), isObscure: false, controller: _phoneNumberController,),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomButton(title: "Pay", onClick: () {
                if (selectedType.isNotEmpty &&
                    _meterNumberController.text.trim().isNotEmpty &&
                    _priceController.text.trim().isNotEmpty &&
                    _phoneNumberController.text.trim().isNotEmpty) {
                  _payElectricityBill(
                    context: context,
                    electricCompany: selectedItems.id,
                    meterType: selectedType == "Prepaid" ? "01" : "02",
                    meterNo: _meterNumberController.text.trim(),
                    amount: _priceController.text.trim(),
                    phoneNo: _phoneNumberController.text.trim(),
                  );
                } else {
                  showSnackBar(context: context, message: "PLease be sure to provide all information", title: "Missing Fields");
                }

              }, isLoading: isLoading ? true : false),
            ),
          ),
          if (isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
        ],
      ),
    );
  }
}
