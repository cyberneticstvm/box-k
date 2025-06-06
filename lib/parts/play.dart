import 'package:boxk/providers/item.dart';
import 'package:boxk/providers/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:boxk/colors/color.dart';

class PlayDropdownList extends ConsumerStatefulWidget {
  const PlayDropdownList({super.key, required this.isBlockedCheck});

  final bool isBlockedCheck;

  @override
  ConsumerState<PlayDropdownList> createState() {
    return _PlayDropdownState();
  }
}

class _PlayDropdownState extends ConsumerState<PlayDropdownList> {
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

  void openDropDown() async {
    List colors = [
      Theme.of(context).myAmberColorDark,
      Theme.of(context).myGreenColorDark,
      Theme.of(context).myRedColorDark,
      Theme.of(context).myPurpleColorDark
    ];
    final plays = await FirebaseFirestore.instance
        .collection('plays')
        .where('name', isNotEqualTo: 'All')
        .orderBy('id')
        .get()
        .then((snapshot) {
      return snapshot.docs.toList();
    });
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Dialog(
            alignment: Alignment.topLeft,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: const BorderSide(
                color: Colors.green,
              ),
            ),
            child: ListView.builder(
              itemCount: plays.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    tileColor: colors[index] ?? Colors.black,
                    textColor: Colors.white,
                    title: Text(plays[index]['name']),
                    onTap: () {
                      ref.read(selectedPlayCode.notifier).update(
                            (state) => plays[index]['code'].toString(),
                          );
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }

  void isPlayLocked() async {
    final play = await FirebaseFirestore.instance
        .collection('plays')
        .where('name', isNotEqualTo: 'All')
        .where('code', isEqualTo: ref.watch(selectedPlayCode))
        .get()
        .then((snapshot) {
      return snapshot.docs[0].data();
    });
    TimeOfDay now = TimeOfDay.now();
    TimeOfDay stime =
        TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(play['locked_from']));
    TimeOfDay etime =
        TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(play['locked_to']));
    if ((now.hour > stime.hour ||
                (now.hour == stime.hour && now.minute >= stime.minute)) &&
            now.hour < etime.hour ||
        (now.hour == etime.hour && now.minute <= etime.minute)) {
      ref.read(isPlayBlocked.notifier).update((state) => true);
      _message('Play has been locked', Colors.white, const Color(0xFFEA4335));
    } else {
      ref.read(isPlayBlocked.notifier).update((state) => false);
      DateTime date = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      if ((now.hour == stime.hour && stime.minute <= now.minute) ||
          (now.hour > stime.hour)) {
        date = DateTime.now().add(Duration(days: 1));
        date = DateTime(date.year, date.month, date.day);
        ref.read(playDate.notifier).update((state) => date);
      } else {
        ref.read(playDate.notifier).update((state) => DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
      }
      /*print([
        now.hour,
        now.minute,
        stime.hour,
        stime.minute,
        ref.watch(playDate)
      ]);*/
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isBlockedCheck) openDropDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBlockedCheck) isPlayLocked();
    final items = ref.watch(itemAddProvider);
    return Container(
      color: Theme.of(context).myGrayColorLight,
      height: MediaQuery.of(context).size.height * .05,
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('plays')
            .where('name', isNotEqualTo: 'All')
            .orderBy('id')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return DropdownButtonFormField(
            value: ref.watch(selectedPlayCode),
            isExpanded: true,
            items: snapshot.data!.docs.map((value) {
              return DropdownMenuItem(
                value: value['code'],
                enabled: (items.isEmpty) ? true : false,
                child: Text(
                  '${value['name']}',
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (value) {
              ref.read(selectedPlayCode.notifier).update(
                    (state) => value.toString(),
                  );
            },
            hint: const SizedBox(
              child: Text(
                "Select Play",
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
      ),
    );
  }
}
