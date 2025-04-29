import 'package:boks/utility/shimmer_loaders/transaction_history_shimma_loader.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../../../utility/shared_components/custom_back_button.dart';
import 'transfer_money_screen.dart';

class AllRecentTransferScreen extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> futureRecentTransfers;
  const AllRecentTransferScreen({super.key, required this.futureRecentTransfers});

  @override
  State<AllRecentTransferScreen> createState() => _AllRecentTransferScreenState();
}

class _AllRecentTransferScreenState extends State<AllRecentTransferScreen> {
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
          "Recent Transfers",
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: widget.futureRecentTransfers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const TransactionHistoryShimmaLoader(size: 33);
                  } else if (snapshot.hasError) {
                    return const SizedBox.shrink();
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final transactions = snapshot.data!.reversed.toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            for (int i = 0; i < transactions.length && i < 7; i++)
                              GestureDetector(
                                onTap:  (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => TransferMoneyScreen(user: transactions[i]['user']),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.0)
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 45,
                                        width: 45,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                        child: transactions[i]['user']['image'].isEmpty || transactions[i]['user']['image'] == null ? Center(
                                          child: Icon(IconlyBold.profile, color: Colors.grey, size: 18,),
                                        ) : Image.network(transactions[i]['user']['image'], fit: BoxFit.cover, errorBuilder: (context, err, st) {
                                          return Center(
                                            child: Icon(IconlyBold.profile, size: 18, color: Colors.grey,),
                                          );
                                        },),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${transactions[i]['user']['firstName']} ${transactions[i]['user']['lastName']} ${transactions[i]['user']['otherNames']}".length > 21
                                                  ? "${"${transactions[i]['user']['firstName']} ${transactions[i]['user']['lastName']} ${transactions[i]['user']['otherNames']}".substring(0, 21)}.."
                                                  : "${transactions[i]['user']['firstName']} ${transactions[i]['user']['lastName']} ${transactions[i]['user']['otherNames']}",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              formatNumberWithAsterisks(int.parse(transactions[i]['user']['phoneNumber'])),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(width: 10),
                                      Text(
                                        transactions[i]['transactionDate'] != null
                                            ? DateFormat('MMM d, yyyy').format(
                                          DateTime.parse(transactions[i]['transactionDate']), // Convert String → DateTime
                                        )
                                            : 'No date',
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatNumberWithAsterisks(int number) {
    String numStr = number.toString();
    if (numStr.length < 2) {
      return numStr;
    }
    String lastTwoDigits = numStr.substring(numStr.length - 2);
    String asterisks = '*' * (numStr.length - 2);
    List<String> asteriskGroups = [];
    for (int i = 0; i < asterisks.length; i += 3) {
      int end = (i + 3) < asterisks.length ? (i + 3) : asterisks.length;
      asteriskGroups.add(asterisks.substring(i, end));
    }
    return asteriskGroups.join(' ') + ' ' + lastTwoDigits;
  }
}
