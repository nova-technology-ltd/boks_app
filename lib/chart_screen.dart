// import 'package:boks/utility/constants/app_strings.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart' show DateFormat;
//
// class FinancialData {
//   final DateTime date;
//   final double amount;
//   final String category;
//   final String description;
//   final Color categoryColor;
//   final bool isIncome;
//
//   FinancialData(
//       this.date,
//       this.amount, {
//         this.category = '',
//         this.description = '',
//         this.categoryColor = Colors.grey,
//         this.isIncome = false,
//       });
// }
//
// class LineChartWidget extends StatefulWidget {
//   final List<FinancialData> spendingData;
//   final List<FinancialData> incomeData;
//   final bool isDaily;
//   final Color spendingLineColor;
//   final Color incomeLineColor;
//   final Color spendingFillColor;
//   final Color incomeFillColor;
//   final Color indicatorColor;
//   final Function(FinancialData)? onPointSelected;
//
//   const LineChartWidget({
//     super.key,
//     required this.spendingData,
//     required this.incomeData,
//     required this.isDaily,
//     this.spendingLineColor = Colors.red,
//     this.incomeLineColor = Colors.green,
//     this.spendingFillColor = Colors.pink,
//     this.incomeFillColor = Colors.lightGreen,
//     this.indicatorColor = Colors.amber,
//     this.onPointSelected,
//   });
//
//   @override
//   _LineChartWidgetState createState() => _LineChartWidgetState();
// }
//
// class _LineChartWidgetState extends State<LineChartWidget>
//     with SingleTickerProviderStateMixin {
//   FinancialData? _selectedPoint;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   Offset? _dragPosition;
//   bool _isAnimating = false;
//   bool _showPrediction = false;
//   List<FinancialData> _combinedSpendingData = [];
//   List<FinancialData> _combinedIncomeData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutQuart,
//     );
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startAnimation();
//       _generatePredictionData();
//     });
//   }
//
//   void _generatePredictionData() {
//     if (widget.spendingData.isEmpty || widget.incomeData.isEmpty) return;
//
//     final lastSpendingDate = widget.spendingData.last.date;
//     final lastSpendingAmount = widget.spendingData.last.amount;
//     final lastIncomeDate = widget.incomeData.last.date;
//     final lastIncomeAmount = widget.incomeData.last.amount;
//
//     setState(() {
//       _combinedSpendingData = List.from(widget.spendingData);
//       _combinedIncomeData = List.from(widget.incomeData);
//
//       // Generate AI prediction data for spending
//       if (widget.isDaily) {
//         for (int i = 1; i <= 3; i++) {
//           _combinedSpendingData.add(FinancialData(
//             lastSpendingDate.add(Duration(days: i)),
//             lastSpendingAmount * (0.9 + 0.2 * (i / 3)), // Simulated prediction
//             category: 'Prediction',
//             description: 'AI projected spending',
//             categoryColor: Colors.grey,
//             isIncome: false,
//           ));
//         }
//
//         // Generate AI prediction data for income
//         for (int i = 1; i <= 3; i++) {
//           _combinedIncomeData.add(FinancialData(
//             lastIncomeDate.add(Duration(days: i)),
//             lastIncomeAmount * (0.8 + 0.3 * (i / 3)), // Simulated prediction
//             category: 'Prediction',
//             description: 'AI projected income',
//             categoryColor: Colors.grey,
//             isIncome: true,
//           ));
//         }
//       }
//     });
//   }
//
//   void _startAnimation() {
//     setState(() => _isAnimating = true);
//     _animationController.forward(from: 0);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onHorizontalDragStart: _handleDragStart,
//       onHorizontalDragUpdate: _handleDragUpdate,
//       onHorizontalDragEnd: _handleDragEnd,
//       onTapUp: (details) => _handleTap(details, context),
//       onDoubleTap: _togglePrediction,
//       child: AnimatedBuilder(
//         animation: _animation,
//         builder: (context, child) {
//           return CustomPaint(
//             size: Size(MediaQuery.of(context).size.width, 350),
//             painter: _LineChartPainter(
//               spendingData: _showPrediction ? _combinedSpendingData : widget.spendingData,
//               incomeData: _showPrediction ? _combinedIncomeData : widget.incomeData,
//               isDaily: widget.isDaily,
//               selectedPoint: _selectedPoint,
//               dragPosition: _dragPosition,
//               animationValue: _animation.value,
//               spendingLineColor: widget.spendingLineColor,
//               incomeLineColor: widget.incomeLineColor,
//               spendingFillColor: widget.spendingFillColor,
//               incomeFillColor: widget.incomeFillColor,
//               indicatorColor: widget.indicatorColor,
//               showPrediction: _showPrediction,
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _togglePrediction() {
//     setState(() {
//       _showPrediction = !_showPrediction;
//       if (_showPrediction) {
//         _generatePredictionData();
//       }
//     });
//   }
//
//   void _handleDragStart(DragStartDetails details) {
//     _updateSelectedPoint(details.globalPosition);
//   }
//
//   void _handleDragUpdate(DragUpdateDetails details) {
//     _updateSelectedPoint(details.globalPosition);
//   }
//
//   void _handleDragEnd(DragEndDetails details) {
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) {
//         setState(() => _dragPosition = null);
//       }
//     });
//   }
//
//   void _handleTap(TapUpDetails details, BuildContext context) {
//     _updateSelectedPoint(details.globalPosition);
//
//     if (_selectedPoint != null) {
//       if (widget.onPointSelected != null) {
//         widget.onPointSelected!(_selectedPoint!);
//       } else {
//         _showTransactionDetails(context, _selectedPoint!);
//       }
//     }
//
//     Future.delayed(const Duration(milliseconds: 2000), () {
//       if (mounted && _selectedPoint != null) {
//         setState(() => _selectedPoint = null);
//       }
//     });
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
//             Text('Amount: ${AppStrings.nairaSign}${data.amount.toStringAsFixed(2)}',
//                 style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 10),
//             Text('Type: ${data.isIncome ? 'Income' : 'Spending'}',
//                 style: TextStyle(
//                     color: data.isIncome ? Colors.green : Colors.red,
//                     fontSize: 16)),
//             Text('Category: ${data.category}',
//                 style: TextStyle(
//                     color: data.categoryColor ?? Colors.grey, fontSize: 16)),
//             if (data.description.isNotEmpty) ...[
//               const SizedBox(height: 10),
//               Text('Details: ${data.description}',
//                   style: const TextStyle(fontSize: 14)),
//             ],
//             if (data.category == 'Prediction') ...[
//               const SizedBox(height: 15),
//               const Text('AI Prediction:',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 5),
//               Text(
//                 data.isIncome
//                     ? 'Based on your income patterns, this is the projected amount.'
//                     : 'Based on your spending patterns, this is the projected amount.',
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
//   void _updateSelectedPoint(Offset globalPosition) {
//     final renderBox = context.findRenderObject() as RenderBox;
//     final localOffset = renderBox.globalToLocal(globalPosition);
//
//     setState(() {
//       _dragPosition = localOffset;
//       _selectedPoint = _findClosestDataPoint(
//           localOffset, renderBox.size);
//     });
//   }
//
//   FinancialData? _findClosestDataPoint(Offset localOffset, Size size) {
//     final allData = [
//       ...(_showPrediction ? _combinedSpendingData : widget.spendingData),
//       ...(_showPrediction ? _combinedIncomeData : widget.incomeData),
//     ];
//
//     if (allData.isEmpty) return null;
//
//     final points = _calculatePoints(size, allData);
//     final tappedX = localOffset.dx;
//
//     FinancialData? closestPoint;
//     double minDistance = double.infinity;
//
//     for (int i = 0; i < points.length; i++) {
//       final distance = (points[i].dx - tappedX).abs();
//       if (distance < minDistance) {
//         minDistance = distance;
//         closestPoint = allData[i];
//       }
//     }
//
//     return closestPoint;
//   }
//
//   List<Offset> _calculatePoints(Size size, List<FinancialData> data) {
//     final padding = 40.0;
//     final width = size.width - padding * 2;
//     final height = size.height - padding * 2;
//
//     if (data.isEmpty) return [];
//
//     final maxAmount = data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
//
//     return data.asMap().entries.map((entry) {
//       final x = padding + (width / (data.length - 1)) * entry.key;
//       final y = size.height - padding - (entry.value.amount / maxAmount) * height;
//       return Offset(x, y);
//     }).toList();
//   }
// }
//
// class _LineChartPainter extends CustomPainter {
//   final List<FinancialData> spendingData;
//   final List<FinancialData> incomeData;
//   final bool isDaily;
//   final FinancialData? selectedPoint;
//   final Offset? dragPosition;
//   final double animationValue;
//   final Color spendingLineColor;
//   final Color incomeLineColor;
//   final Color spendingFillColor;
//   final Color incomeFillColor;
//   final Color indicatorColor;
//   final bool showPrediction;
//
//   _LineChartPainter({
//     required this.spendingData,
//     required this.incomeData,
//     required this.isDaily,
//     this.selectedPoint,
//     this.dragPosition,
//     required this.animationValue,
//     required this.spendingLineColor,
//     required this.incomeLineColor,
//     required this.spendingFillColor,
//     required this.incomeFillColor,
//     required this.indicatorColor,
//     this.showPrediction = false,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     _drawGrid(canvas, size);
//     _drawFilledAreas(canvas, size);
//     _drawLinesAndPoints(canvas, size);
//     if (selectedPoint != null || dragPosition != null) {
//       _drawInteractiveElements(canvas, size);
//     }
//     _drawChartFrame(canvas, size);
//     _drawLegend(canvas, size);
//   }
//
//   void _drawLegend(Canvas canvas, Size size) {
//     const legendPadding = 8.0;
//     const legendItemHeight = 20.0;
//     const legendItemWidth = 100.0;
//
//     final legendPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;
//
//     final legendRect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(
//         size.width - legendItemWidth - 20,
//         20,
//         legendItemWidth,
//         legendItemHeight * 2 + legendPadding * 3,
//       ),
//       const Radius.circular(8),
//     );
//
//     canvas.drawRRect(legendRect, legendPaint);
//
//     final borderPaint = Paint()
//       ..color = Colors.grey.withOpacity(0.3)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;
//
//     canvas.drawRRect(legendRect, borderPaint);
//
//     // Draw spending legend
//     final spendingText = TextSpan(
//       text: 'Spending',
//       style: TextStyle(
//         color: spendingLineColor,
//         fontSize: 12,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//
//     final spendingTextPainter = TextPainter(
//       text: spendingText,
//       textDirection: TextDirection.ltr,
//     )..layout();
//
//     spendingTextPainter.paint(
//       canvas,
//       Offset(
//         size.width - legendItemWidth - 10 + 15,
//         20 + legendPadding,
//       ),
//     );
//
//     // Draw spending line sample
//     canvas.drawLine(
//       Offset(size.width - legendItemWidth - 10, 20 + legendPadding + 8),
//       Offset(size.width - legendItemWidth - 10 + 10, 20 + legendPadding + 8),
//       Paint()
//         ..color = spendingLineColor
//         ..strokeWidth = 2
//         ..style = PaintingStyle.stroke,
//     );
//
//     // Draw income legend
//     final incomeText = TextSpan(
//       text: 'Income',
//       style: TextStyle(
//         color: incomeLineColor,
//         fontSize: 12,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//
//     final incomeTextPainter = TextPainter(
//       text: incomeText,
//       textDirection: TextDirection.ltr,
//     )..layout();
//
//     incomeTextPainter.paint(
//       canvas,
//       Offset(
//         size.width - legendItemWidth - 10 + 15,
//         20 + legendPadding + legendItemHeight,
//       ),
//     );
//
//     // Draw income line sample
//     canvas.drawLine(
//       Offset(size.width - legendItemWidth - 10, 20 + legendPadding + legendItemHeight + 8),
//       Offset(size.width - legendItemWidth - 10 + 10, 20 + legendPadding + legendItemHeight + 8),
//       Paint()
//         ..color = incomeLineColor
//         ..strokeWidth = 2
//         ..style = PaintingStyle.stroke,
//     );
//   }
//
//   void _drawChartFrame(Canvas canvas, Size size) {
//     final framePaint = Paint()
//       ..color = Colors.grey.withOpacity(0.3)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;
//
//     canvas.drawRect(
//       Rect.fromLTRB(40, 40, size.width - 40, size.height - 40),
//       framePaint,
//     );
//   }
//
//   void _drawGrid(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.grey.withOpacity(0.15)
//       ..strokeWidth = 1;
//
//     // Determine which data to use for grid lines (whichever has more points)
//     final dataForGrid = spendingData.length > incomeData.length ? spendingData : incomeData;
//
//     // Vertical lines
//     for (var i = 0; i < dataForGrid.length; i++) {
//       final x = 40.0 + (size.width - 80) * i / (dataForGrid.length - 1);
//       canvas.drawLine(Offset(x, 40), Offset(x, size.height - 40), paint);
//     }
//
//     // Horizontal lines
//     const horizontalLines = 5;
//     for (var i = 0; i <= horizontalLines; i++) {
//       final y = 40.0 + (size.height - 80) * i / horizontalLines;
//       canvas.drawLine(Offset(40, y), Offset(size.width - 40, y), paint);
//     }
//
//     _drawLabels(canvas, size);
//   }
//
//   void _drawLabels(Canvas canvas, Size size) {
//     final textStyle = TextStyle(
//       color: Colors.grey[700],
//       fontSize: 10,
//       fontWeight: FontWeight.w500,
//     );
//
//     // Use spending data for labels if available, otherwise use income data
//     final dataForLabels = spendingData.isNotEmpty ? spendingData : incomeData;
//     if (dataForLabels.isEmpty) return;
//
//     // X-axis labels
//     for (var i = 0; i < dataForLabels.length; i++) {
//       if (i % (dataForLabels.length > 10 ? 2 : 1) != 0) continue;
//
//       final date = dataForLabels[i].date;
//       String label;
//
//       if (showPrediction && dataForLabels[i].category == 'Prediction') {
//         label = 'Day +${i - (dataForLabels.length - 4)}';
//       } else if (isDaily) {
//         label = _getDayAbbreviation(date.weekday);
//       } else {
//         label = '${date.day}/${date.month}';
//       }
//
//       final textSpan = TextSpan(text: label, style: textStyle);
//       final textPainter = TextPainter(
//         text: textSpan,
//         textDirection: TextDirection.ltr,
//       )..layout();
//
//       final x = 40.0 + (size.width - 80) * i / (dataForLabels.length - 1);
//       final offset = Offset(x - textPainter.width/2, size.height - 25);
//       textPainter.paint(canvas, offset);
//     }
//
//     // Y-axis labels
//     final maxSpending = spendingData.isNotEmpty
//         ? spendingData.map((e) => e.amount).reduce((a, b) => a > b ? a : b)
//         : 0;
//     final maxIncome = incomeData.isNotEmpty
//         ? incomeData.map((e) => e.amount).reduce((a, b) => a > b ? a : b)
//         : 0;
//     final maxAmount = maxSpending > maxIncome ? maxSpending : maxIncome;
//
//     const horizontalLines = 5;
//     for (var i = 0; i <= horizontalLines; i++) {
//       final value = maxAmount * (horizontalLines - i) / horizontalLines;
//       final textSpan = TextSpan(
//         text: '${AppStrings.nairaSign}${value.toStringAsFixed(0)}',
//         style: textStyle,
//       );
//       final textPainter = TextPainter(
//         text: textSpan,
//         textDirection: TextDirection.ltr,
//       )..layout();
//
//       final y = 40.0 + (size.height - 80) * i / horizontalLines;
//       final offset = Offset(10, y - textPainter.height/2);
//       textPainter.paint(canvas, offset);
//     }
//
//     // Draw prediction indicator if showing predictions
//     if (showPrediction && (spendingData.length > 7 || incomeData.length > 7)) {
//       final predictionText = 'AI Prediction';
//       final textSpan = TextSpan(
//         text: predictionText,
//         style: TextStyle(
//           color: Colors.grey[600],
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       );
//       final textPainter = TextPainter(
//         text: textSpan,
//         textDirection: TextDirection.ltr,
//       )..layout();
//
//       final offset = Offset(size.width - textPainter.width - 15, 20);
//       textPainter.paint(canvas, offset);
//
//       // Draw dashed line for prediction separator
//       final dashPaint = Paint()
//         ..color = Colors.grey.withOpacity(0.5)
//         ..strokeWidth = 1.5
//         ..style = PaintingStyle.stroke;
//
//       final dataLength = spendingData.isNotEmpty ? spendingData.length : incomeData.length;
//       final predictionStartX = 40.0 + (size.width - 80) * (dataLength - 4) / (dataLength - 1);
//       canvas.drawLine(
//         Offset(predictionStartX, 40),
//         Offset(predictionStartX, size.height - 40),
//         dashPaint,
//       );
//     }
//   }
//
//   String _getDayAbbreviation(int weekday) {
//     return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1];
//   }
//
//   void _drawFilledAreas(Canvas canvas, Size size) {
//     // Draw spending filled area
//     if (spendingData.isNotEmpty) {
//       _drawFilledArea(
//         canvas,
//         size,
//         spendingData,
//         spendingFillColor.withOpacity(0.3),
//         spendingFillColor.withOpacity(0.05),
//       );
//     }
//
//     // Draw income filled area
//     if (incomeData.isNotEmpty) {
//       _drawFilledArea(
//         canvas,
//         size,
//         incomeData,
//         incomeFillColor.withOpacity(0.2),
//         incomeFillColor.withOpacity(0.05),
//       );
//     }
//
//     // Draw prediction areas if showing predictions
//     if (showPrediction) {
//       if (spendingData.length > 7) {
//         _drawPredictionArea(
//           canvas,
//           size,
//           spendingData,
//           Colors.grey.withOpacity(0.1),
//           Colors.grey.withOpacity(0.05),
//         );
//       }
//       if (incomeData.length > 7) {
//         _drawPredictionArea(
//           canvas,
//           size,
//           incomeData,
//           Colors.grey.withOpacity(0.1),
//           Colors.grey.withOpacity(0.05),
//         );
//       }
//     }
//   }
//
//   void _drawFilledArea(
//       Canvas canvas,
//       Size size,
//       List<FinancialData> data,
//       Color topColor,
//       Color bottomColor,
//       ) {
//     final points = _calculatePoints(size, data);
//     final maxX = size.width - 40;
//     final bottomY = size.height - 40;
//
//     final fillPaint = Paint()
//       ..shader = LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [topColor, bottomColor],
//       ).createShader(Rect.fromLTRB(40, 40, maxX, bottomY))
//       ..style = PaintingStyle.fill;
//
//     final fillPath = Path()
//       ..moveTo(points[0].dx, points[0].dy);
//
//     for (int i = 1; i < points.length; i++) {
//       final animatedX = 40 + (points[i].dx - 40) * animationValue;
//       final animatedY = points[i].dy + (bottomY - points[i].dy) * (1 - animationValue);
//       fillPath.lineTo(animatedX, animatedY);
//     }
//
//     fillPath.lineTo(points.last.dx, bottomY);
//     fillPath.lineTo(points[0].dx, bottomY);
//     fillPath.close();
//
//     canvas.drawPath(fillPath, fillPaint);
//   }
//
//   void _drawPredictionArea(
//       Canvas canvas,
//       Size size,
//       List<FinancialData> data,
//       Color topColor,
//       Color bottomColor,
//       ) {
//     final points = _calculatePoints(size, data);
//     final maxX = size.width - 40;
//     final bottomY = size.height - 40;
//
//     final predictionFillPaint = Paint()
//       ..shader = LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [topColor, bottomColor],
//       ).createShader(Rect.fromLTRB(
//         40.0 + (size.width - 80) * (data.length - 4) / (data.length - 1),
//         40,
//         maxX,
//         bottomY,
//       ))
//       ..style = PaintingStyle.fill;
//
//     final predictionFillPath = Path();
//     final startIndex = data.length - 4;
//
//     predictionFillPath.moveTo(
//       40 + (size.width - 80) * startIndex / (data.length - 1),
//       points[startIndex].dy,
//     );
//
//     for (int i = startIndex + 1; i < points.length; i++) {
//       predictionFillPath.lineTo(points[i].dx, points[i].dy);
//     }
//
//     predictionFillPath.lineTo(points.last.dx, bottomY);
//     predictionFillPath.lineTo(
//       40 + (size.width - 80) * startIndex / (data.length - 1),
//       bottomY,
//     );
//     predictionFillPath.close();
//
//     canvas.drawPath(predictionFillPath, predictionFillPaint);
//   }
//
//   void _drawLinesAndPoints(Canvas canvas, Size size) {
//     // Draw spending line and points
//     if (spendingData.isNotEmpty) {
//       _drawLineAndPoints(
//         canvas,
//         size,
//         spendingData,
//         spendingLineColor,
//         showPrediction,
//       );
//     }
//
//     // Draw income line and points
//     if (incomeData.isNotEmpty) {
//       _drawLineAndPoints(
//         canvas,
//         size,
//         incomeData,
//         incomeLineColor,
//         showPrediction,
//       );
//     }
//   }
//
//   void _drawLineAndPoints(
//       Canvas canvas,
//       Size size,
//       List<FinancialData> data,
//       Color lineColor,
//       bool showPredictions,
//       ) {
//     final points = _calculatePoints(size, data);
//     final maxX = size.width - 40;
//     final bottomY = size.height - 40;
//
//     // Main line paint
//     final linePaint = Paint()
//       ..color = lineColor
//       ..strokeWidth = 2.5
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;
//
//     // Prediction line paint (dashed)
//     final predictionLinePaint = Paint()
//       ..color = Colors.grey
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;
//
//     final path = Path();
//     path.moveTo(points[0].dx, points[0].dy + (bottomY - points[0].dy) * (1 - animationValue));
//
//     for (int i = 1; i < points.length; i++) {
//       final animatedX = 40 + (points[i].dx - 40) * animationValue;
//       final animatedY = points[i].dy + (bottomY - points[i].dy) * (1 - animationValue);
//
//       if (showPredictions && i >= data.length - 4) {
//         // Draw dashed line for predictions
//         final dashPath = Path();
//         dashPath.moveTo(
//           i == data.length - 4 ? points[i-1].dx : points[i-1].dx,
//           i == data.length - 4 ? points[i-1].dy : points[i-1].dy,
//         );
//         dashPath.lineTo(animatedX, animatedY);
//
//         final dashMetrics = dashPath.computeMetrics().first;
//         final dashLength = 5.0;
//         final gapLength = 3.0;
//
//         for (double d = 0; d < dashMetrics.length; d += dashLength + gapLength) {
//           final end = d + dashLength;
//           final segment = dashMetrics.extractPath(d, end > dashMetrics.length ? dashMetrics.length : end);
//           canvas.drawPath(segment, predictionLinePaint);
//         }
//       } else {
//         path.lineTo(animatedX, animatedY);
//       }
//     }
//
//     canvas.drawPath(path, linePaint);
//
//     // Draw animated points
//     final pointPaint = Paint()
//       ..color = lineColor
//       ..style = PaintingStyle.fill;
//
//     final shadowPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;
//
//     for (int i = 0; i < points.length; i++) {
//       final animatedX = 40 + (points[i].dx - 40) * animationValue;
//       final animatedY = points[i].dy + (bottomY - points[i].dy) * (1 - animationValue);
//
//       // Skip drawing prediction points if not showing prediction
//       if (showPredictions == false && data[i].category == 'Prediction') continue;
//
//       // Draw white shadow first
//       canvas.drawCircle(Offset(animatedX, animatedY), 7, shadowPaint);
//
//       // Then draw the colored point
//       if (data[i].category == 'Prediction') {
//         canvas.drawCircle(
//           Offset(animatedX, animatedY),
//           5,
//           Paint()..color = Colors.grey,
//         );
//       } else {
//         canvas.drawCircle(Offset(animatedX, animatedY), 5, pointPaint);
//       }
//     }
//   }
//
//   void _drawInteractiveElements(Canvas canvas, Size size) {
//     final activePoint = selectedPoint ?? _findClosestDataPoint(dragPosition!, size);
//     if (activePoint == null) return;
//
//     final dataList = activePoint.isIncome ? incomeData : spendingData;
//     final index = dataList.indexOf(activePoint);
//     final points = _calculatePoints(size, dataList);
//     final x = points[index].dx;
//     final y = points[index].dy;
//
//     // Draw vertical indicator line
//     final linePaint = Paint()
//       ..color = indicatorColor.withOpacity(0.3)
//       ..strokeWidth = 1.5
//       ..style = PaintingStyle.stroke;
//
//     canvas.drawLine(
//       Offset(x, 40),
//       Offset(x, size.height - 40),
//       linePaint,
//     );
//
//     // Draw tooltip background
//     final textSpan = TextSpan(
//       text: '${AppStrings.nairaSign}${activePoint.amount.toStringAsFixed(2)}',
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 12,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//
//     final textPainter = TextPainter(
//       text: textSpan,
//       textDirection: TextDirection.ltr,
//     )..layout();
//
//     const tooltipPadding = 8.0;
//     const tooltipRadius = 8.0;
//     final rectWidth = textPainter.width + tooltipPadding * 2;
//     final rectHeight = textPainter.height + tooltipPadding * 2;
//
//     // Determine tooltip position (above or below point based on position)
//     final isTop = y < size.height / 2;
//     final tooltipY = isTop ? y + 30 : y - 30 - rectHeight;
//
//     final rect = Rect.fromLTWH(
//       x - rectWidth / 2,
//       tooltipY,
//       rectWidth,
//       rectHeight,
//     );
//
//     final paint = Paint()
//       ..color = activePoint.isIncome ? incomeLineColor : spendingLineColor
//       ..style = PaintingStyle.fill;
//
//     // Draw tooltip triangle
//     final path = Path();
//     if (isTop) {
//       path.moveTo(x - 6, y + 30);
//       path.lineTo(x + 6, y + 30);
//       path.lineTo(x, y + 24);
//     } else {
//       path.moveTo(x - 6, y - 30);
//       path.lineTo(x + 6, y - 30);
//       path.lineTo(x, y - 24);
//     }
//     path.close();
//
//     canvas.drawPath(path, paint);
//
//     // Draw rounded rectangle with shadow
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(rect, const Radius.circular(tooltipRadius)),
//       paint,
//     );
//
//     // Draw text
//     textPainter.paint(
//       canvas,
//       Offset(
//         x - textPainter.width / 2,
//         isTop ? y + 30 + tooltipPadding : y - 30 - textPainter.height - tooltipPadding,
//       ),
//     );
//
//     // Draw highlighted point
//     final pointPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;
//
//     final pointBorderPaint = Paint()
//       ..color = indicatorColor
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;
//
//     canvas.drawCircle(Offset(x, y), 9, pointPaint);
//     canvas.drawCircle(Offset(x, y), 9, pointBorderPaint);
//
//     // Draw date label above the chart
//     final dateText = DateFormat('MMM d, y').format(activePoint.date);
//     final dateTextSpan = TextSpan(
//       text: dateText,
//       style: TextStyle(
//         color: Colors.grey[800],
//         fontSize: 12,
//         fontWeight: FontWeight.w600,
//       ),
//     );
//     final dateTextPainter = TextPainter(
//       text: dateTextSpan,
//       textDirection: TextDirection.ltr,
//     )..layout();
//
//     final dateOffset = Offset(
//       x - dateTextPainter.width / 2,
//       20,
//     );
//     dateTextPainter.paint(canvas, dateOffset);
//   }
//
//   FinancialData? _findClosestDataPoint(Offset localOffset, Size size) {
//     // Combine both datasets for finding the closest point
//     final allData = [...spendingData, ...incomeData];
//     if (allData.isEmpty) return null;
//
//     // Group points by x position (date)
//     final pointsMap = <double, List<FinancialData>>{};
//     for (final data in allData) {
//       final x = _calculateXPosition(size, data, allData);
//       pointsMap.putIfAbsent(x, () => []).add(data);
//     }
//
//     final tappedX = localOffset.dx;
//
//     double? closestX;
//     double minDistance = double.infinity;
//
//     // Find the closest x position
//     for (final x in pointsMap.keys) {
//       final distance = (x - tappedX).abs();
//       if (distance < minDistance) {
//         minDistance = distance;
//         closestX = x;
//       }
//     }
//
//     if (closestX == null) return null;
//
//     // From the closest x position, find the point closest to the tap y position
//     final candidates = pointsMap[closestX]!;
//     FinancialData? closestPoint;
//     double minYDistance = double.infinity;
//
//     for (final point in candidates) {
//       final y = _calculateYPosition(size, point, allData);
//       final yDistance = (y - localOffset.dy).abs();
//       if (yDistance < minYDistance) {
//         minYDistance = yDistance;
//         closestPoint = point;
//       }
//     }
//
//     return closestPoint;
//   }
//
//   double _calculateXPosition(Size size, FinancialData data, List<FinancialData> allData) {
//     final padding = 40.0;
//     final width = size.width - padding * 2;
//
//     // Find the index of this data point in its respective list
//     final dataList = data.isIncome ? incomeData : spendingData;
//     final index = dataList.indexOf(data);
//
//     return padding + (width / (dataList.length - 1)) * index;
//   }
//
//   double _calculateYPosition(Size size, FinancialData data, List<FinancialData> allData) {
//     final padding = 40.0;
//     final height = size.height - padding * 2;
//
//     // Calculate max amount from both datasets
//     final maxSpending = spendingData.isNotEmpty
//         ? spendingData.map((e) => e.amount).reduce((a, b) => a > b ? a : b)
//         : 0;
//     final maxIncome = incomeData.isNotEmpty
//         ? incomeData.map((e) => e.amount).reduce((a, b) => a > b ? a : b)
//         : 0;
//     final maxAmount = maxSpending > maxIncome ? maxSpending : maxIncome;
//
//     return size.height - padding - (data.amount / maxAmount) * height;
//   }
//
//   List<Offset> _calculatePoints(Size size, List<FinancialData> data) {
//     final padding = 40.0;
//     final width = size.width - padding * 2;
//     final height = size.height - padding * 2;
//
//     if (data.isEmpty) return [];
//
//     final maxAmount = data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
//
//     return data.asMap().entries.map((entry) {
//       final x = padding + (width / (data.length - 1)) * entry.key;
//       final y = size.height - padding - (entry.value.amount / maxAmount) * height;
//       return Offset(x, y);
//     }).toList();
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }


