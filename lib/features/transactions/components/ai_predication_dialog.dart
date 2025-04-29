import 'package:flutter/material.dart';

class AiPredictionDialog extends StatelessWidget {
  final String totalSum;
  final bool isDaily;
  final String average;
  final String highestSpending;
  final String lowestSpending;
  final String mostSpentDay;
  const AiPredictionDialog({super.key, required this.totalSum, required this.isDaily, required this.average, required this.highestSpending, required this.lowestSpending, required this.mostSpentDay});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25)
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      shape: BoxShape.circle
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset("images/STK-20240102-WA0149.webp"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                RichText(
                  textAlign: TextAlign.center,
                    text: TextSpan(
                    children: [
                      TextSpan(
                          text: "AI Spending Insight",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      TextSpan(
                          text: isDaily ? "(Weekly Summary)" : "(Monthly Summary)",
                          style: TextStyle(
                              color: Colors.grey,
                            fontSize: 15
                          )
                      )
                    ]
                )),
                const SizedBox(height: 15,),
                RichText(text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Total: ",
                        style: TextStyle(
                            color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                        )
                    ),
                    TextSpan(
                        text: "$totalSum",
                        style: TextStyle(
                            color: Colors.grey
                        )
                    )
                  ]
                )),
                const SizedBox(height: 10,),
                RichText(text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Average: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      TextSpan(
                          text: "$average",
                          style: TextStyle(
                              color: Colors.grey
                          )
                      )
                    ]
                )),
                const SizedBox(height: 10,),
                RichText(text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Highest Spending: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      TextSpan(
                          text: "$highestSpending",
                          style: TextStyle(
                              color: Colors.grey
                          )
                      )
                    ]
                )),
                const SizedBox(height: 10,),
                RichText(text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Lowest Spending: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      TextSpan(
                          text: "$lowestSpending",
                          style: TextStyle(
                              color: Colors.grey
                          )
                      )
                    ]
                )),
                const SizedBox(height: 10,),
                RichText(text: TextSpan(
                    children: [
                      TextSpan(
                          text: "You spend most often on: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      TextSpan(
                          text: "$mostSpentDay",
                          style: TextStyle(
                              color: Colors.grey
                          )
                      )
                    ]
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
