import 'dart:math';

import 'package:expenses_tracker/presentation/home/home_screen.dart';
import 'package:expenses_tracker/presentation/stats/stats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBarMainScreen extends StatefulWidget {
  const NavBarMainScreen({super.key});

  @override
  State<NavBarMainScreen> createState() => _NavBarMainScreenState();
}

class _NavBarMainScreenState extends State<NavBarMainScreen> {
  int index = 0;

  Color selectedItemColor = Colors.blue;
  Color unSelectedItemColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.home,
                color: index == 0 ? selectedItemColor : unSelectedItemColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.graph_square_fill,
                  color: index == 1 ? selectedItemColor : unSelectedItemColor),
              label: 'Stats',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add_expense',
          );
        },
        shape: const CircleBorder(),
        child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.tertiary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ],
                transform: const GradientRotation(pi / 4),
              ),
            ),
            child: const Icon(CupertinoIcons.add)),
      ),
      body: index == 0 ? const HomeScreen() : const StatScreen(),
    );
  }
}
