// import 'package:boks/features/transactions/components/ai_predication_dialog.dart';
// import 'package:boks/utility/constants/app_strings.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:iconly/iconly.dart';
//
// import '../../../chart_screen.dart';
//
// class LinChartSection extends StatefulWidget {
//   final Future<List<Map<String, dynamic>>> data;
//
//   const LinChartSection({super.key, required this.data});
//
//   @override
//   State<LinChartSection> createState() => _LinChartSectionState();
// }
//
// class _LinChartSectionState extends State<LinChartSection> {
//   bool isDaily = true;
//   bool showAnimation = true;
//   bool _showPrediction = false;
//   List<FinancialData> weeklyData = [];
//   List<FinancialData> monthlyData = [];
//   List<FinancialData> _combinedData = [];
//   double totalSpent = 0;
//   double totalIncome = 0;
//
//   Color _getColorForAmount(double amount) {
//     if (amount == 0) return Colors.grey;
//     if (amount < 50) return Colors.green;
//     if (amount < 150) return Colors.blue;
//     if (amount < 300) return Colors.orange;
//     return Colors.red;
//   }
//
//   String _getCategoryForDay(int weekday) {
//     return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][weekday % 7];
//   }
//
//   void _generatePredictionData() {
//     final sourceData = isDaily ? weeklyData : monthlyData;
//     if (sourceData.isEmpty) return;
//
//     setState(() {
//       _combinedData = List.from(sourceData);
//
//       // Generate AI prediction data (based on last 3 points)
//       final lastDate = sourceData.last.date;
//       final lastAmount = sourceData.last.amount;
//       final secondLastAmount = sourceData.length > 1
//           ? sourceData[sourceData.length - 2].amount
//           : lastAmount;
//       final thirdLastAmount = sourceData.length > 2
//           ? sourceData[sourceData.length - 3].amount
//           : secondLastAmount;
//
//       // Simple prediction algorithm
//       final average = (lastAmount + secondLastAmount + thirdLastAmount) / 3;
//       final trend = (lastAmount - thirdLastAmount) / 3;
//
//       if (isDaily) {
//         // Predict next 3 days
//         for (int i = 1; i <= 3; i++) {
//           final predictedAmount =
//           (average + (trend * i)).clamp(0, average * 2).toDouble();
//           _combinedData.add(
//             FinancialData(
//               lastDate.add(Duration(days: i)),
//               predictedAmount,
//               category: 'Prediction',
//               description: 'AI projected spending',
//               categoryColor: Colors.grey,
//             ),
//           );
//         }
//       } else {
//         // Predict next month
//         final nextMonth = DateTime(lastDate.year, lastDate.month + 1, 1);
//         _combinedData.add(
//           FinancialData(
//             nextMonth,
//             (average + trend).clamp(0, average * 1.5).toDouble(),
//             category: 'Prediction',
//             description: 'AI projected spending',
//             categoryColor: Colors.grey,
//           ),
//         );
//       }
//     });
//   }
//
//   Future<void> _processTransactionData(List<Map<String, dynamic>> transactions) async {
//     final now = DateTime.now();
//     final weeklySpending = <DateTime, double>{};
//     final weeklyIncome = <DateTime, double>{};
//     final monthlySpending = <DateTime, double>{};
//     final monthlyIncome = <DateTime, double>{};
//
//     // Process transactions
//     for (var transaction in transactions) {
//       final createdAt = DateTime.parse(transaction['createdAt']);
//       final amount = double.tryParse(transaction['amount']?.toString() ?? '0') ?? 0;
//
//       // Determine if it's income (credit) or spending (debit)
//       final isSpending = transaction['debit'] == true ||
//           transaction['isWithdrawal'] == true ||
//           (transaction['isTransfer'] == true && transaction['credit'] == false);
//       final isIncome = !isSpending;
//
//       // Weekly data (last 7 days)
//       if (createdAt.isAfter(now.subtract(const Duration(days: 7)))) {
//         final dayKey = DateTime(createdAt.year, createdAt.month, createdAt.day);
//         if (isSpending) {
//           weeklySpending[dayKey] = (weeklySpending[dayKey] ?? 0) + amount;
//         } else {
//           weeklyIncome[dayKey] = (weeklyIncome[dayKey] ?? 0) + amount;
//         }
//       }
//
//       // Monthly data (last 6 months)
//       if (createdAt.isAfter(now.subtract(const Duration(days: 180)))) {
//         final monthKey = DateTime(createdAt.year, createdAt.month, 1);
//         if (isSpending) {
//           monthlySpending[monthKey] = (monthlySpending[monthKey] ?? 0) + amount;
//         } else {
//           monthlyIncome[monthKey] = (monthlyIncome[monthKey] ?? 0) + amount;
//         }
//       }
//     }
//
//     // Generate weekly data points (ensure we have 7 days)
//     final weeklyPoints = <FinancialData>[];
//     final weeklyIncomePoints = <FinancialData>[];
//     for (int i = 6; i >= 0; i--) {
//       final date = now.subtract(Duration(days: i));
//       final dayKey = DateTime(date.year, date.month, date.day);
//       final spendingAmount = weeklySpending[dayKey] ?? 0.0;
//       final incomeAmount = weeklyIncome[dayKey] ?? 0.0;
//
//       weeklyPoints.add(
//         FinancialData(
//           dayKey,
//           spendingAmount,
//           category: _getCategoryForDay(date.weekday),
//           description: 'Daily spending',
//           categoryColor: _getColorForAmount(spendingAmount),
//           isIncome: false,
//         ),
//       );
//
//       weeklyIncomePoints.add(
//         FinancialData(
//           dayKey,
//           incomeAmount,
//           category: _getCategoryForDay(date.weekday),
//           description: 'Daily income',
//           categoryColor: Colors.green, // Different color for income
//           isIncome: true,
//         ),
//       );
//     }
//
//     // Generate monthly data points (last 6 months)
//     final monthlyPoints = <FinancialData>[];
//     final monthlyIncomePoints = <FinancialData>[];
//     for (int i = 5; i >= 0; i--) {
//       final date = DateTime(now.year, now.month - i, 1);
//       final monthKey = DateTime(date.year, date.month, 1);
//       final spendingAmount = monthlySpending[monthKey] ?? 0.0;
//       final incomeAmount = monthlyIncome[monthKey] ?? 0.0;
//
//       monthlyPoints.add(
//         FinancialData(
//           monthKey,
//           spendingAmount,
//           category: DateFormat('MMM').format(date),
//           description: 'Monthly spending',
//           categoryColor: _getColorForAmount(spendingAmount),
//           isIncome: false,
//         ),
//       );
//
//       monthlyIncomePoints.add(
//         FinancialData(
//           monthKey,
//           incomeAmount,
//           category: DateFormat('MMM').format(date),
//           description: 'Monthly income',
//           categoryColor: Colors.green,
//           isIncome: true,
//         ),
//       );
//     }
//
//     setState(() {
//       weeklyData = weeklyPoints;
//       monthlyData = monthlyPoints;
//       // You might want to store income data separately or combine them
//       // For this example, I'm just showing the spending data
//       _generatePredictionData();
//
//       // Calculate totals
//       totalSpent = weeklyPoints.map((e) => e.amount).reduce((a, b) => a + b);
//       totalIncome = weeklyIncomePoints.map((e) => e.amount).reduce((a, b) => a + b);
//     });
//   }
//
//   void _showAIInsights(BuildContext context) {
//     final data = isDaily ? weeklyData : monthlyData;
//     if (data.isEmpty) return;
//
//     // Calculate insights
//     final total = data.map((e) => e.amount).reduce((a, b) => a + b);
//     final average = total / data.length;
//     final maxSpending = data
//         .map((e) => e.amount)
//         .reduce((a, b) => a > b ? a : b);
//     final maxDay = data.firstWhere((e) => e.amount == maxSpending);
//     final minSpending = data
//         .map((e) => e.amount)
//         .reduce((a, b) => a < b ? a : b);
//
//     // Find most common spending day (for weekly)
//     String commonDay = '';
//     if (isDaily) {
//       final dayCounts = <String, int>{};
//       for (var point in data) {
//         final day = DateFormat('EEEE').format(point.date);
//         dayCounts[day] = (dayCounts[day] ?? 0) + 1;
//       }
//       commonDay =
//           dayCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
//     }
//
//     showCupertinoModalPopup(
//       context: context,
//       builder: (context) {
//         return AiPredictionDialog(
//           totalSum: "${AppStrings.nairaSign}${total.toStringAsFixed(2)}",
//           isDaily: isDaily,
//           average: "${AppStrings.nairaSign}${average.toStringAsFixed(2)} per ${isDaily ? 'day' : 'month'}",
//           highestSpending:
//           "${AppStrings.nairaSign}${maxSpending.toStringAsFixed(2)} on ${DateFormat('MMM d').format(maxDay.date)}",
//           lowestSpending:
//           "${AppStrings.nairaSign}${minSpending.toStringAsFixed(2)}",
//           mostSpentDay: commonDay,
//         );
//       },
//     );
//   }
//
//   Widget _buildInstruction(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           const Icon(Icons.touch_app, size: 16, color: Colors.grey),
//           const SizedBox(width: 8),
//           Text(
//             text,
//             style: TextStyle(
//               color: Colors.grey[700],
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showTransactionDetails(BuildContext context, FinancialData data) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(DateFormat('MMMM d, y').format(data.date)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Amount: \$${data.amount.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Category: ${data.category}',
//               style: TextStyle(
//                 color: data.categoryColor ?? Colors.grey,
//                 fontSize: 16,
//               ),
//             ),
//             if (data.description.isNotEmpty) ...[
//               const SizedBox(height: 10),
//               Text(
//                 'Details: ${data.description}',
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ],
//             if (data.category == 'Prediction') ...[
//               const SizedBox(height: 15),
//               const Text(
//                 'AI Prediction:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 5),
//               const Text(
//                 'Based on your spending patterns, '
//                     'this is the projected amount for this period.',
//               ),
//             ],
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: widget.data,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CupertinoActivityIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No transaction data available'));
//         }
//
//         // Process data when it's available
//         if (weeklyData.isEmpty && monthlyData.isEmpty) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _processTransactionData(snapshot.data!);
//           });
//         }
//
//         return Column(
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     isDaily ? Icons.calendar_view_month : Icons.calendar_view_day,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       isDaily = !isDaily;
//                       _generatePredictionData();
//                     });
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.insights),
//                   onPressed: () {
//                     _showAIInsights(context);
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.refresh),
//                   onPressed: () {
//                     setState(() {
//                       weeklyData = [];
//                       monthlyData = [];
//                       _combinedData = [];
//                     });
//                   },
//                 ),
//               ],
//             ),
//             // SizedBox(
//             //   height: 350,
//             //   child: Padding(
//             //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             //     child: LineChartWidget(
//             //       spendingData: isDaily ? weeklyData : monthlyData,
//             //       incomeData: isDaily,
//             //       isDaily: isDaily,
//             //       spendingLineColor: Colors.red, // Color for spending
//             //       incomeLineColor: Colors.green, // Color for income
//             //       // fillColor: Colors.deepPurple,
//             //       indicatorColor: Colors.amber,
//             //       onPointSelected: (point) {
//             //         _showTransactionDetails(context, point);
//             //       },
//             //     ),
//             //   ),
//             // ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   const Text(
//                     'Interactive Features:',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   _buildInstruction('Swipe horizontally to inspect values'),
//                   _buildInstruction('Tap a point for transaction details'),
//                   _buildInstruction('Double tap to toggle AI predictions'),
//                   _buildInstruction('Tap the insights icon for AI analysis'),
//                   _buildInstruction('Tap refresh to update the chart'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         );
//       },
//     );
//   }
// }