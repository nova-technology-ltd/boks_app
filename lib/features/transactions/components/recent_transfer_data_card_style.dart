import 'package:boks/features/transactions/components/recent_transfer_user_preview_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../screens/transfer_money_screen.dart';

class RecentTransferDataCardStyle extends StatefulWidget {
  final Map<String, dynamic> transactions;
  final double? size;
  const RecentTransferDataCardStyle({super.key, required this.transactions, this.size});

  @override
  State<RecentTransferDataCardStyle> createState() => _RecentTransferDataCardStyleState();
}

class _RecentTransferDataCardStyleState extends State<RecentTransferDataCardStyle> {
  Future<void> _showRecentTransferPreview(BuildContext context, Map<String,dynamic> data) async {
    showCupertinoModalPopup(context: context, builder: (context) {
      return RecentTransferUserPreviewBottomSheet(data: data,);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TransferMoneyScreen(user: widget.transactions['user']),
          ),
        );
      },
      onLongPress: () => _showRecentTransferPreview(context, widget.transactions),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: widget.size ?? 50,
            width: widget.size ?? 50,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: widget.transactions['user']['image'].isEmpty || widget.transactions['user']['image']  == null ? Center(
              child: Icon(IconlyBold.profile, color: Colors.grey, size: 18,),
            ) : Image.network(widget.transactions['user']['image'], fit: BoxFit.cover, errorBuilder: (context, err, st) {
              return Center(
                child: Icon(IconlyBold.profile, color: Colors.grey, size: 18,),
              );
            },),
          ),
          Text(
            widget.transactions['user']['firstName'].length > 5
                ? "${widget.transactions['user']['firstName'].substring(0, 5)}.."
                : widget.transactions['user']['firstName'],
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
