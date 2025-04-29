import 'package:boks/utility/constants/app_icons.dart';
import 'package:boks/utility/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class TransferNotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  const TransferNotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Center(
                          child: Container(
                            height: 43,
                            width: 43,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: notification['senderDetails'] == null ||
                                notification['senderDetails']['image'] == null ||
                                notification['senderDetails']['image'].toString().isEmpty
                                ? Center(
                              child: Icon(IconlyBold.profile, color: Colors.grey, size: 15),
                            )
                                : Image.network(
                              notification['senderDetails']['image'].toString(),
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(IconlyBold.profile, color: Colors.grey, size: 15),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 40,
                        width: 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Center(
                            child: Container(
                              height: 43,
                              width: 43,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: notification['receiverDetails'] == null ||
                                  notification['receiverDetails']['image'] == null ||
                                  notification['receiverDetails']['image'].toString().isEmpty
                                  ? Center(
                                child: Icon(IconlyBold.profile, color: Colors.grey, size: 15),
                              )
                                  : Image.network(
                                notification['receiverDetails']['image'].toString(),
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(IconlyBold.profile, color: Colors.grey, size: 15),
                                  );
                                },
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
            const SizedBox(width: 5,),
            Expanded(
              flex: 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['title'],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          "${formatTransactionDate(notification['createdAt'])}",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    Text(
                      addCurrencyPrefix(notification['message']),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String addCurrencyPrefix(String message) {
    List<String> parts = message.split(' ');
    int ofIndex = parts.indexOf("of");
    int forIndex = parts.indexOf("for");

    if (ofIndex != -1 && forIndex != -1 && ofIndex + 1 < forIndex) {
      String amount = parts[ofIndex + 1];
      parts[ofIndex + 1] = "${AppStrings.nairaSign}$amount";
      return parts.join(' ');
    }
    return message;
  }

  String formatTransactionDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final formatter = DateFormat('EEE, d MMM y');
      return formatter.format(dateTime);
    } catch (e) {
      return dateString;
    }
  }
}
