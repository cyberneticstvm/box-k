import 'package:boxk/colors/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SchemeEditScreen extends ConsumerStatefulWidget {
  const SchemeEditScreen({super.key, required this.docId});

  final String docId;

  @override
  ConsumerState<SchemeEditScreen> createState() {
    return _SchemeScreenState();
  }
}

class _SchemeScreenState extends ConsumerState<SchemeEditScreen> {
  final _schemeFormKey = GlobalKey<FormState>();
  bool _isUpdating = false;
  final _amountController = TextEditingController();
  final _superController = TextEditingController();
  final _countController = TextEditingController();
  final _nameController = TextEditingController();
  int amount = 0;
  int superr = 0;
  int count = 0;
  DocumentSnapshot<Map<String, dynamic>>? ticket;

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
    final isValid = _schemeFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _schemeFormKey.currentState!.save();
    try {
      setState(() {
        _isUpdating = true;
      });
      FirebaseFirestore.instance.collection('schemes').doc(widget.docId).update(
        {
          'count': count,
          'amount': amount,
          'super': superr,
        },
      );
      setState(() {
        _isUpdating = false;
      });
      if (mounted) Navigator.pop(context);
      _message('Scheme updated successfully',
          Theme.of(context).myGreenColorDark, Colors.white);
    } on FirebaseException catch (err) {
      _message(err.message.toString(), Colors.red, Colors.white);
    }
  }

  void getTicket() async {
    ticket = await FirebaseFirestore.instance
        .collection('schemes')
        .doc(widget.docId)
        .get();
    setState(() {
      _amountController.text = ticket!['amount'].toString();
      _superController.text = ticket!['super'].toString();
      _countController.text = ticket!['count'].toString();
      _nameController.text = ticket?['ticket'];
    });
  }

  @override
  void initState() {
    getTicket();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _superController.dispose();
    _countController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Scheme',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
              key: _schemeFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
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
                      labelText: 'Ticket Name',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid Ticket Name.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _amountController,
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
                            labelText: 'Amount',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter Amount.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            amount = int.parse(value!);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _superController,
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
                            labelText: 'Super',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter Super.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            superr = int.parse(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _countController,
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
                            labelText: 'Maximum Count',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter Count.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            count = int.parse(value!);
                          },
                        ),
                      ),
                    ],
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
