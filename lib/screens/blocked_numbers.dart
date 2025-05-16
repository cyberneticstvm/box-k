import 'package:boxk/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlockedNumberScreen extends ConsumerStatefulWidget {
  const BlockedNumberScreen({super.key});

  @override
  ConsumerState<BlockedNumberScreen> createState() {
    return _BlockedNumberScreenState();
  }
}

class _BlockedNumberScreenState extends ConsumerState<BlockedNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  String _number = '';
  int _count = 0;
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
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      setState(() {
        _isSaving = true;
      });
      await FirebaseFirestore.instance
          .collection('blocked_numbers')
          .where('number', isEqualTo: _number)
          .get()
          .then((collectionRef) {
        if (collectionRef.docs.isNotEmpty) {
          _message('Number already exists', Colors.white, Colors.red);
        } else {
          FirebaseFirestore.instance.collection('blocked_numbers').add({
            'number': _number,
            'count': _count,
          });
          _message('Number blocked successfully!', Colors.white, Colors.green);
        }
      });
      setState(() {
        _isSaving = false;
      });
      _formKey.currentState!.reset();
    } catch (err) {
      setState(() {
        _isSaving = false;
      });
      _message(err.toString(), Colors.white, Colors.red);
    }
  }

  void _delete(String docId) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Proceed?'),
          content: const Text('Are you sure want to delete this number?'),
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
          .collection('blocked_numbers')
          .doc(docId)
          .delete();
      _message("Number released successfully!", Colors.white, Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Management',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Block Number',
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).myBlueColorDark),
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
                      labelText: 'Number',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value == '0') {
                        return 'Please enter a valid Number.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _number = value!;
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
                      labelText: 'Count',
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value == '0') {
                        return 'Please enter a valid Count.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _count = int.parse(value!);
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
                                'BLOCK',
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
                        .collection('blocked_numbers')
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No blocked numbers found.'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).myBlueColorDark),
                        );
                      }
                      return DataTable(
                        columns: const [
                          DataColumn(label: Text('Number')),
                          DataColumn(label: Text('Count')),
                          DataColumn(label: Text('Delete')),
                        ],
                        rows: snapshot.data!.docs
                            .map(
                              (item) => DataRow(
                                cells: [
                                  DataCell(Text(item['number'])),
                                  DataCell(Text(item['count'].toString())),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).myRedColorDark,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          snapshot.data!.docs.remove(item);
                                        });
                                        _delete(item.id);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
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
