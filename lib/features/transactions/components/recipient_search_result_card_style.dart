import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class RecipientSearchResultCardStyle extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onClick;
  const RecipientSearchResultCardStyle({super.key, required this.user, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent
          ),
          child: Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle
                ),
                child: Center(
                  child: Icon(IconlyBold.profile, size: 18, color: Colors.grey,),
                ),
              ),
              const SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user['firstName']} ${user["lastName"]} ${user["otherNames"]}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    formatNumberWithAsterisks(int.parse(user['phoneNumber'])),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: user['isEmailVerified'] ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(360)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                  child: Text(
                      user['isEmailVerified'] ? "verified" : "unverified",
                    style: TextStyle(
                      fontSize: 11,
                      color: user['isEmailVerified'] ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              )
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
