import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';



void showSnackBar(
    {required BuildContext context,
      required String message,
      required String title,
      VoidCallback? onClick,
      bool? isOkayButton,
      bool? isCancelButton,
      bool isExtra = false,
    }) {
  showCupertinoModalPopup(context: context, builder: (context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: const Color(AppColors.primaryColor)
                        .withOpacity(0.1),
                    shape: BoxShape.circle),
                child: Center(
                  child: Icon(IconlyBold.message, color: Color(AppColors.primaryColor),),
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey
                ),
              ),
              const SizedBox(height: 10,),
              isExtra ? CustomButton(title: "Proceed", onClick: (){
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BvnUpdateScreen()));
              }, isLoading: false) : const SizedBox.shrink()
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.circle
          ),
          child: const Center(
            child: Icon(Icons.close, size: 18,),
          ),
        ),
      ),
    ],
  ));
}
