import 'package:boks/features/home/bills/betting/components/betting_service_provider_card_style.dart';
import 'package:boks/features/home/bills/electricity/component/electricity_service_provider_card_style.dart';
import 'package:flutter/material.dart';

import '../../electricity/component/electricity_service_provider_shimmer_loader.dart';

class BettingServiceListBottomSheet extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> futureService;

  const BettingServiceListBottomSheet({super.key, required this.futureService});

  @override
  State<BettingServiceListBottomSheet> createState() => _BettingServiceListBottomSheetState();
}

class _BettingServiceListBottomSheetState extends State<BettingServiceListBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 500,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("", style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.transparent
                        ),),
                        Text("Service Providers", style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500
                        ),),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Text("Close", style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.red
                          ),),
                        ),
                      ]),
                )),
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: widget.futureService,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ElectricityServiceProviderShimmerLoader();
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No data available"));
                    } else {
                      final providers = snapshot.data!;
                      return Column(
                        children: [
                          for (var provider in providers)
                            BettingServiceProviderCardStyle(data: provider)
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
