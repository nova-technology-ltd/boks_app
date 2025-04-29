import 'package:boks/features/transactions/screens/all_recent_transfer_screen.dart';
import 'package:boks/features/transactions/components/recent_transfer_data_card_style.dart';
import 'package:boks/features/transactions/components/recent_transfer_user_preview_bottom_sheet.dart';
import 'package:boks/features/transactions/service/transaction_services.dart';
import 'package:boks/utility/shimmer_loaders/rencent_transfer_shimma_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utility/shimmer_loaders/transaction_history_shimma_loader.dart';
import '../screens/transfer_money_screen.dart';
import '../screens/transfer_screen_one.dart';

class RecentTransferSection extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> futureRecentTransfers;
  const RecentTransferSection({super.key, required this.futureRecentTransfers});

  @override
  State<RecentTransferSection> createState() => _RecentTransferSectionState();
}

class _RecentTransferSectionState extends State<RecentTransferSection> {
  Future<void> _showRecentTransferPreview(BuildContext context, Map<String,dynamic> data) async {
    showCupertinoModalPopup(context: context, builder: (context) {
      return RecentTransferUserPreviewBottomSheet(data: data,);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<Map<String, dynamic>>>(
          future: widget.futureRecentTransfers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const RencentTransferShimmaLoader();
            } else if (snapshot.hasError) {
              return const SizedBox.shrink();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            } else {
              final transactions = snapshot.data!.reversed.toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Transfers",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllRecentTransferScreen(futureRecentTransfers: widget.futureRecentTransfers,)));
                          },
                          child: Text(
                            "See All",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 4),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransferScreenOne(futureRecentTransfers: widget.futureRecentTransfers,)));
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    shape: BoxShape.circle
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add, size: 20, color: Colors.grey,),
                                  ),
                                ),
                              ),
                              Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                                ),
                              )
                            ],
                          ),
                        ),
                        for (int i = 0; i < transactions.length && i < 7; i++)
                          Padding(
                            padding: EdgeInsets.only(
                                left: i == 0 ? 10 : 4.0,
                                right: i == transactions.length - 1 ? 10 : 4
                            ),
                            child: RecentTransferDataCardStyle(transactions: transactions[i]),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        )
      ],
    );
  }
}
