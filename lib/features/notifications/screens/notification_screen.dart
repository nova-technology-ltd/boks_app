import 'package:boks/features/notifications/components/subscription_notification_card.dart';
import 'package:boks/features/notifications/components/transfer_notification_card.dart';
import 'package:boks/features/notifications/services/notification_service.dart';
import 'package:boks/utility/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../utility/shared_components/custom_back_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  late Future<List<Map<String, dynamic>>> _futureNotifications;

  Future<void> _refreshScreen(BuildContext context) async {
    try {
      setState(() {
        _futureNotifications = _notificationService.getAllNotifications(context);
      });
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  void initState() {
    _futureNotifications = _notificationService.getAllNotifications(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshScreen(context),
      backgroundColor: Colors.white,
      color: Color(AppColors.primaryColor),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "Notifications",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500
            ),
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
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureNotifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    setState(() {
                      _refreshScreen(context);
                    });
                  }, icon: Icon(Icons.refresh)),
                ],
              ));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No notifications available'));
            } else {
              final notifications = snapshot.data!.reversed.toList();
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return notification['isSubscription']
                      ? Dismissible(
                      key: Key(notification['notificationID']),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          snapshot.data!.remove(notification);
                        });
                        _notificationService.deleteUserNotifications(
                          context,
                          [notification['notificationID']],
                        );
                      },
                      background: Container(
                        color: const Color(AppColors.primaryColor),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          IconlyBold.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: SubscriptionNotificationCard(notification: notification))
                      : Dismissible(
                      key: Key(notification['notificationID']),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          snapshot.data!.remove(notification);
                        });
                        _notificationService.deleteUserNotifications(
                          context,
                          [notification['notificationID']],
                        );
                      },
                      background: Container(
                        color: const Color(AppColors.primaryColor),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          IconlyBold.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: TransferNotificationCard(notification: notification));
                },
              );
            }
          },
        ),
      ),
    );
  }
}