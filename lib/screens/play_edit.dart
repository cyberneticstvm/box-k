import 'package:boxk/colors/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class PlayEditScreen extends ConsumerStatefulWidget {
  const PlayEditScreen({super.key, required this.playId});

  final int playId;

  @override
  ConsumerState<PlayEditScreen> createState() {
    return _PlayScreenState();
  }
}

class _PlayScreenState extends ConsumerState<PlayEditScreen> {
  final _playFormKey = GlobalKey<FormState>();
  var _lockedFrom = '';
  var _lockedTo = '';
  bool _isUpdating = false;
  final _playNameController = TextEditingController();
  final _playCodeController = TextEditingController();
  final _lockedFromTimeController = TextEditingController();
  final _lockedToTimeController = TextEditingController();
  Map<String, dynamic>? play;

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
    final isValid = _playFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _playFormKey.currentState!.save();
    try {
      setState(() {
        _isUpdating = true;
      });
      await FirebaseFirestore.instance
          .collection('plays')
          .where('id', isEqualTo: widget.playId)
          .get()
          .then((snaphot) async {
        await FirebaseFirestore.instance
            .collection('plays')
            .doc(snaphot.docs[0].id)
            .update({
          'locked_from': DateFormat('HH:mm:ss')
              .format(DateFormat('h:mm a').parse(_lockedFrom)),
          'locked_to': DateFormat('HH:mm:ss')
              .format(DateFormat('h:mm a').parse(_lockedTo)),
        });
      });
      setState(() {
        _isUpdating = false;
      });
      if (mounted) Navigator.pop(context);
      _message('Play updated successfully', Colors.green, Colors.white);
    } on FirebaseException catch (err) {
      _message(err.message.toString(), Colors.red, Colors.white);
    }
  }

  getPlay() async {
    await FirebaseFirestore.instance
        .collection('plays')
        .where('id', isEqualTo: widget.playId)
        .get()
        .then((snapshot) {
      setState(() {
        play = snapshot.docs[0].data();
        _playNameController.text = play?['name'];
        _playCodeController.text = play?['code'];
        _lockedFromTimeController.text = TimeOfDay.fromDateTime(
                DateFormat('HH:mm:ss').parse(play?['locked_from']))
            .format(context);
        _lockedToTimeController.text = TimeOfDay.fromDateTime(
                DateFormat('HH:mm:ss').parse(play?['locked_to']))
            .format(context);
      });
    });
  }

  void _pickedTime(String type) async {
    await showTimePicker(
      context: context,
      initialTime: (type == 'from')
          ? TimeOfDay.fromDateTime(
              DateFormat('HH:mm:ss').parse(play?['locked_from']))
          : TimeOfDay.fromDateTime(
              DateFormat('HH:mm:ss').parse(play?['locked_to'])),
    ).then((pickedtime) {
      if (pickedtime == null) {
        return;
      }
      setState(() {
        if (type == 'from') {
          _lockedFrom = pickedtime.format(context);
          _lockedFromTimeController.text = pickedtime.format(context);
        } else {
          _lockedTo = pickedtime.format(context);
          _lockedToTimeController.text = pickedtime.format(context);
        }
      });
    });
  }

  @override
  void initState() {
    getPlay();
    super.initState();
  }

  @override
  void dispose() {
    _playNameController.dispose();
    _playCodeController.dispose();
    _lockedFromTimeController.dispose();
    _lockedToTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Play',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
              key: _playFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _playNameController,
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
                      labelText: 'Play Name',
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
                    readOnly: true,
                    controller: _playCodeController,
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
                      labelText: 'Play Code',
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
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _lockedFromTimeController,
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
                            labelText: 'Locked From',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.none,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter valid time.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _lockedFrom = value!;
                          },
                          onTap: () {
                            _pickedTime('from');
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _lockedToTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Locked To',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.none,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter valid time.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _lockedTo = value!;
                          },
                          onTap: () {
                            _pickedTime('to');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
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