import 'dart:math';

import 'package:flutter/material.dart';

class WeeklyExpensesChart extends StatefulWidget {
  const WeeklyExpensesChart({super.key});

  @override
  State<WeeklyExpensesChart> createState() => _WeeklyExpensesChartState();
}

class _WeeklyExpensesChartState extends State<WeeklyExpensesChart> {
  late List<double> dailyExpenses = [45.0, 80.0, 120.0, 65.0, 95.0, 150.0, 60.0];
  final List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Colors for each bar (you can customize these)
  final List<Color> barColors = [
    Colors.blue.shade400,
    Colors.green.shade400,
    Colors.orange.shade400,
    Colors.red.shade400,
    Colors.purple.shade400,
    Colors.teal.shade400,
    Colors.indigo.shade400,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Expenses'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Chart title and summary
            _buildChartHeader(),
            const SizedBox(height: 20),
            // The actual chart
            Expanded(
              child: CustomPaint(
                painter: BarChartPainter(
                  dailyExpenses: dailyExpenses,
                  daysOfWeek: daysOfWeek,
                  barColors: barColors,
                  maxBarHeight: MediaQuery.of(context).size.height * 0.4,
                ),
              ),
            ),
            // Legend and controls
            _buildChartFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartHeader() {
    final totalExpenses = dailyExpenses.reduce((a, b) => a + b);
    final averageExpense = totalExpenses / dailyExpenses.length;

    return Column(
      children: [
        Text(
          'Weekly Spending Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              TextSpan(
                text: 'Total: \$${totalExpenses.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' | '),
              TextSpan(
                text: 'Avg/Day: \$${averageExpense.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartFooter() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // You could add interactive elements here
        // For example, a button to randomize data for demonstration
        ElevatedButton(
          onPressed: () {
            setState(() {
              dailyExpenses = List.generate(7, (index) => (Random().nextDouble() * 200).roundToDouble());
            });
          },
          child: const Text('Randomize Data'),
        ),
      ],
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> dailyExpenses;
  final List<String> daysOfWeek;
  final List<Color> barColors;
  final double maxBarHeight;
  final double barWidth;
  final double barSpacing;

  BarChartPainter({
    required this.dailyExpenses,
    required this.daysOfWeek,
    required this.barColors,
    required this.maxBarHeight,
    this.barWidth = 40.0,
    this.barSpacing = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxExpense = dailyExpenses.reduce((a, b) => a > b ? a : b);
    final scaleFactor = maxBarHeight / maxExpense;

    final Paint barPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final Paint gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Paint barHighlightPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw horizontal grid lines and labels
    const gridLineCount = 5;
    for (var i = 0; i <= gridLineCount; i++) {
      final yPos = size.height - (i * (maxBarHeight / gridLineCount));
      final value = (i * maxExpense / gridLineCount);

      // Grid line
      canvas.drawLine(
        Offset(0, yPos),
        Offset(size.width, yPos),
        gridPaint,
      );

      // Grid label
      textPainter.text = TextSpan(
        text: '\$${value.toStringAsFixed(0)}',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(0, yPos - textPainter.height - 2),
      );
    }

    // Calculate total width needed for all bars and spacing
    final totalBarsWidth = (dailyExpenses.length * barWidth) +
        ((dailyExpenses.length - 1) * barSpacing);
    final startX = (size.width - totalBarsWidth) / 2;

    // Draw each bar
    for (var i = 0; i < dailyExpenses.length; i++) {
      final expense = dailyExpenses[i];
      final barHeight = expense * scaleFactor;
      final xPos = startX + i * (barWidth + barSpacing);

      // Bar shadow/background
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            xPos,
            size.height - barHeight,
            barWidth,
            barHeight,
          ),
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        barHighlightPaint,
      );

      // Main bar with gradient
      final barRect = Rect.fromLTWH(
        xPos,
        size.height - barHeight,
        barWidth,
        barHeight,
      );

      final gradient = LinearGradient(
        colors: [
          barColors[i].withOpacity(0.8),
          barColors[i],
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

      barPaint.shader = gradient.createShader(barRect);

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          barRect,
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        barPaint,
      );

      // Bar top highlight
      final highlightHeight = 10.0;
      final topHighlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            xPos,
            size.height - barHeight,
            barWidth,
            min(highlightHeight, barHeight),
          ),
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        topHighlightPaint,
      );

      // Day label below bar
      textPainter.text = TextSpan(
        text: daysOfWeek[i],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          xPos + (barWidth - textPainter.width) / 2,
          size.height + 5,
        ),
      );

      // Expense value above bar
      textPainter.text = TextSpan(
        text: '\$${expense.toStringAsFixed(0)}',
        style: TextStyle(
          color: barColors[i],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          xPos + (barWidth - textPainter.width) / 2,
          size.height - barHeight - textPainter.height - 5,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}