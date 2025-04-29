import 'package:boks/features/transactions/components/transaction_history_card_style.dart';
import 'package:boks/features/transactions/screens/transaction_history_screen.dart';
import 'package:boks/utility/shimmer_loaders/transaction_history_shimma_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utility/constants/app_colors.dart';

class TransactionHistorySection extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> data;
  const TransactionHistorySection({super.key, required this.data});

  @override
  State<TransactionHistorySection> createState() => _TransactionHistorySectionState();
}

class _TransactionHistorySectionState extends State<TransactionHistorySection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Transactions",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()));
              },
              child: Text(
                "See all",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(AppColors.primaryColor)
                ),
              ),
            ),
          ],
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: widget.data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const TransactionHistoryShimmaLoader(size: 7,);
            } else if (snapshot.hasError) {
              return const Center(child: Text('No transactions found'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No transactions found'));
            } else {
              final transactions = snapshot.data!.reversed.toList();

              return SingleChildScrollView(
                child: Column(
                  children: transactions.take(7).map((transaction) {
                    return TransactionHistoryCardStyle(transaction: transaction);
                  }).toList(),
                ),
              );
            }
          },
        )
      ],
    );
  }
}
