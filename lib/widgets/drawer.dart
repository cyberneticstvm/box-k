import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/order.dart';
import 'package:boxk/providers/page.dart';
import 'package:boxk/providers/user.dart';
import 'package:boxk/reports/prize.dart';
import 'package:boxk/screens/bill_delete.dart';
import 'package:boxk/screens/blocked_numbers.dart';
import 'package:boxk/screens/play.dart';
import 'package:boxk/screens/result.dart';
import 'package:boxk/screens/scheme.dart';
import 'package:boxk/screens/ticket.dart';
import 'package:boxk/screens/user.dart';
import 'package:boxk/screens/user_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({super.key});

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
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
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).myBlueColorDark,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.all(
              10,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  leading: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  tileColor: Theme.of(context).myAmberColorDark,
                  title: Text(
                    (ref.watch(currentUserProvider)['name']) ?? 'Na',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                if ((ref.watch(currentUserProvider)['role'] == 'Admin') ||
                    (ref.watch(currentUserProvider)['role'] == 'Leader'))
                  ExpansionTile(
                    trailing: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    shape: const Border(),
                    title: const Text(
                      'User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).myAmberColorDark,
                        ),
                        title: const Text(
                          'Manage User',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const UserManagementScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).myAmberColorDark,
                        ),
                        title: const Text(
                          'Update Password',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => UserEditScreen(
                                userId: _firebase.currentUser!.uid,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if ((ref.watch(currentUserProvider)['role'] == 'Admin'))
                  ExpansionTile(
                    trailing: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    leading: const Icon(
                      Icons.abc,
                      color: Colors.white,
                    ),
                    shape: const Border(),
                    title: const Text(
                      'Block Number',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).myAmberColorDark,
                        ),
                        title: const Text(
                          'Manage Blocked Numbers',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const BlockedNumberScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if ((ref.watch(currentUserProvider)['role'] == 'Admin') ||
                    (ref.watch(currentUserProvider)['role'] == 'Leader'))
                  ExpansionTile(
                    trailing: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    leading: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                    ),
                    shape: const Border(),
                    title: const Text(
                      'Manage',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).myAmberColorDark,
                        ),
                        title: const Text(
                          'Plays',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const PlayScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).myAmberColorDark,
                        ),
                        title: const Text(
                          'Tickets',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const TicketScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).myAmberColorDark,
                        ),
                        title: const Text(
                          'Schemes',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const SchemeScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if ((ref.watch(currentUserProvider)['role'] == 'Admin'))
                  ExpansionTile(
                    trailing: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    leading: const Icon(
                      Icons.insert_drive_file_outlined,
                      color: Colors.white,
                    ),
                    shape: const Border(),
                    title: const Text(
                      'Bill',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).myAmberColorDark,
                        ),
                        title: const Text(
                          'Delete Bill',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const BillDeleteScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if ((ref.watch(currentUserProvider)['role'] == 'Admin'))
                  ExpansionTile(
                    trailing: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    leading: const Icon(
                      Icons.numbers,
                      color: Colors.white,
                    ),
                    shape: const Border(),
                    title: const Text(
                      'Result',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).myAmberColorDark,
                        ),
                        title: const Text(
                          'Upadate Result',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const ResultScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if ((ref.watch(currentUserProvider)['role'] == 'User') ||
                    (ref.watch(currentUserProvider)['role'] == 'Leader'))
                  ExpansionTile(
                    trailing: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    leading: const Icon(
                      Icons.numbers,
                      color: Colors.white,
                    ),
                    shape: const Border(),
                    title: const Text(
                      'Result',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).myAmberColorDark,
                        ),
                        title: const Text(
                          'Prize Result',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const PrizeResultReport(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if ((ref.watch(currentUserProvider)['role'] == 'Leader'))
                  ExpansionTile(
                    trailing: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    leading: const Icon(
                      Icons.insert_drive_file_outlined,
                      color: Colors.white,
                    ),
                    shape: const Border(),
                    title: const Text(
                      'Bill',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).myAmberColorDark,
                        ),
                        title: const Text(
                          'Delete Bill',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const BillDeleteScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () {
                    ref.invalidate(currentUserProvider);
                    ref.invalidate(selectedUserProvider);
                    ref.invalidate(selectedNumberSet);
                    ref.invalidate(selectedNumberGroup);
                    ref.invalidate(selectedPage);
                    _firebase.signOut();
                    _message("User logged out successfully", Colors.green);
                  },
                  child: Wrap(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Theme.of(context).myAmberColorDark,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Theme.of(context).myAmberColorDark,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
