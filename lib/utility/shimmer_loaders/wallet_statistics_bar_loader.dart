import 'package:flutter/material.dart';

import '../../features/transactions/components/wallet_statistics_bar.dart';

class WalletStatisticsBarLoader extends StatelessWidget {
  const WalletStatisticsBarLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        children: [
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                  )
                ],
              ),
          const SizedBox(height: 15,),
          Row(
            children: [
              Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle
                ),
              ),
              const SizedBox(width: 5,),
              Container(
                height: 5,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
              ),
              Spacer(),
              Container(
                height: 5,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle
                ),
              ),
              const SizedBox(width: 5,),
              Container(
                height: 5,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
              ),
              Spacer(),
              Container(
                height: 5,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle
                ),
              ),
              const SizedBox(width: 5,),
              Container(
                height: 5,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
              ),
              Spacer(),
              Container(
                height: 5,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
