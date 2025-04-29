import 'package:boks/features/transactions/screens/transfer_money_screen.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class RecentTransferUserPreviewBottomSheet extends StatelessWidget {
  final Map<String, dynamic> data;

  const RecentTransferUserPreviewBottomSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: data['user']['image'].isEmpty ? Center(
                    child: Icon(
                      IconlyBold.profile,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ) : Image.network(data['user']['image'], fit: BoxFit.cover, errorBuilder: (context, err, st) {
                    return Center(
                      child: Icon(
                        IconlyBold.profile,
                        color: Colors.grey,
                        size: 18,
                      ),
                    );
                  },),
                ),
                const SizedBox(height: 5),
                Text(
                  "${data['user']['firstName']} ${data['user']['lastName']} ${data['user']['otherNames'].trim()}",
                ),
                Text(
                  "Last sent",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey
                  ),
                ),
                Text(
                  DateFormat('MMM d, y, h:mm a').format(
                    DateTime.parse(
                      data['transactionDate'].toString(),
                    ), // Ensure parsing works
                  ),
                ),
                Spacer(),
                CustomButton(title: "Send", onClick: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransferMoneyScreen(user: data['user'])));
                }, isLoading: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
