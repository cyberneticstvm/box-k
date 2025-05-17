import 'package:boxk/colors/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResultEditScreen extends ConsumerStatefulWidget {
  const ResultEditScreen({super.key, required this.docId});

  final String docId;

  @override
  ConsumerState<ResultEditScreen> createState() {
    return _ResultEditScreenState();
  }
}

class _ResultEditScreenState extends ConsumerState<ResultEditScreen> {
  final _resultFormKey = GlobalKey<FormState>();
  String? p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
      p9,
      p10,
      p11,
      p12,
      p13,
      p14,
      p15,
      p16,
      p17,
      p18,
      p19,
      p20,
      p21,
      p22,
      p23,
      p24,
      p25,
      p26,
      p27,
      p28,
      p29,
      p30,
      p31,
      p32,
      p33,
      p34,
      p35;

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

  void _update() async {
    final isValid = _resultFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _resultFormKey.currentState!.save();
    try {
      setState(() {
        _isSaving = true;
      });
      await FirebaseFirestore.instance
          .collection('result')
          .doc(widget.docId)
          .update({
        'updated_at': DateTime.now(),
        'p1': p1,
        'p2': p2,
        'p3': p3,
        'p4': p4,
        'p5': p5,
        'p6': p6,
        'p7': p7,
        'p8': p8,
        'p9': p9,
        'p10': p10,
        'p11': p11,
        'p12': p12,
        'p13': p13,
        'p14': p14,
        'p15': p15,
        'p16': p16,
        'p17': p17,
        'p18': p18,
        'p19': p19,
        'p20': p20,
        'p21': p21,
        'p22': p22,
        'p23': p23,
        'p24': p24,
        'p25': p25,
        'p26': p26,
        'p27': p27,
        'p28': p28,
        'p29': p29,
        'p30': p30,
        'p31': p31,
        'p32': p32,
        'p33': p33,
        'p34': p34,
        'p35': p35,
      });
      setState(() {
        _isSaving = false;
      });
      if (mounted) Navigator.pop(context);
      _message('Result updated successfully', Colors.green, Colors.white);
    } on FirebaseException catch (err) {
      _message(err.message.toString(), Colors.red, Colors.white);
    }
  }

  DocumentSnapshot<Map<String, dynamic>>? result;

  _getResult() async {
    var r = await FirebaseFirestore.instance
        .collection('result')
        .doc(widget.docId)
        .get()
        .then((snapshot) {
      return snapshot;
    });
    setState(() {
      result = r;
    });
  }

  @override
  void initState() {
    _getResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Result for ${result?['play']}',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
              key: _resultFormKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p1']),
                          decoration: InputDecoration(
                            labelText: 'P1',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p1 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p2']),
                          decoration: InputDecoration(
                            labelText: 'P2',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p2 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p3']),
                          decoration: InputDecoration(
                            labelText: 'P3',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p3 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p4']),
                          decoration: InputDecoration(
                            labelText: 'P4',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p4 = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p5']),
                          decoration: InputDecoration(
                            labelText: 'P5',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p5 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p6']),
                          decoration: InputDecoration(
                            labelText: 'P6',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p6 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p7']),
                          decoration: InputDecoration(
                            labelText: 'P7',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p7 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p8']),
                          decoration: InputDecoration(
                            labelText: 'P8',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p8 = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p9']),
                          decoration: InputDecoration(
                            labelText: 'P9',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p9 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p10']),
                          decoration: InputDecoration(
                            labelText: 'P10',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p10 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p11']),
                          decoration: InputDecoration(
                            labelText: 'P11',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p11 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p12']),
                          decoration: InputDecoration(
                            labelText: 'P12',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p12 = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p13']),
                          decoration: InputDecoration(
                            labelText: 'P13',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p13 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p14']),
                          decoration: InputDecoration(
                            labelText: 'P14',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p14 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p15']),
                          decoration: InputDecoration(
                            labelText: 'P15',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p15 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p16']),
                          decoration: InputDecoration(
                            labelText: 'P16',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p16 = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p17']),
                          decoration: InputDecoration(
                            labelText: 'P17',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p17 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p18']),
                          decoration: InputDecoration(
                            labelText: 'P18',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p18 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p19']),
                          decoration: InputDecoration(
                            labelText: 'P19',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p19 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p20']),
                          decoration: InputDecoration(
                            labelText: 'P20',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p20 = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p21']),
                          decoration: InputDecoration(
                            labelText: 'P21',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p21 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p22']),
                          decoration: InputDecoration(
                            labelText: 'P22',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p22 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p23']),
                          decoration: InputDecoration(
                            labelText: 'P23',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p23 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p24']),
                          decoration: InputDecoration(
                            labelText: 'P24',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p24 = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p25']),
                          decoration: InputDecoration(
                            labelText: 'P25',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p25 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p26']),
                          decoration: InputDecoration(
                            labelText: 'P26',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p26 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p27']),
                          decoration: InputDecoration(
                            labelText: 'P27',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p27 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p28']),
                          decoration: InputDecoration(
                            labelText: 'P28',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p28 = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p29']),
                          decoration: InputDecoration(
                            labelText: 'P29',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p29 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p30']),
                          decoration: InputDecoration(
                            labelText: 'P30',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p30 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p31']),
                          decoration: InputDecoration(
                            labelText: 'P31',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p31 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p32']),
                          decoration: InputDecoration(
                            labelText: 'P32',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p32 = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p33']),
                          decoration: InputDecoration(
                            labelText: 'P33',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p33 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            if (val.length == 3) {
                              focus.nextFocus();
                            }
                          },
                          controller:
                              TextEditingController(text: result?['p34']),
                          decoration: InputDecoration(
                            labelText: 'P34',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p34 = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          controller:
                              TextEditingController(text: result?['p35']),
                          decoration: InputDecoration(
                            labelText: 'P35',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            p35 = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
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
                        (_isSaving)
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
