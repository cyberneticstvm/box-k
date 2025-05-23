import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:boxk/reports/number_detail.dart';
import 'package:boxk/reports/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberWiseReport extends ConsumerStatefulWidget {
  const NumberWiseReport({super.key});

  @override
  ConsumerState<NumberWiseReport> createState() {
    return _NumberWiseReportState();
  }
}

class _NumberWiseReportState extends ConsumerState<NumberWiseReport> {
  final _globalFormKey = GlobalKey<FormState>();
  fetchData() {
    final isValid = _globalFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _globalFormKey.currentState!.save();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NumberWiseDetailReport(),
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
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Number Wise Report',
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
                  ],
                ),
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
