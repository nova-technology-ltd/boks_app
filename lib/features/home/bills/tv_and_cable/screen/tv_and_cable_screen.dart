import 'package:boks/features/home/bills/tv_and_cable/component/tv_and_cable_service_provider_bottom_sheet.dart';
import 'package:boks/features/home/bills/tv_and_cable/provider/selected_tv_and_cable_service_provider.dart';
import 'package:boks/features/home/bills/tv_and_cable/service/tv_and_cable_service.dart';
import 'package:boks/utility/shared_components/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../../utility/constants/app_colors.dart';
import '../../../../../utility/shared_components/custom_back_button.dart';
import '../../data_bundle/components/data_plan_card.dart';
import '../component/tv_cable_plan_card_style.dart';

class TvAndCableScreen extends StatefulWidget {
  const TvAndCableScreen({super.key});

  @override
  State<TvAndCableScreen> createState() => _TvAndCableScreenState();
}

class _TvAndCableScreenState extends State<TvAndCableScreen> {
  final TvAndCableService _tvAndCableService = TvAndCableService();
  final _smartCardNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _futureServiceProviders;
  late Map<String, dynamic> _futureCardDetails;
  String statusMessage = "";
  String customerName = "";
  String verificationStatus = "";
  bool isVerifying = false;
  bool isSmartCardSaved = false;
  bool isVerified = false;

  @override
  void initState() {
    _futureServiceProviders = _tvAndCableService.getAllTvCable(context);
    super.initState();
  }

  Future<void> _verifySmartCardNumber({
    required BuildContext context,
    required String cableTV,
    required String smartCardNo,
  }) async {
    // Don't verify empty strings or very short numbers
    if (smartCardNo.isEmpty || smartCardNo.length < 3) {
      setState(() {
        isVerifying = false;
        statusMessage = "";
        customerName = "";
        verificationStatus = "";
      });
      return;
    }

    try {
      setState(() {
        isVerifying = true;
        statusMessage = "verifying...";
        customerName = "";
        verificationStatus = "";
      });

      final response = await _tvAndCableService.verifyCableTV(
        context: context,
        cableTV: cableTV,
        smartCardNo: smartCardNo,
      );

      setState(() {
        isVerifying = false;
        if (response != null) {
          customerName = response["customer_name"] ?? "";
          verificationStatus = response["status"] == "00" ? "Verified" : "Invalid smart card";
          isVerified = response["status"] == "00";
        } else {
          statusMessage = "Verification failed";
          isVerified = false;
        }
      });
    } catch (e) {
      setState(() {
        isVerifying = false;
        statusMessage = "verification failed";
        customerName = "";
        verificationStatus = "";
      });
      print("Verification error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification failed: ${e.toString()}")),
      );
    }
  }

  Future<void> _showElectricityServices(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return TvAndCableServiceProviderBottomSheet(
          futureService: _futureServiceProviders,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems =
        Provider.of<SelectedTvAndCableServiceProvider>(
          context,
        ).selectedProvider;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(context: context),
        centerTitle: true,
        title: const Text(
          "TV",
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
                                  ? "images/bolt.png"
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
                      onPressed: () => _showElectricityServices(context),
                      icon: Icon(
                        Icons.arrow_downward_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
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
                          "Smart Card Number",
                          style: TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.w500
                          ),
                        ),
                        CustomTextField(
                          hintText: "Smart Card Number",
                          prefixIcon: null,
                          isObscure: false,
                          keyboardType: TextInputType.number,
                          controller: _smartCardNumberController,
                          onChange: (value) {
                            setState(() {
                              _verifySmartCardNumber(
                                context: context,
                                cableTV: selectedItems.id,
                                smartCardNo: value,
                              );
                            });
                          },
                        ),
                        const SizedBox(height: 5),
                        if (isVerifying)
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text("Verifying...", style: TextStyle(color: Colors.blue)),
                          ),
                        if (customerName.isNotEmpty)
                          Row(
                            children: [
                              Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                  color: verificationStatus == "Verified" ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                  shape: BoxShape.circle
                                ),
                                child: Container(
                                  child: Icon(verificationStatus == "Verified" ? Icons.check : Icons.close, color: verificationStatus == "Verified" ? Colors.green : Colors.red, size: 14,),
                                ),
                              ),
                              const SizedBox(width: 5,),
                              Text("$customerName", style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500
                              ),),
                            ],
                          ),
                        if (statusMessage.isNotEmpty && !isVerifying && customerName.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(statusMessage, style: TextStyle(color: Colors.red)),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Save Card",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Transform.scale(
                          scale: 0.6,
                          child: CupertinoSwitch(
                            activeColor: Color(AppColors.primaryColor),
                            value: isSmartCardSaved,
                            onChanged: (value) {
                              setState(() {
                                isSmartCardSaved = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: "Phone Number",
              prefixIcon: Icon(IconlyBold.call, color: Colors.grey),
              isObscure: false,
              controller: _phoneNumberController,
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _futureServiceProviders,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CupertinoActivityIndicator();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No data available"),
                      );
                    } else {
                      final providers = snapshot.data!;

                      // Filter the providers to only include the one with ID matching selectedItems.id
                      final mtnProvider = providers.firstWhere(
                            (provider) => provider['ID'] == selectedItems.id,
                        orElse: () => {},
                      );

                      // If no provider is found, show a message
                      if (mtnProvider.isEmpty) {
                        return Center(
                          child: Text("No ${selectedItems.id} data available"),
                        );
                      }
                      final products = mtnProvider['PRODUCT'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < (products.length / 2).ceil(); i++)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (int j = 0; j < 2; j++)
                                      if ((i * 2 + j) < products.length)
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: TvCablePlanCardStyle(data: products[i * 2 + j], smartCardNumber: verificationStatus == "Verified" ? _smartCardNumberController.text.trim() : "", phoneNumber: _phoneNumberController.text.trim(),),
                                        ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
