import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ElectricityServiceProviderShimmerLoader extends StatelessWidget {
  const ElectricityServiceProviderShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < 10; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 9,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            height: 7,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
