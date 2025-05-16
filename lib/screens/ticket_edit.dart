import 'package:boxk/colors/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TicketEditScreen extends ConsumerStatefulWidget {
  const TicketEditScreen({super.key, required this.docId});

  final String docId;

  @override
  ConsumerState<TicketEditScreen> createState() {
    return _TicketScreenState();
  }
}

class _TicketScreenState extends ConsumerState<TicketEditScreen> {
  final _ticketFormKey = GlobalKey<FormState>();
  bool _isUpdating = false;
  final _adminRateController = TextEditingController();
  final _userRateController = TextEditingController();
  final _leaderRateController = TextEditingController();
  final _countController = TextEditingController();
  final _nameController = TextEditingController();
  double adminRate = 0;
  double leaderRate = 0;
  double userRate = 0;
  int maxCount = 0;
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
    final isValid = _ticketFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _ticketFormKey.currentState!.save();
    try {
      setState(() {
        _isUpdating = true;
      });
      FirebaseFirestore.instance.collection('tickets').doc(widget.docId).update(
        {
          'admin_rate': adminRate,
          'leader_rate': leaderRate,
          'user_rate': userRate,
          'max_count': maxCount,
        },
      );
      setState(() {
        _isUpdating = false;
      });
      if (mounted) Navigator.pop(context);
      _message('Ticket updated successfully',
          Theme.of(context).myGreenColorDark, Colors.white);
    } on FirebaseException catch (err) {
      _message(err.message.toString(), Colors.red, Colors.white);
    }
  }

  void getTicket() async {
    ticket = await FirebaseFirestore.instance
        .collection('tickets')
        .doc(widget.docId)
        .get();
    setState(() {
      _adminRateController.text = ticket!['admin_rate'].toString();
      _leaderRateController.text = ticket!['leader_rate'].toString();
      _userRateController.text = ticket!['user_rate'].toString();
      _countController.text = ticket!['max_count'].toString();
      _nameController.text = ticket?['name'];
    });
  }

  @override
  void initState() {
    getTicket();
    super.initState();
  }

  @override
  void dispose() {
    _adminRateController.dispose();
    _leaderRateController.dispose();
    _userRateController.dispose();
    _countController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Ticket',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
              key: _ticketFormKey,
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
                          controller: _adminRateController,
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
                            labelText: 'Admin Rate',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter Admin Rate.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            adminRate = double.parse(value!);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _leaderRateController,
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
                            labelText: 'Leader Rate',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter Leader Rate.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            leaderRate = double.parse(value!);
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
                          controller: _userRateController,
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
                            labelText: 'User Rate',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter User Rate.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userRate = double.parse(value!);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
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
                            labelText: 'Max. Count',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter Maximum Count.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            maxCount = int.parse(value!);
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
