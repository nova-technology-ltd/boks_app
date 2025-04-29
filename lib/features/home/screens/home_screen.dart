import 'package:boks/features/auth/service/auth_service.dart';
import 'package:boks/features/home/components/balance_card.dart';
import 'package:boks/features/transactions/components/recent_transfer_section.dart';
import 'package:boks/features/home/components/service_section.dart';
import 'package:boks/features/home/components/transaction_history_sumup_card.dart';
import 'package:boks/features/notifications/screens/notification_screen.dart';
import 'package:boks/features/profile/model/user_provider.dart';
import 'package:boks/features/transactions/components/transaction_history_section.dart';
import 'package:boks/features/transactions/screens/transaction_history_screen.dart';
import 'package:boks/features/transactions/screens/statistics_screen.dart';
import 'package:boks/utility/constants/app_colors.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utility/constants/app_strings.dart';
import '../../transactions/screens/transfer_screen_one.dart';
import '../../transactions/service/transaction_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRefreshing = false;
  String getGreeting() {
    var now = DateTime.now();
    var hour = now.hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }


  final TransactionService _transactionService = TransactionService();
  late Future<List<Map<String, dynamic>>> _futureRecentTransfers;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    _futureRecentTransfers = _transactionService.getAllUserRecentTransfers(context);
    super.initState();
  }

  Future<void> _refreshScreen(BuildContext context) async {
    try {
      setState(() {
        isRefreshing = true;
        _futureRecentTransfers = _transactionService.getAllUserRecentTransfers(context);
      });
      await _authService.userProfile(context);

      setState(() {
        isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        isRefreshing = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).userModel;
    return RefreshIndicator(
      onRefresh: () => _refreshScreen(context),
      backgroundColor: Colors.white,
      color: Color(AppColors.primaryColor),
      child: Scaffold(
        backgroundColor: Colors.white,
        // backgroundColor: Color(AppColors.primaryColor),
        appBar: AppBar(
          backgroundColor: Color(AppColors.primaryColor),
          surfaceTintColor: Color(AppColors.primaryColor),
          automaticallyImplyLeading: false,
          leadingWidth: 55,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 45,
                        width: 45,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            shape: BoxShape.circle
                        ),
                        child: Image.network(user.image, fit: BoxFit.cover, errorBuilder: (er, context, st) {
                          return Center(
                            child: Icon(IconlyBold.profile, color: Colors.grey, size: 18,),
                          );
                        },),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getGreeting(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  isRefreshing ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: CupertinoActivityIndicator(
                      color: Colors.white,
                    ),
                  ) : const SizedBox.shrink()
                ],
              ),
              Text(
                "Let's make payment!",
                style: TextStyle(fontSize: 10, color: Colors.grey[200]),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 45,
                width: 45,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.history,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TransactionHistoryScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StatisticsScreen()));
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Available Balance",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: AppStrings.nairaSign,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                TextSpan(
                                  text: _formatPrice(double.parse("${user.userWallet!.accountBalance}")),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                TextSpan(
                                  text: _getFractionalPart(double.parse("${user.userWallet!.accountBalance}")),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(360),
                          ),
                          child: MaterialButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: Image.asset(
                                    "images/arrow-down-from-arc.png",
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Deposit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(360),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransferScreenOne(futureRecentTransfers: _futureRecentTransfers,)));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: Transform.rotate(
                                    angle: -1.5,
                                    child: Image.asset(
                                      "images/arrow-down-from-arc.png",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Transfer",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ServiceSection(),
              ),
              const SizedBox(height: 15),
              // RecentTransferSection(),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TransactionHistorySumupCard(),
              ),
              const SizedBox(height: 15),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //   child: TransactionHistorySection(),
              // ),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {},
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Color(AppColors.primaryColor),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.headphones_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    try {
      return _formatNumber(price);
    } catch (e) {
      print('Error formatting price: $e');
      return '0';
    }
  }

  String _formatNumber(double number) {
    NumberFormat formatter = NumberFormat("#,###");
    return formatter.format(number);
  }

  String _getFractionalPart(double number) {
    return (number - number.truncate()).toStringAsFixed(2).substring(1);
  }

}
