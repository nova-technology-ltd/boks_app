import 'package:boks/utility/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../utility/constants/app_icons.dart';

class TransactionHistorySumupCard extends StatefulWidget {
  const TransactionHistorySumupCard({super.key});

  @override
  State<TransactionHistorySumupCard> createState() => _TransactionHistorySumupCardState();
}

class _TransactionHistorySumupCardState extends State<TransactionHistorySumupCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Monthly Report",
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 5,),
        Container(
          height: 75,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(AppColors.primaryColor).withOpacity(0.0),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15,), topRight: Radius.circular(15), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Row(
              children: [
                SizedBox(
                  height: 55,
                  width: 55,
                  child: CircularProgressIndicator(
                    value: 10 / 100,
                    strokeWidth: 10.0,
                    backgroundColor: Colors.grey[300],
                    strokeCap: StrokeCap.round,
                    color: 10 == 100
                        ? Colors.green
                        : Color(AppColors.primaryColor),
                  ),
                ),
                const SizedBox(width: 15,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "This month",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black
                      ),
                    ),
                    Text(
                      "Here is what you've spent this month",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(AppIcons.airtimeIcon,
                              color: Color(AppColors.primaryColor).withOpacity(0.8),
                              // color: color,
                            )),
                        const SizedBox(width: 10,),
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(AppIcons.dataIcon,
                              color: Color(AppColors.primaryColor).withOpacity(0.8),
                              // color: color,
                            )),
                        const SizedBox(width: 10,),
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(AppIcons.cableIcon,
                              color: Color(AppColors.primaryColor).withOpacity(0.8),
                              // color: color,
                            )),
                        const SizedBox(width: 10,),
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(AppIcons.bettingIcon,
                              color: Color(AppColors.primaryColor).withOpacity(0.8),
                              // color: color,
                            )),
                        const SizedBox(width: 10,),
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(AppIcons.electricityIcon,
                              color: Color(AppColors.primaryColor).withOpacity(0.8),
                              // color: color,
                            )),
                        const SizedBox(width: 10,),
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(AppIcons.waecIcon,
                              color: Color(AppColors.primaryColor).withOpacity(0.8),
                              // color: color,
                            )),
                        const SizedBox(width: 10,),
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(AppIcons.jambIcon,
                              color: Color(AppColors.primaryColor).withOpacity(0.8),
                              // color: color,
                            )),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
