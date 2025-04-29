import 'package:boks/features/home/components/balance_card.dart';
import 'package:boks/features/transactions/components/analytics_section.dart';
import 'package:boks/features/transactions/components/recent_transfer_section.dart';
import 'package:boks/features/transactions/service/transaction_services.dart';
import 'package:boks/utility/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../chart_screen.dart';
import '../components/lin_chart_section.dart';
import '../components/transaction_history_section.dart';
import '../components/wallet_statistics_section.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final TransactionService _transactionService = TransactionService();
  late Future<List<Map<String,dynamic>>> _futureTransactions;
  late Future<List<Map<String, dynamic>>> _futureRecentTransfers;
  Future<void> _refreshScreen(BuildContext context) async {
    try {
      setState(() {
        _futureTransactions = _transactionService.getAllUserTransactions(context);
        _futureRecentTransfers = _transactionService.getAllUserRecentTransfers(context);
      });
    } catch (e) {

    }
  }

  @override
  void initState() {
    _futureTransactions = _transactionService.getAllUserTransactions(context);
    _futureRecentTransfers = _transactionService.getAllUserRecentTransfers(context);
    super.initState();
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
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "Statistics",
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
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: const BalanceCard(),
                ),
                const SizedBox(
                  height: 15,
                ),
                AnalyticsSection(data: _futureTransactions,),
                const SizedBox(
                  height: 10,
                ),
                RecentTransferSection(futureRecentTransfers: _futureRecentTransfers,),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 7,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[100]
                  ),
                ),
                const SizedBox(height: 10,),
                WalletStatisticsSection(data: _futureTransactions,),
                const SizedBox(height: 10,),
                Container(
                  height: 7,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[100]
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TransactionHistorySection(data: _futureTransactions,),
                ),
                // LinChartSection(data: _futureTransactions,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
