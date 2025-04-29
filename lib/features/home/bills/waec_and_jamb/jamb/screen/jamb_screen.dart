import 'package:boks/features/home/bills/waec_and_jamb/jamb/service/jamb_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../../../../../../utility/constants/app_strings.dart';
import '../../../../../../utility/shared_components/custom_back_button.dart';
import '../../../../../../utility/shared_components/custom_button.dart';
import '../../../../../../utility/shared_components/custom_text_field.dart';
import '../../../airtime/components/airtime_service_provider_bottom_sheet.dart';
import '../component/Jamb_service_bottom_sheet.dart';

class JambScreen extends StatefulWidget {
  const JambScreen({super.key});

  @override
  State<JambScreen> createState() => _JambScreenState();
}

class _JambScreenState extends State<JambScreen> {
  final _phoneNumberController = TextEditingController();
  final _priceController = TextEditingController();
  final _profileCodeController = TextEditingController();
  final JambService _jambService = JambService();
  String? _selectedItem;
  final TextEditingController _controller = TextEditingController();
  late Future<List<Map<String, dynamic>>> _futureJambServices;

  @override
  void initState() {
    _futureJambServices = _jambService.getAllJambService(context);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDropdown() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return JambServiceBottomSheet(
          data: _futureJambServices,
          onItemSelected: (selectedService) {
            setState(() {
              _controller.text = selectedService;
            });
          },
          price: (selectedServicePrice) {
            setState(() {
              _priceController.text = selectedServicePrice;
            });
          },
          productCode: (selectedServiceCode) {
            setState(() {
              _controller.text = selectedServiceCode;
            });
          },
          controller: _controller,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(context: context),
        centerTitle: true,
        title: const Text(
          "JAMB",
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
            CustomTextField(
              hintText: "Select JAMB Service",
              prefixIcon: null,
              isObscure: false,
              controller: _controller,
              onTap: _showDropdown,
              readOnly: true,
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                // color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppStrings.nairaSign}${_formatPrice(double.tryParse(_priceController.text) ?? 0)}",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        Icon(IconlyBold.lock, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: "Phone Number",
              prefixIcon: Icon(IconlyBold.call, color: Colors.grey),
              keyboardType: TextInputType.number,
              isObscure: false,
              controller: _phoneNumberController,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: "Profile Code",
              prefixIcon: Icon(IconlyBold.profile, color: Colors.grey),
              isObscure: false,
              controller: _profileCodeController,
              readOnly: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: CustomButton(title: "Pay", onClick: () {}, isLoading: false),
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
    NumberFormat formatter = NumberFormat("#,###.##");
    return formatter.format(number);
  }
}
