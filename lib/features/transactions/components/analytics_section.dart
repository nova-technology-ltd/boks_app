import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class AnalyticsSection extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> data;
  const AnalyticsSection({super.key, required this.data});

  @override
  State<AnalyticsSection> createState() => _AnalyticsSectionState();
}

class _AnalyticsSectionState extends State<AnalyticsSection> {
  String selectedPeriod = "Daily";
  double totalSpent = 0;
  double totalIncome = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 7,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.grey[100]
          ),
        ),
        Container(
          height: 167,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(
                        child: Icon(Icons.bar_chart_rounded, color: Colors.grey, size: 18,),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      "Analytics",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  height: 39,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedPeriod = "Daily";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: selectedPeriod == "Daily" ? Colors.white: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: selectedPeriod == "Daily" ? [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 1,
                                        spreadRadius: 1
                                    )
                                  ] : null
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                                child: Center(
                                  child: Text(
                                    "Daily",
                                    style: TextStyle(
                                        color: selectedPeriod == "Daily" ? Colors.black : Colors.grey,
                                        fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedPeriod = "Weekly";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: selectedPeriod == "Weekly" ? Colors.white: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: selectedPeriod == "Weekly" ? [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 1,
                                        spreadRadius: 1
                                    )
                                  ] : null
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                                child: Center(
                                  child: Text(
                                    "Weekly",
                                    style: TextStyle(
                                        color: selectedPeriod == "Weekly" ? Colors.black : Colors.grey,
                                        fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedPeriod = "Yearly";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: selectedPeriod == "Yearly" ? Colors.white: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: selectedPeriod == "Yearly" ? [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 1,
                                        spreadRadius: 1
                                    )
                                  ] : null
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                                child: Center(
                                  child: Text(
                                    "Yearly",
                                    style: TextStyle(
                                        color: selectedPeriod == "Yearly" ? Colors.black : Colors.grey,
                                        fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.transparent
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Income",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      shape: BoxShape.circle
                                  ),
                                  child: Icon(Icons.arrow_upward_outlined, color: Colors.green.withOpacity(0.5), size: 17,),
                                ),
                                const SizedBox(width: 5,),
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future: widget.data,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      totalIncome = calculateTotalIncome(snapshot.data!, selectedPeriod);
                                      return RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "₦",
                                                style: TextStyle(color: Colors.black, fontSize: 14)
                                            ),
                                            TextSpan(
                                                text: _formatPrice(totalIncome),
                                                style: TextStyle(color: Colors.black, fontSize: 20)
                                            ),
                                            TextSpan(
                                              text: _getFractionalPart(totalIncome),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey
                                              ),
                                            ),
                                          ])
                                      );
                                    } else if (snapshot.hasError) {
                                      return RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "₦",
                                                style: TextStyle(color: Colors.black, fontSize: 14)
                                            ),
                                            TextSpan(
                                                text: "00.",
                                                style: TextStyle(color: Colors.black, fontSize: 20)
                                            ),
                                            TextSpan(
                                              text: "00",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey
                                              ),
                                            ),
                                          ])
                                      );
                                    }
                                    return CupertinoActivityIndicator();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1.5,
                      decoration: BoxDecoration(
                        color: Colors.grey[200]
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.transparent
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Spending",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      shape: BoxShape.circle
                                  ),
                                  child: Icon(Icons.arrow_downward_rounded, color: Colors.red.withOpacity(0.5), size: 17,),
                                ),
                                const SizedBox(width: 5,),
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future: widget.data,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      totalSpent = calculateTotalSpending(snapshot.data!, selectedPeriod);
                                      return RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "₦",
                                                style: TextStyle(color: Colors.black, fontSize: 14)
                                            ),
                                            TextSpan(
                                                text: _formatPrice(totalSpent),
                                                style: TextStyle(color: Colors.black, fontSize: 20)
                                            ),
                                            TextSpan(
                                              text: _getFractionalPart(totalSpent),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey
                                              ),
                                            ),
                                          ])
                                      );
                                    } else if (snapshot.hasError) {
                                      return RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "₦",
                                                style: TextStyle(color: Colors.black, fontSize: 14)
                                            ),
                                            TextSpan(
                                                text: "00.",
                                                style: TextStyle(color: Colors.black, fontSize: 20)
                                            ),
                                            TextSpan(
                                              text: "00",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey
                                              ),
                                            ),
                                          ])
                                      );
                                    }
                                    return CupertinoActivityIndicator();
                                  },)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          height: 7,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.grey[100]
          ),
        ),
      ],
    );
  }

  double calculateTotalSpending(List<Map<String, dynamic>> transactions, String period) {
    final now = DateTime.now();
    double total = 0;

    for (var transaction in transactions) {
      final createdAt = DateTime.parse(transaction['createdAt']);
      final amount = double.tryParse(transaction['amount']?.toString() ?? '0') ?? 0;

      // Count as spending if it's a debit, withdrawal, or outgoing transfer
      final isSpending = transaction['debit'] == true ||
          transaction['isWithdrawal'] == true ||
          (transaction['isTransfer'] == true && transaction['credit'] == false);

      if (!isSpending) continue;

      bool isInPeriod = false;

      switch (period) {
        case "Daily":
          isInPeriod = createdAt.year == now.year &&
              createdAt.month == now.month &&
              createdAt.day == now.day;
          break;
        case "Weekly":
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          isInPeriod = createdAt.isAfter(startOfWeek) && createdAt.isBefore(now.add(Duration(days: 1)));
          break;
        case "Yearly":
          isInPeriod = createdAt.year == now.year;
          break;
      }

      if (isInPeriod) {
        total += amount;
      }
    }
    return total;
  }

  double calculateTotalIncome(List<Map<String, dynamic>> transactions, String period) {
    final now = DateTime.now();
    double total = 0;

    for (var transaction in transactions) {
      final createdAt = DateTime.parse(transaction['createdAt']);
      final amount = double.tryParse(transaction['amount']?.toString() ?? '0') ?? 0;

      // Count as income if it's a credit, deposit, or incoming transfer
      final isIncome = transaction['credit'] == true ||
          transaction['isDeposit'] == true ||
          (transaction['isTransfer'] == true && transaction['debit'] == false);

      if (!isIncome) continue;

      bool isInPeriod = false;

      switch (period) {
        case "Daily":
          isInPeriod = createdAt.year == now.year &&
              createdAt.month == now.month &&
              createdAt.day == now.day;
          break;
        case "Weekly":
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          isInPeriod = createdAt.isAfter(startOfWeek) && createdAt.isBefore(now.add(Duration(days: 1)));
          break;
        case "Yearly":
          isInPeriod = createdAt.year == now.year;
          break;
      }

      if (isInPeriod) {
        total += amount;
      }
    }
    return total;
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
    NumberFormat formatter = NumberFormat("#,###");
    return formatter.format(number);
  }

  String _getFractionalPart(double number) {
    return (number - number.truncate()).toStringAsFixed(2).substring(1);
  }
}