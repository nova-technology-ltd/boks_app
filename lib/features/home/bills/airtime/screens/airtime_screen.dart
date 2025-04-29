import 'package:boks/features/home/bills/airtime/components/airtime_service_provider_bottom_sheet.dart';
import 'package:boks/features/home/bills/airtime/provider/airtime_provider.dart';
import 'package:boks/features/home/bills/airtime/service/airtime_service.dart';
import 'package:boks/features/profile/model/user_model.dart';
import 'package:boks/features/profile/model/user_provider.dart';
import 'package:boks/utility/constants/app_icons.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:boks/utility/shared_components/custom_text_field.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:boks/utility/shared_components/success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../utility/constants/app_strings.dart';
import '../../../../../utility/shared_components/amount_card.dart';
import '../../../../../utility/shared_components/custom_back_button.dart';
import '../../../../../utility/shared_components/enter_pin_bottom_sheet.dart';
import '../provider/airtime_model_provider.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final _phoneNumberController = TextEditingController();
  final _priceController = TextEditingController();
  final AirtimeService _airtimeService = AirtimeService();
  bool isLoading = false;

  Future<void> _buyAirtime({
    required BuildContext context,
    required String serviceProvider,
    required String price,
    required String phoneNumber,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      int response = await _airtimeService.buyAirtimeTwo(
        context: context,
        serviceID: serviceProvider,
        amount: _priceController.text.trim(),
        phone: _phoneNumberController.text.trim(),
      );
      if (response == 200 || response == 201) {
        setState(() {
          isLoading = false;
          selectedService = "";
          _priceController.clear();
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => SuccessScreen(
                  title: "Success!",
                  subMessage: "You have successfully purchased an airtime of",
                  onClick: () {
                    Navigator.pop(context);
                  },
                ),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context: context,
          message:
              "Sorry, but we are unable to complete your request, please try again later. Thank You.",
          title: "Purchase Field",
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context: context,
        message:
            "We encountered an error, while trying to complete your request, please try again later. Thank You.",
        title: "Something Went Wrong",
      );
    }
  }

  Future<void> _buyCheaperAirtime({
    required BuildContext context,
    required String mobileNetwork,
    required String amount,
    required String mobileNumber,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      String response = await _airtimeService.buyAirtime(
        context,
        mobileNetwork,
        amount,
        mobileNumber,
        "",
      );
      if (response == "ORDER_COMPLETED" || response == "ORDER_RECEIVED") {
        setState(() {
          isLoading = false;
          selectedService = "";
          _priceController.clear();
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => SuccessScreen(
                  title: "Success!",
                  subMessage: "You have successfully purchased an airtime of",
                  onClick: () {
                    Navigator.pop(context);
                  },
                ),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context: context,
          message:
              "Sorry, but we are unable to complete your request, please try again later. Thank You.",
          title: "Purchase Field",
        );
      }
      print("Bellow, 100");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context: context,
        message:
            "We encountered an error, while trying to complete your request, please try again later. Thank You.",
        title: "Something Went Wrong",
      );
    }
  }

  String selectedService = "";

  final Map<String, String> networkPrefixes = {
    "MTN": "0703,0706,0803,0806,0810,0813,0814,0816,0903,0906,0913,0916",
    "GLO": "0705,0805,0807,0811,0815,0905,0915",
    "Airtel": "0701,0708,0802,0808,0812,0901,0902,0904,0907,0912",
    "9Mobile": "0809,0817,0818,0909,0908",
  };

  final services = ["mtn", "glo", "etisalat", "airtel"];
  final List<String> titles = ["MTN", "GLO", "9Mobile", "Airtel"];
  final List<String> logos = [
    "logo-mtn-ivory-coast-brand-product-design-mtn-group-teamwork-interpersonal-skills-a97c54a1765e8cf646301d936fa6a3ce.png",
    "622ec535be0300f53a53b2e7b54c1646.jpg",
    "0b2780b8ad9be7d07fcd436802c82da6.jpg",
    "d1fdd6b0530cedafa8a8a8bb0133d9ff.jpg",
  ];

  final List<String> prices = [
    "50",
    "100",
    "200",
    "500",
    "1000",
    "2000",
    "5000",
    "10000",
  ];

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_updateProviderBasedOnPhone);
  }

  void _updateProviderBasedOnPhone() {
    String phone = _phoneNumberController.text.trim();

    if (phone.length >= 4) {
      String prefix = phone.substring(0, 4);

      String detectedProvider = "Unknown";
      String detectedServiceId = "";
      String detectedLogo = "";

      for (var entry in networkPrefixes.entries) {
        if (entry.value.split(',').contains(prefix)) {
          detectedProvider = entry.key;
          int index = titles.indexOf(detectedProvider);
          if (index != -1) {
            detectedServiceId = services[index];
            detectedLogo = logos[index];
          }
          break;
        }
      }

      if (detectedProvider != "Unknown") {
        final provider = AirtimeModelProvider(
          id: detectedServiceId,
          imageUrl: detectedLogo,
          name: detectedProvider,
        );
        Provider.of<AirtimeProvider>(
          context,
          listen: false,
        ).selectProvider(provider);
      }

      setState(() {});
    }
  }

  Future<void> _showPINBottomSheet(
    BuildContext context,
    String provideID,
    UserModel user,
  ) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return PinEntryBottomSheet(
          correctPin: "${user.transactionPIN}",
          onSuccess: () {
            if (int.parse(_priceController.text.trim()) < 100) {
              _buyCheaperAirtime(
                context: context,
                mobileNetwork: provideID,
                amount: _priceController.text.trim(),
                mobileNumber: _phoneNumberController.text.trim(),
              );
            } else {
              _buyAirtime(
                context: context,
                serviceProvider: provideID,
                price: _priceController.text.trim(),
                phoneNumber: _phoneNumberController.text.trim(),
              );
            }
          },
          title: "Verify Transaction",
          errorMessage: "Incorrect PIN. Please try again.",
        );
      },
    );
  }

  Future<void> _serviceProviderBottomSheet(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return AirtimeServiceProviderBottomSheet();
      },
    );
  }

  String selectedPrice = '';

  @override
  Widget build(BuildContext context) {
    final selectedItems =
        Provider.of<AirtimeProvider>(context).selectedProvider;
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
                "Airtime",
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 2,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _serviceProviderBottomSheet(context),
                              child: Row(
                                children: [
                                  Container(
                                    height: 35,
                                    width: 35,
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
                                        selectedItems.imageUrl == "" ? 11.0 : 0,
                                      ),
                                      child: Image.asset(
                                        selectedItems.imageUrl == ""
                                            ? AppIcons.airtimeIcon
                                            : "images/${selectedItems.imageUrl}",
                                        color:
                                            selectedItems.imageUrl == ""
                                                ? Colors.grey
                                                : null,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    IconlyBold.arrow_down,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: CustomTextField(
                                hintText: "Phone Number",
                                prefixIcon: null,
                                isObscure: false,
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.number,
                                color: Colors.transparent,
                                // fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _phoneNumberController.text =
                                        user.phoneNumber;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      "use my phone number",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          hintText:
                              "min~${AppStrings.nairaSign}100, max~${AppStrings.nairaSign}50,000",
                          prefixIcon: null,
                          isObscure: false,
                          keyboardType: TextInputType.number,
                          controller: _priceController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomButton(
                title: "Pay",
                onClick: () {
                  if (int.parse(_priceController.text.trim()) == 0 || _priceController.text.trim().isEmpty || _phoneNumberController.text.trim().isEmpty) {
                    showSnackBar(
                      context: context,
                      message:
                          "Please provide all required fields",
                      title: "Missing Fields",
                    );
                  } else {
                    _showPINBottomSheet(context, selectedItems.id, user);
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
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
        ],
      ),
    );
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
}
