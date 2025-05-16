import 'package:boxk/colors/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserEditScreen extends ConsumerStatefulWidget {
  const UserEditScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<UserEditScreen> createState() {
    return _UserScreenState();
  }
}

class _UserScreenState extends ConsumerState<UserEditScreen> {
  final _userFormKey = GlobalKey<FormState>();
  bool _isUpdating = false;
  final _userNameController = TextEditingController();
  var _password = '';
  DocumentSnapshot<Map<String, dynamic>>? user;

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

  void _update() async {
    final isValid = _userFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _userFormKey.currentState!.save();
    try {
      setState(() {
        _isUpdating = true;
      });
      await FirebaseAuth.instance.currentUser!.updatePassword(_password);
      setState(() {
        _isUpdating = false;
      });
      if (mounted) Navigator.pop(context);
      _message('Password updated successfully', Colors.green, Colors.white);
    } on FirebaseException catch (err) {
      _message(err.message.toString(), Colors.red, Colors.white);
    }
  }

  getUser() async {
    user = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    setState(() {
      _userNameController.text = user?['name'];
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update User',
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
                  TextFormField(
                    controller: _userNameController,
                    readOnly: true,
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
                      labelText: 'User Name',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid Play Name.';
                      }
                      return null;
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
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
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
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: _update,
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
                        (_isUpdating)
                            ? const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'UPDATE',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
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
