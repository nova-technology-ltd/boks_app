import 'package:boks/features/home/bills/airtime/screens/airtime_screen.dart';
import 'package:boks/features/home/bills/betting/screen/betting_screen.dart';
import 'package:boks/features/home/bills/data_bundle/screens/data_bundle_screen.dart';
import 'package:boks/features/home/bills/electricity/screen/electricity_screen.dart';
import 'package:boks/features/home/bills/tv_and_cable/screen/tv_and_cable_screen.dart';
import 'package:boks/features/home/bills/waec_and_jamb/jamb/screen/jamb_screen.dart';
import 'package:boks/features/home/bills/waec_and_jamb/waec/screen/waec_screen.dart';
import 'package:boks/features/home/screens/more_services_screen.dart';
import 'package:boks/utility/constants/app_colors.dart';
import 'package:boks/utility/constants/app_icons.dart';
import 'package:flutter/material.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 180,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(AppColors.primaryColor).withOpacity(0.0),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Services",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 5,),
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
                ServiceCard(icon: AppIcons.moreIcon, title: "More", onClick: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MoreServicesScreen()));
                }, color: Colors.grey,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String icon;
  final String title;
  final Color color;
  final VoidCallback onClick;
  const ServiceCard({super.key, required this.icon, required this.title, required this.onClick, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // height: 55,
        // width: 78,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.0),
              spreadRadius: 2,
              blurRadius: 25,
              offset: const Offset(1, 1)
            )
          ]
        ),
        child: MaterialButton(
          onPressed: onClick,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 22,
                      width: 22,
                      child: Image.asset(icon,
                        color: Color(AppColors.primaryColor).withOpacity(0.8),
                        // color: color,
                      )),
                  const SizedBox(height: 8,),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
