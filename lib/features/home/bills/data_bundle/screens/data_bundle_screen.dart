import 'package:boks/features/home/bills/data_bundle/components/data_bundle_service_provider_bottom_sheet.dart';
import 'package:boks/features/home/bills/data_bundle/components/data_plan_card.dart';
import 'package:boks/features/home/bills/data_bundle/provider/data_model_provider.dart';
import 'package:boks/features/home/bills/data_bundle/provider/data_provider.dart';
import 'package:boks/features/home/bills/data_bundle/service/data_bundle_service.dart';
import 'package:boks/utility/shared_components/custom_back_button.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../../utility/constants/app_icons.dart';
import '../../../../../utility/shared_components/custom_text_field.dart';
import '../../electricity/component/electricity_service_provider_shimmer_loader.dart';

class DataBundleScreen extends StatefulWidget {
  const DataBundleScreen({super.key});

  @override
  State<DataBundleScreen> createState() => _DataBundleScreenState();
}

class _DataBundleScreenState extends State<DataBundleScreen> {
  final _phoneNumberController = TextEditingController();
  final DataBundleService _dataBundleService = DataBundleService();
  late Future<List<Map<String, dynamic>>> _futureDataBundles;


  final Map<String, String> networkPrefixes = {
    "MTN": "0703,0706,0803,0806,0810,0813,0814,0816,0903,0906,0913,0916",
    "GLO": "0705,0805,0807,0811,0815,0905,0915",
    "Airtel": "0701,0708,0802,0808,0812,0901,0902,0904,0907,0912",
    "9Mobile": "0809,0817,0818,0909,0908",
  };

  final List<String> services = ["01", "02", "03", "04"];
  final List<String> titles = ["MTN", "GLO", "9Mobile", "Airtel"];
  final List<String> logos = [
    "logo-mtn-ivory-coast-brand-product-design-mtn-group-teamwork-interpersonal-skills-a97c54a1765e8cf646301d936fa6a3ce.png",
    "622ec535be0300f53a53b2e7b54c1646.jpg",
    "0b2780b8ad9be7d07fcd436802c82da6.jpg",
    "d1fdd6b0530cedafa8a8a8bb0133d9ff.jpg",
  ];

  Future<void> _serviceProviderBottomSheet(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return DataBundleServiceProviderBottomSheet();
      },
    );
  }

  @override
  void initState() {
    _futureDataBundles = _dataBundleService.getAllDataBundles(context);
    _phoneNumberController.addListener(_updateProviderBasedOnPhone);
    super.initState();
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
        final provider = DataModelProvider(
          id: detectedServiceId,
          imageUrl: detectedLogo,
          // name: detectedProvider,
        );
        Provider.of<DataProvider>(
          context,
          listen: false,
        ).selectProvider(provider);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = Provider.of<DataProvider>(context).selectedProvider;
    return DefaultTabController(
      length: 10,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(context: context),
          title: const Text(
            "Data",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
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
              Row(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _serviceProviderBottomSheet(context),
                        child: Container(
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
                      ),
                      const Icon(IconlyBold.arrow_down, color: Colors.grey),
                    ],
                  ),
                  Expanded(
                    child: CustomTextField(
                      hintText: "Phone Number",
                      prefixIcon: null,
                      isObscure: false,
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                      color: Colors.transparent,
                      onChange: (value) {
                        setState(() {

                        });
                      },
                      // fontSize: 20,
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _futureDataBundles,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            for (int i = 0; i < 10; i++)
                              Row(
                                children: [
                                  for (int i = 0; i < 4; i++)
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No data available"));
                      } else {
                        final providers = snapshot.data!;
                        final mtnProvider = providers.firstWhere(
                          (provider) => provider['ID'] == selectedItems.id,
                          orElse: () => {},
                        );
                        if (mtnProvider.isEmpty) {
                          return Center(
                            child: Text(
                              "No ${selectedItems.id} data available",
                            ),
                          );
                        }
                        final products = mtnProvider['PRODUCT'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (
                                  int i = 0;
                                  i < (products.length / 4).ceil();
                                  i++
                                )
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int j = 0; j < 4; j++)
                                        if ((i * 4 + j) < products.length)
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: DataPlanCard(
                                              data: products[i * 4 + j],
                                              serviceProvider: selectedItems.id,
                                              phoneNumber:
                                                  _phoneNumberController.text
                                                      .trim(),
                                            ),
                                          ),
                                    ],
                                  ),
                              ],
                            ),
                            SizedBox(height: 16),
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
      ),
    );
  }
}
