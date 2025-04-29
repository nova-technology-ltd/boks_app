import 'package:boks/features/home/screens/home_screen.dart';
import 'package:boks/features/notifications/screens/notification_screen.dart';
import 'package:boks/features/settings/screens/settings_screen.dart';
import 'package:boks/features/transactions/screens/statistics_screen.dart';
import 'package:flutter/material.dart';

import 'custom_bottom_action.dart';

class MainPanel extends StatefulWidget {
  const MainPanel({super.key});

  @override
  State<MainPanel> createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  late Offset _offset = const Offset(0, 0);
  String selectedOption = "Home";
  int activeScreen = 0;

  final screens = [
    const HomeScreen(),
    const StatisticsScreen(),
    const NotificationScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      setState(() {
        _offset = Offset(
          (screenSize.width - 100) / 2.6,
          screenSize.height - 80,
        );
      });
    });
  }

  Widget _currentScreen = const HomeScreen();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: screens[activeScreen],
            ),
            if (_offset != null)
              Positioned(
                left: _offset.dx,
                top: _offset.dy,
                child: Draggable(
                  feedback: CustomBottomAction(
                    home: selectedOption,
                    search: selectedOption,
                    cart: selectedOption,
                    onHomeClick: () {},
                    onSearchClick: () {},
                    onCartClick: () {},
                    profile: selectedOption,
                    onProfileClick: () {},
                  ),
                  child: CustomBottomAction(
                    home: selectedOption,
                    search: selectedOption,
                    cart: selectedOption,
                    onHomeClick: () {
                      setState(() {
                        selectedOption = "Home";
                        activeScreen = 0;
                      });
                    },
                    onSearchClick: () {
                      setState(() {
                        selectedOption = "Search";
                        activeScreen = 1;
                      });
                    },
                    onCartClick: () {
                      setState(() {
                        selectedOption = "Cart";
                        activeScreen = 2;
                      });
                    },
                    profile: selectedOption,
                    onProfileClick: () {
                      setState(() {
                        selectedOption = "Profile";
                        activeScreen = 3;
                      });
                    },
                  ),
                  onDragEnd: (details) {
                    setState(() {
                      double adjust = MediaQuery.of(context).size.height -
                          constraints.maxHeight;
                      _offset =
                          Offset(details.offset.dx, details.offset.dy - adjust);
                    });
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
