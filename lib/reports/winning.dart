import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:boxk/providers/user.dart';
import 'package:boxk/reports/widget.dart';
import 'package:boxk/reports/winning_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WinningReportScreen extends ConsumerStatefulWidget {
  const WinningReportScreen({super.key});

  @override
  ConsumerState<WinningReportScreen> createState() {
    return _WinningReportScreenState();
  }
}

class _WinningReportScreenState extends ConsumerState<WinningReportScreen> {
  final _globalFormKey = GlobalKey<FormState>();

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

  fetchData() {
    final isValid = _globalFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (ref.watch(selectedPlayCodeReport) == 'All') {
      _message("Please select play", Colors.red, Colors.white);
      return;
    }
    _globalFormKey.currentState!.save();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const WinningSummaryReport(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          ref.invalidate(selectedNumberGroupReport);
          ref.invalidate(selectedPlayCodeReport);
          ref.invalidate(selectedTicketReport);
          ref.invalidate(selectedDateFrom);
          ref.invalidate(selectedDateTo);
          ref.invalidate(enteredBillNumber);
          ref.invalidate(enteredTicketNumber);
          ref.invalidate(selectedUserProviderReport);
          ref.invalidate(selectedUserFlag);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Winning Report',
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).myBlueColorDark),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _globalFormKey,
            child: Column(
              children: [
                NumberGroupReport(),
                PlayDropdownListReport(),
                SizedBox(
                  height: 10,
                ),
                TicketDropDownReport(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).myBlueColorLight,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).myBlueColorLight,
                              width: 1,
                            ),
                          ),
                          labelText: 'Bill Number',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          if (value!.isEmpty) {
                            value = int.parse('0').toString();
                          }
                          ref
                              .read(enteredBillNumber.notifier)
                              .update((state) => int.parse(value!));
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).myBlueColorLight,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).myBlueColorLight,
                              width: 1,
                            ),
                          ),
                          labelText: 'Ticket Number',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          ref
                              .read(enteredTicketNumber.notifier)
                              .update((state) => value!);
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
                    FromDate(),
                    SizedBox(
                      width: 10,
                    ),
                    ToDate(),
                  ],
                ),
                if (ref.watch(currentUserProvider)['role'] != 'User')
                  SizedBox(
                    height: 10,
                  ),
                if (ref.watch(currentUserProvider)['role'] != 'User')
                  UserDropdownListReport(),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    fetchData();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    backgroundColor: const Color(0xff2c73e7),
                  ),
                  child: Wrap(
                    children: [
                      Text(
                        'GENERATE REPORT',
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
        ),
      ),
    );
  }
}
