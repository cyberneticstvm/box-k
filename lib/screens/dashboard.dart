import 'package:boxk/colors/color.dart';
import 'package:boxk/parts/timer.dart';
import 'package:boxk/providers/order.dart';
import 'package:boxk/providers/page.dart';
import 'package:boxk/providers/user.dart';
import 'package:boxk/widgets/dashboard.dart';
import 'package:boxk/widgets/drawer.dart';
import 'package:boxk/widgets/home.dart';
import 'package:boxk/widgets/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  void _message(String msg, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(
          msg,
        ),
      ),
    );
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_firebase.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot['status'] == 'Active') {
        ref
            .read(currentUserProvider.notifier)
            .update((state) => snapshot.data() as Map<String, dynamic>);
        ref
            .read(selectedUserProvider.notifier)
            .update((state) => snapshot.data() as Map<String, dynamic>);
        ref.read(selectedUser.notifier).update((state) => snapshot['uid']);
      } else {
        _firebase.signOut();
        _message("Invalid or Blocked User", Colors.red);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int selectedPageIndex = ref.watch(selectedPage);
    Widget activePage = DashboardWidget();
    if (selectedPageIndex == 1) {
      activePage = const DashboardWidget();
    }
    if (selectedPageIndex == 2) {
      activePage = const DashboardWidget();
    }
    if (selectedPageIndex == 3) {
      activePage = const DashboardWidget();
    }
    if (selectedPageIndex == 4) {
      activePage = const HomeWidget();
    }
    if (selectedPageIndex == 5) {
      activePage = const OrderWidget();
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).myBlueColorLight,
        title: Wrap(
          children: [
            const Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
            Text(
              (ref.watch(currentUserProvider)['name']) ?? 'Na',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            child: Column(
              children: [
                Text(
                  ref.watch(nextPlayName),
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                const CountdownTimer(),
              ],
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: activePage,
      bottomNavigationBar: Visibility(
        visible: (selectedPageIndex != 5) ? true : false,
        child: BottomNavigationBar(
          iconSize: 25,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).myBlueColorDark,
          onTap: (i) {
            ref.read(selectedPage.notifier).update((state) => i);
          },
          currentIndex: ref.watch(selectedPage),
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              label: 'Back',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Sales',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            if (ref.watch(selectedPage) == 5)
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add',
              ),
          ],
        ),
      ),
    );
  }
}
