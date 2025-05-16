import 'package:boxk/app_config.dart';
import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase = FirebaseAuth.instance;

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() {
    return _UserManagementScreenState();
  }
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final _userFormKey = GlobalKey<FormState>();
  var _userName = '';
  var _password = '';
  bool _isObscure = true;
  bool _isSaving = false;

  void _message(
    String msg,
    Color color,
    Color bg,
  ) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: bg,
      textColor: color,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void _create() async {
    final isValid = _userFormKey.currentState!.validate();
    final parent = ref.watch(currentUserProvider)['uid'];
    final role =
        (ref.watch(currentUserProvider)['role'] == 'Admin') ? 'Leader' : 'User';
    if (!isValid) {
      return;
    }
    _userFormKey.currentState!.save();
    try {
      setState(() {
        _isSaving = true;
      });
      final email =
          '$_userName${AppConfig.config['email']!['domain'].toString()}';
      await _firebase
          .createUserWithEmailAndPassword(email: email, password: _password)
          .then((userCredential) async {
        await FirebaseFirestore.instance
            .collection('users')
            .orderBy('uid', descending: true)
            .limit(1)
            .get()
            .then((collectionRef) async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'uid': collectionRef.docs[0]['uid'] + 1,
            'name': _userName,
            'email': email,
            'password': _password,
            'parent': parent,
            'role': role,
            'status': 'Active'
          });
        });
        //ref.invalidate(currentUserProvider);
        //_firebase.signOut();
      });
      setState(() {
        _isSaving = false;
      });
      _userFormKey.currentState!.reset();
      _message('User created successfully!', Colors.white, Colors.green);
    } catch (err) {
      setState(() {
        _isSaving = false;
      });
      _message(err.toString(), Colors.white, Colors.red);
    }
  }

  void _delete(String uid) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Proceed?'),
          content: const Text('Are you sure want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFFEA4335),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
    if (result) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'status': "Inactive"});
      _message("User deleted successfully!", Colors.white, Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Management',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
              key: _userFormKey,
              child: Column(
                children: [
                  if ((ref.watch(currentUserProvider)['role'] == 'Admin'))
                    Text(
                      'Create Agent / Leader',
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).myBlueColorDark),
                    ),
                  if ((ref.watch(currentUserProvider)['role'] == 'Leader'))
                    const Text(
                      'Create Subagent / User',
                      style: TextStyle(fontSize: 20, color: Color(0xFFEA4335)),
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).myBlueColorDark,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).myBlueColorDark,
                          width: 1,
                        ),
                      ),
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid Username.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).myBlueColorDark,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).myBlueColorDark,
                          width: 1,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    obscureText: _isObscure,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid Password.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: _create,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      backgroundColor: Theme.of(context).myBlueColorLight,
                    ),
                    child: Wrap(
                      children: [
                        (_isSaving)
                            ? const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'CREATE',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where('status', isEqualTo: 'Active')
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No users found.'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).myBlueColorDark),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          columnSpacing: 25,
                          columns: const [
                            DataColumn(label: Text('User Name')),
                            DataColumn(label: Text('User Role')),
                            DataColumn(label: Text('Delete')),
                          ],
                          rows: snapshot.data!.docs
                              .map(
                                (item) => DataRow(
                                  cells: [
                                    DataCell(Text(item['name'])),
                                    DataCell(Text(item['role'])),
                                    DataCell(
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color:
                                              Theme.of(context).myRedColorDark,
                                        ),
                                        onPressed: () {
                                          _delete(item.id);
                                          setState(() {
                                            snapshot.data!.docs.remove(item);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
