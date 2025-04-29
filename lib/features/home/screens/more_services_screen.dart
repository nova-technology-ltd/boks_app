import 'package:flutter/material.dart';

import '../../../utility/constants/app_icons.dart';
import '../../../utility/shared_components/custom_back_button.dart';
import '../bills/airtime/screens/airtime_screen.dart';
import '../bills/betting/screen/betting_screen.dart';
import '../bills/data_bundle/screens/data_bundle_screen.dart';
import '../bills/electricity/screen/electricity_screen.dart';
import '../bills/tv_and_cable/screen/tv_and_cable_screen.dart';
import '../bills/waec_and_jamb/jamb/screen/jamb_screen.dart';
import '../bills/waec_and_jamb/waec/screen/waec_screen.dart';
import '../components/service_section.dart';

class MoreServicesScreen extends StatefulWidget {
  const MoreServicesScreen({super.key});

  @override
  State<MoreServicesScreen> createState() => _MoreServicesScreenState();
}

class _MoreServicesScreenState extends State<MoreServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(context: context),
        centerTitle: true,
        title: const Text(
          "Services",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset("images/splash_screen_logo.png")),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ServiceCard(icon: AppIcons.airtimeIcon, title: "Airtime", onClick: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => AirtimeScreen()));}, color: Colors.orange,),
                  ServiceCard(icon: AppIcons.dataIcon, title: "Data", onClick: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DataBundleScreen()));
                  }, color: Colors.purple,),
                  ServiceCard(icon: AppIcons.cableIcon, title: "TV", onClick: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TvAndCableScreen()));
                  }, color: Colors.green,),
                  ServiceCard(icon: AppIcons.bettingIcon, title: "Betting", onClick: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BettingScreen()));
                  }, color: Colors.red,),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ServiceCard(icon: AppIcons.electricityIcon, title: "Electricity", onClick: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => ElectricityScreen()));}, color: Colors.yellowAccent,),
                  ServiceCard(icon: AppIcons.waecIcon, title: "WAEC", onClick: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WaecScreen()));
                  }, color: Colors.pink,),
                  ServiceCard(icon: AppIcons.jambIcon, title: "JAMB", onClick: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const JambScreen()));
                  }, color: Colors.blue,),
                  Container(
                    height: 55,
                    width: 77,

                  ),
                  // ServiceCard(icon: AppIcons.moreIcon, title: "More", onClick: (){
                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MoreServicesScreen()));
                  // }, color: Colors.grey,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
