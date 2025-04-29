import 'package:boks/utility/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../utility/shared_components/custom_back_button.dart';
import '../../../utility/shimmer_loaders/transaction_history_shimma_loader.dart';
import '../components/transaction_history_card_style.dart';
import '../service/transaction_services.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key,});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _futureTransactions;
  bool isRefreshing = false;
  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    _futureTransactions = _transactionService.getAllUserTransactions(context);
    super.initState();
  }


  Future<void> _refreshScreen(BuildContext context) async {
    try {
      setState(() {
        isRefreshing = true;
        _futureTransactions = _transactionService.getAllUserTransactions(context);
      });
      setState(() {
        isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshScreen(context),
      backgroundColor: Colors.white,
      color: Color(AppColors.primaryColor),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(context: context),
          centerTitle: true,
          title: const Text(
            "Transactions",
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
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureTransactions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const TransactionHistoryShimmaLoader(size: 30);
            } else if (snapshot.hasError) {
              return _buildErrorState();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            } else {
              return _buildTransactionList(snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "No Transactions Yet!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "You haven't made any transactions yet. Your transaction history will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Failed to Load Transactions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We couldn't load your transaction history. Please try again.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<Map<String, dynamic>> transactions) {
    transactions.sort((a, b) {
      try {
        final dateA = DateTime.parse(a['createdAt'] ?? DateTime.now().toString());
        final dateB = DateTime.parse(b['createdAt'] ?? DateTime.now().toString());
        return dateB.compareTo(dateA);
      } catch (e) {
        print('Error parsing transaction date: $e');
        return 0;
      }
    });

    // Then group them by date
    final groupedTransactions = <String, List<Map<String, dynamic>>>{};
    for (var transaction in transactions) {
      try {
        final date = DateFormat('MMM d, yyyy').format(
            DateTime.parse(transaction['createdAt'] ?? DateTime.now().toString()));
        groupedTransactions.putIfAbsent(date, () => []).add(transaction);
      } catch (e) {
        print('Error parsing transaction date: $e');
      }
    }

    // Get the dates and sort them in descending order
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => DateFormat('MMM d, yyyy')
          .parse(b)
          .compareTo(DateFormat('MMM d, yyyy').parse(a)));

    return ListView(
      children: [Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var date in sortedDates) ...[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 1.0, top: 10),
                child: Text(
                  date,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              for (var transaction in groupedTransactions[date]!)
                TransactionHistoryCardStyle(transaction: transaction),
            ],
          ],
        ),
      )],
    );
  }
}