import 'package:boxk/providers/order.dart';
import 'package:boxk/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDropdownList extends ConsumerStatefulWidget {
  const UserDropdownList({super.key});

  @override
  ConsumerState<UserDropdownList> createState() {
    return _UserDropdownState();
  }
}

class _UserDropdownState extends ConsumerState<UserDropdownList> {
  void _update(int uid) async {
    ref.read(selectedUser.notifier).update(
          (state) => uid,
        );
    final u = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(u.docs[0].id)
        .get()
        .then((DocumentSnapshot snapshot) {
      ref
          .read(selectedUserProvider.notifier)
          .update((state) => snapshot.data() as Map<String, dynamic>);
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>>? _getUsers() async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .where('status', isEqualTo: 'Active');
    var users = await collection.where('role', isEqualTo: 'User').get();
    if (ref.watch(currentUserProvider)['role'] == 'Leader') {
      users = await collection
          .where('role', isEqualTo: 'User')
          .where('parent', isEqualTo: ref.watch(currentUserProvider)['uid'])
          .get();
    }
    if (ref.watch(currentUserProvider)['role'] == 'User') {
      users = await collection
          .where('uid', isEqualTo: ref.watch(currentUserProvider)['uid'])
          .get();
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return DropdownButtonFormField(
          value: (ref.watch(currentUserProvider)['role'] == 'User')
              ? ref.watch(currentUserProvider)['uid']
              : null,
          isExpanded: true,
          items: snapshot.data!.docs.map((value) {
            return DropdownMenuItem(
              value: value['uid'],
              enabled: true,
              child: Text(
                '${value['name']}',
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (value) {
            _update(int.parse(value.toString()));
          },
          hint: const SizedBox(
            child: Text(
              "Select Agent",
              style: TextStyle(color: Colors.black),
            ),
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color(0xff2c73e7),
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff2c73e7),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff2c73e7),
                width: 1,
              ),
            ),
          ),
          dropdownColor: Colors.white,
        );
      },
    );
  }
}
