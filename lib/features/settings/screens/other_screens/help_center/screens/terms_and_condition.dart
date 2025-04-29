import 'package:boks/utility/shared_components/custom_back_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leadingWidth: 90,
        centerTitle: true,
        title: const Text(
          "Terms And Conditions",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.print,
              color: Colors.grey,
            ),
            tooltip: "Print",
          )
        ],
        leading: CustomBackButton(context: context),
      ),
      // body: const SingleChildScrollView(
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 10.0),
      //     child: Text(
      //       AppStrings.termsAndCondition
      //     ),
      //   ),
      // ),
    );
  }
}
