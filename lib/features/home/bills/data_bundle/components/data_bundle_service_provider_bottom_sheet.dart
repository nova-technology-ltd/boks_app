import 'package:boks/features/home/bills/airtime/provider/airtime_model_provider.dart';
import 'package:boks/features/home/bills/airtime/provider/airtime_provider.dart';
import 'package:boks/features/home/bills/data_bundle/provider/data_model_provider.dart';
import 'package:boks/features/home/bills/data_bundle/provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_bundle_network_card.dart';

class DataBundleServiceProviderBottomSheet extends StatefulWidget {
  const DataBundleServiceProviderBottomSheet({super.key});

  @override
  State<DataBundleServiceProviderBottomSheet> createState() => _DataBundleServiceProviderBottomSheetState();
}

class _DataBundleServiceProviderBottomSheetState extends State<DataBundleServiceProviderBottomSheet> {
  String selectedService = "";
  final services = [
    "01",
    "02",
    "03",
    "04",
  ];

  final title = [
    "MTN",
    "GLO",
    "9Mobile",
    "Airtel",
  ];

  final logos = [
    "logo-mtn-ivory-coast-brand-product-design-mtn-group-teamwork-interpersonal-skills-a97c54a1765e8cf646301d936fa6a3ce.png",
    "622ec535be0300f53a53b2e7b54c1646.jpg",
    "0b2780b8ad9be7d07fcd436802c82da6.jpg",
    "d1fdd6b0530cedafa8a8a8bb0133d9ff.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
          child: Container(
            height: 220,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < 4; i++)
                          DataBundleNetworkCard(
                            image: logos[i],
                            id: services[i],
                            onClick: () {
                              final imageUrl = logos[i];
                              final provider = DataModelProvider(
                                id: services[i] ?? '',
                                imageUrl: imageUrl,
                              );
                              Provider.of<DataProvider>(context, listen: false).selectProvider(provider);
                              Navigator.pop(context);
                              setState(() {
                                selectedService = services[i];
                              });
                            },
                            selectedService: selectedService, title: title[i],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
