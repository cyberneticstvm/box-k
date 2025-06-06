import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:boxk/reports/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class PrizeResultReport extends ConsumerStatefulWidget {
  const PrizeResultReport({super.key});

  @override
  ConsumerState<PrizeResultReport> createState() {
    return _PrizeResultReportState();
  }
}

class _PrizeResultReportState extends ConsumerState<PrizeResultReport> {
  final _globalFormKey = GlobalKey<FormState>();
  var prize = [];
  var ticketList = [];
  void showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          heightFactor: 1,
          widthFactor: 1,
          child: SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              color: Theme.of(context).myAmberColorDark,
            ),
          ),
        );
      },
    );
  }

  void hideLoadingIndicator() {
    Navigator.of(context).pop();
  }

  List<String> _getPermutation(String s) {
    if (s.length <= 1) {
      return [s];
    }

    List<String> permutations = [];
    for (int i = 0; i < s.length; i++) {
      String firstChar = s[i];
      String remaining = s.substring(0, i) + s.substring(i + 1);
      List<String> subPermutations = _getPermutation(remaining);
      for (String subPermutation in subPermutations) {
        permutations.add(firstChar + subPermutation);
      }
    }
    return permutations.toList();
  }

  shareResult(String type) {
    String output = '';
    if (prize.isNotEmpty) {
      if (type == 'share') {
        for (int i = 0; i <= 4; i++) {
          output += "${i + 1} : ${prize[i]}\n";
        }
      }
      output += "COMPLEMENTS\n";
      List<dynamic> second = [];
      for (int i = 5; i <= 34; i++) {
        second.add(prize[i]);
      }
      second.sort((a, b) => a.compareTo(b));
      for (int i = 0; i < second.length; i++) {
        if (i % 3 == 0) output += "\n";
        output += "\t\t${second[i]}\t\t";
      }
    } else {
      output = 'No data found';
    }
    return output;
  }

  fetchData() async {
    prize = [];
    ticketList = [];
    final isValid = _globalFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _globalFormKey.currentState!.save();
    showLoadingIndicator();
    var result = FirebaseFirestore.instance
        .collection('result')
        .where('play_date', isEqualTo: ref.watch(selectedDateFrom));
    if (ref.watch(selectedPlayCodeReport) != 'All') {
      result =
          result.where('play', isEqualTo: ref.watch(selectedPlayCodeReport));
    }
    await result.get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (int i = 1; i <= 35; i++) {
          prize.add(snapshot.docs[0]['p$i']);
        }
      }
    });
    if (ref.watch(selectedTicketReport) == 'king') {
      setState(() {
        for (var item in prize) {
          ticketList.add(item);
        }
        ticketList.removeRange(6, 35);
      });
    }
    if (ref.watch(selectedTicketReport) == 'box-k') {
      setState(() {
        ticketList = _getPermutation(prize[0]);
      });
    }
    if (ref.watch(selectedTicketReport) == 'ab') {
      setState(() {
        ticketList.add(prize[0].toString().substring(0, 2));
      });
    }
    if (ref.watch(selectedTicketReport) == 'bc') {
      setState(() {
        ticketList.add(prize[0].toString().substring(1, 3));
      });
    }
    if (ref.watch(selectedTicketReport) == 'ac') {
      setState(() {
        ticketList.add(
            '${prize[0].toString().substring(0, 1)}${prize[0].toString().substring(2, 3)}');
      });
    }
    if (ref.watch(selectedTicketReport) == 'a') {
      setState(() {
        ticketList.add(prize[0].toString().substring(0, 1));
      });
    }
    if (ref.watch(selectedTicketReport) == 'b') {
      setState(() {
        ticketList.add(prize[0].toString().substring(1, 2));
      });
    }
    if (ref.watch(selectedTicketReport) == 'c') {
      setState(() {
        ticketList.add(prize[0].toString().substring(2, 3));
      });
    }
    hideLoadingIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prize Result',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
        actions: [
          IconButton(
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(text: shareResult('share')),
              );
            },
            icon: const Image(
              image: AssetImage('assets/images/whatsapp.png'),
              height: 25,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Form(
              key: _globalFormKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: PlayDropdownListReport(),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TicketDropDownReport(),
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
                          'FETCH',
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
            SizedBox(
              height: 15,
            ),
            ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: ticketList.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 50,
                  child: Card(
                    color: Theme.of(context).myBlueColorLight,
                    child: ListTile(
                      title: Center(
                        child: Text(
                          '${index + 1}\t:\t${ticketList[index].toString()}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (ref.watch(selectedTicketReport) == 'king')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    shareResult('show'),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
