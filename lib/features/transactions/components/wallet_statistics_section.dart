import 'package:boks/features/transactions/components/wallet_statistics_bar.dart';
import 'package:boks/utility/shimmer_loaders/wallet_statistics_bar_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants/app_colors.dart';
import '../../profile/model/user_provider.dart';

class WalletStatisticsSection extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> data;
  const WalletStatisticsSection({super.key, required this.data});

  @override
  State<WalletStatisticsSection> createState() => _WalletStatisticsSectionState();
}

class _WalletStatisticsSectionState extends State<WalletStatisticsSection> {
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  double inAppSpending = 0;
  double totalSpent = 0;
  double currentDateSpending = 0;
  double selectedDateSpending = 0;
  DateTime? selectedDate;

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        selectedMonth = DateFormat('MMMM').format(pickedDate);
      });
      await _calculateSpendingComparison();
    }
  }

  // Update the _calculateSpendingComparison method
  Future<void> _calculateSpendingComparison() async {
    final transactions = await widget.data;

    // Helper function to safely parse amount
    double parseAmount(dynamic amount) {
      if (amount == null) return 0;
      if (amount is String) return double.tryParse(amount) ?? 0;
      if (amount is int) return amount.toDouble();
      if (amount is double) return amount;
      return 0;
    }

    // Calculate current date spending
    final now = DateTime.now();
    currentDateSpending = transactions
        .where((t) => _isSameDay(DateTime.parse(t['createdAt']), now))
        .fold<double>(0, (sum, t) => sum + parseAmount(t['amount']));

    // Calculate selected date spending
    if (selectedDate != null) {
      selectedDateSpending = transactions
          .where((t) => _isSameDay(DateTime.parse(t['createdAt']), selectedDate!))
          .fold<double>(0, (sum, t) => sum + parseAmount(t['amount']));

      // Also calculate in-app spending for the selected date
      inAppSpending = transactions
          .where((t) => _isSameDay(DateTime.parse(t['createdAt']), selectedDate!))
          .fold<double>(0, (sum, t) => sum + parseAmount(t['amount']));
    } else {
      // If no date selected, use current date values
      inAppSpending = transactions
          .where((t) => _isSameDay(DateTime.parse(t['createdAt']), now))
          .fold<double>(0, (sum, t) => sum + parseAmount(t['amount']));
    }

    setState(() {
      totalSpent = selectedDate != null ? selectedDateSpending : currentDateSpending;
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  double _calculatePercentageDifference() {
    if (currentDateSpending == 0) return 0;
    return ((selectedDateSpending - currentDateSpending) / currentDateSpending) * 100;
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).userModel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: widget.data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (selectedDate == null) {
                  _calculateSpendingComparison();
                }

                final percentageDiff = _calculatePercentageDifference();
                final isIncrease = percentageDiff >= 0;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "₦",
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        TextSpan(
                            text: _formatPrice(totalSpent),
                            style: TextStyle(color: Colors.black, fontSize: 18)),
                        TextSpan(
                            text: _getFractionalPart(totalSpent),
                            style: TextStyle(color: Colors.grey, fontSize:10)),
                      ]),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      isIncrease ? Icons.arrow_circle_up_rounded : Icons.arrow_circle_down_rounded,
                      size: 13,
                      color: isIncrease ? Colors.green : Colors.red,
                    ),
                    Text(
                      "${percentageDiff.abs().toStringAsFixed(1)}%",
                      style: TextStyle(
                        color: isIncrease ? Colors.green : Colors.red,
                        fontSize: 12,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.grey.withOpacity(0.3))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              selectedMonth,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 12, color: Colors.grey,)
                          ],
                        ),
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return SizedBox.shrink();
              }
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(5)
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(5)
                      ),
                    ),
                  ],
                );

            },
          ),
          const SizedBox(height: 10,),

          FutureBuilder<List<Map<String, dynamic>>>(
            future: widget.data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                double inAppSpending = calculateInAppSpending(snapshot.data!);
                double incomingValue = calculateTotalIncoming(snapshot.data!); // Now calculated properly
                double transfersValue = calculateTotalTransfers(snapshot.data!);

                // Calculate normalized values (0-1)
                double normalize(double value, double max) {
                  return max > 0 ? value / max : 0;
                }

                // Get max value for normalization
                double maxValue = [incomingValue, transfersValue, inAppSpending]
                    .reduce((a, b) => a > b ? a : b);

                return Column(
                  children: [
                    Row(
                      children: [
                        WalletStatisticsBar(
                          barColor: Color(AppColors.primaryColor),
                          normalizedValue: normalize(incomingValue, maxValue),
                        ),
                        SizedBox(width: 6),
                        WalletStatisticsBar(
                          barColor: Color(0xFF065986),
                          normalizedValue: normalize(inAppSpending, maxValue),
                        ),
                        SizedBox(width: 6),
                        WalletStatisticsBar(
                          barColor: Color(0xFF027A48),
                          normalizedValue: normalize(transfersValue, maxValue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ItemBreakDown(
                      color: Color(AppColors.primaryColor),
                      title: "Total Incoming",
                      value: _formatNumber(incomingValue),
                      decimalValue: '.00',
                    ),
                    ItemBreakDown(
                      color: Color(0xFF065986),
                      title: "In-App Spending",
                      value: _formatNumber(inAppSpending),
                      decimalValue: '.00',
                    ),
                    ItemBreakDown(
                      color: Color(0xFF027A48),
                      title: "Total Transfers",
                      value: _formatNumber(transfersValue),
                      decimalValue: '.00',
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return SizedBox.shrink();
              }
              return WalletStatisticsBarLoader();
            },
          ),
        ],
      ),
    );
  }

  double calculateTotalSpent(List<Map<String, dynamic>> transactions) {
    double total = 0;
    for (var transaction in transactions) {
      total += (transaction['amount'] as num).toDouble();
    }
    return total;
  }

  double calculateTotalIncoming(List<Map<String, dynamic>> transactions) {
    double total = 0;
    for (var transaction in transactions) {
      if (transaction['isDeposit'] == true || transaction['credit'] == true) {
        total += (transaction['amount'] as num).toDouble();
      }
    }
    return total;
  }

  double calculateInAppSpending(List<Map<String, dynamic>> transactions) {
    double total = 0;
    for (var transaction in transactions) {
      // Skip if it's any of these types
      if (transaction['isTransfer'] == true ||
          transaction['isDeposit'] == true ||
          transaction['isWithdrawal'] == true ||
          transaction['credit'] == true) {
        continue;
      }
      total += (transaction['amount'] as num).toDouble();
    }
    return total;
  }

  String _getFractionalPart(double number) {
    return (number - number.truncate()).toStringAsFixed(2).substring(1);
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

  double calculateTotalTransfers(List<Map<String, dynamic>> transactions) {
    final user = Provider.of<UserProvider>(context, listen: false).userModel;
    final currentUserId = user.boksID;

    double total = 0;
    for (var transaction in transactions) {
      if (transaction['isTransfer'] == true &&
          transaction['sender'] == currentUserId) {
        total += (transaction['amount'] as num).toDouble();
      }
    }
    return total;
  }
}

class ItemBreakDown extends StatelessWidget {
  final Color color;
  final String title;
  final String value;
  final String decimalValue;
  const ItemBreakDown({super.key, required this.color, required this.title, required this.value, required this.decimalValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle
                ),
              ),
              const SizedBox(width: 5,),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  // fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
          RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "₦",
                    style: TextStyle(color:  Colors.black, fontSize: 9)),
                TextSpan(
                    text: value,
                    style: TextStyle(color: Colors.black, fontSize: 12)),
                TextSpan(
                    text: _getFractionalPart(double.parse(decimalValue)),
                    style: TextStyle(color: Colors.grey, fontSize: 8)),
              ]))
        ],
      ),
    );
  }
  String _getFractionalPart(double number) {
    return (number - number.truncate()).toStringAsFixed(2).substring(1);
  }
}