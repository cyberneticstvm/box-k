import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:boxk/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NumberGroupReport extends ConsumerStatefulWidget {
  const NumberGroupReport({super.key});

  @override
  ConsumerState<NumberGroupReport> createState() {
    return _NumberGroupReportState();
  }
}

class _NumberGroupReportState extends ConsumerState<NumberGroupReport> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Wrap(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 13),
                      child: Text(
                        '1',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Radio(
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          return (states.contains(WidgetState.selected))
                              ? const Color(0xff2c73e7)
                              : Colors.black;
                        },
                      ),
                      activeColor: Theme.of(context).myBlueColorDark,
                      value: 1,
                      groupValue: ref.watch(selectedNumberGroupReport),
                      onChanged: (value) {
                        ref
                            .read(selectedNumberGroupReport.notifier)
                            .update((state) => value!);
                      },
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 13),
                      child: Text(
                        '2',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Radio(
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          return (states.contains(WidgetState.selected))
                              ? const Color(0xff2c73e7)
                              : Colors.black;
                        },
                      ),
                      activeColor: Theme.of(context).myBlueColorDark,
                      value: 2,
                      groupValue: ref.watch(selectedNumberGroupReport),
                      onChanged: (value) {
                        ref
                            .read(selectedNumberGroupReport.notifier)
                            .update((state) => value!);
                      },
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 13),
                      child: Text(
                        '3',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Radio(
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          return (states.contains(WidgetState.selected))
                              ? const Color(0xff2c73e7)
                              : Colors.black;
                        },
                      ),
                      activeColor: Theme.of(context).myBlueColorDark,
                      value: 3,
                      groupValue: ref.watch(selectedNumberGroupReport),
                      onChanged: (value) {
                        ref
                            .read(selectedNumberGroupReport.notifier)
                            .update((state) => value!);
                      },
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PlayDropdownListReport extends ConsumerStatefulWidget {
  const PlayDropdownListReport({super.key});

  @override
  ConsumerState<PlayDropdownListReport> createState() {
    return _PlayDropdownReportState();
  }
}

class _PlayDropdownReportState extends ConsumerState<PlayDropdownListReport> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('plays').orderBy('id').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return DropdownButtonFormField(
          value: ref.watch(selectedPlayCodeReport),
          isExpanded: true,
          items: snapshot.data!.docs.map((value) {
            return DropdownMenuItem(
              value: value['code'],
              enabled: true,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: Text(
                  '${value['name']}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            ref
                .read(selectedPlayCodeReport.notifier)
                .update((state) => value.toString());
          },
          hint: const SizedBox(
            child: Text(
              "All",
              textAlign: TextAlign.center,
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

class TicketDropDownReport extends ConsumerStatefulWidget {
  const TicketDropDownReport({super.key});

  @override
  ConsumerState<TicketDropDownReport> createState() {
    return _TicketDropDownReportState();
  }
}

class _TicketDropDownReportState extends ConsumerState<TicketDropDownReport> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('tickets').orderBy('id').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return DropdownButtonFormField(
          value: ref.watch(selectedTicketReport),
          isExpanded: true,
          items: snapshot.data!.docs.map((value) {
            return DropdownMenuItem(
              value: value['name'],
              enabled: true,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: Text(
                  '${value['name']}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            ref.read(selectedTicketReport.notifier).update(
                  (state) => value.toString(),
                );
          },
          hint: const SizedBox(
            child: Text(
              "Select Ticket",
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

class FromDate extends ConsumerStatefulWidget {
  const FromDate({super.key});

  @override
  ConsumerState<FromDate> createState() {
    return _FromDateState();
  }
}

class _FromDateState extends ConsumerState<FromDate> {
  void _pickedFromDate() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(DateTime.now().year + 10),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        ref.read(selectedDateFrom.notifier).update((state) => pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(
            text: DateFormat.yMMMMd()
                .format(ref.watch(selectedDateFrom))
                .toString()),
        decoration: const InputDecoration(
          suffixIcon: Icon(
            Icons.calendar_month,
            color: Color(0xff2c73e7),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
        onTap: () {
          _pickedFromDate();
        },
      ),
    );
  }
}

class ToDate extends ConsumerStatefulWidget {
  const ToDate({super.key});

  @override
  ConsumerState<ToDate> createState() {
    return _ToDateState();
  }
}

class _ToDateState extends ConsumerState<ToDate> {
  void _pickedToDate() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(DateTime.now().year + 10),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        ref.read(selectedDateTo.notifier).update((state) => pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(
            text: DateFormat.yMMMMd()
                .format(ref.watch(selectedDateTo))
                .toString()),
        decoration: const InputDecoration(
          suffixIcon: Icon(
            Icons.calendar_month,
            color: Color(0xff2c73e7),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
        onTap: () {
          _pickedToDate();
        },
      ),
    );
  }
}

class UserDropdownListReport extends ConsumerStatefulWidget {
  const UserDropdownListReport({super.key});

  @override
  ConsumerState<UserDropdownListReport> createState() {
    return _UserDropdownReportState();
  }
}

class _UserDropdownReportState extends ConsumerState<UserDropdownListReport> {
  Future<QuerySnapshot<Map<String, dynamic>>>? _getUsers() async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .where('name', isNotEqualTo: 'All')
        .where('status', isEqualTo: 'Active');
    var users = await collection.where('role', isEqualTo: 'User').get();
    if (ref.watch(currentUserProvider)['role'] == 'Leader') {
      users = await collection
          .where('role', isEqualTo: 'User')
          .where('parent', isEqualTo: ref.watch(currentUserProvider)['uid'])
          .get();
    }
    if (ref.watch(currentUserProvider)['role'] == 'User') {
      users = await collection
          .where('uid', isEqualTo: ref.watch(currentUserProvider)['uid'])
          .get();
    }
    return users;
  }

  void _update(int uid) async {
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
          .read(selectedUserProviderReport.notifier)
          .update((state) => snapshot.data() as Map<String, dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return DropdownButtonFormField(
          value: (ref.watch(currentUserProvider)['role'] == 'User')
              ? ref.watch(currentUserProvider)['uid']
              : null,
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
