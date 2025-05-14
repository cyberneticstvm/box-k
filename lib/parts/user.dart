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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return DropdownButtonFormField(
          value: ref.watch(selectedUser),
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
