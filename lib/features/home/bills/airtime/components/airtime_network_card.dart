
import 'package:flutter/material.dart';

import '../../../../../utility/constants/app_colors.dart';

class AirtimeNetworkCard extends StatelessWidget {
  final String image;
  final String id;
  final String title;
  final String selectedService;
  final VoidCallback onClick;

  const AirtimeNetworkCard({
    super.key,
    required this.image,
    required this.id,
    required this.onClick,
    required this.selectedService, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onClick,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              Container(
                height: 35,
                width: 35,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      child: Image.asset(
                        "images/$image",
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (selectedService == id)
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Color(AppColors.primaryColor).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                shape: BoxShape.circle
                            ),
                            child: Icon(Icons.check, color: Color(AppColors.primaryColor), size: 19,),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10,),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}