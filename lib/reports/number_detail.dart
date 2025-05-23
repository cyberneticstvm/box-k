import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberWiseDetailReport extends ConsumerStatefulWidget {
  const NumberWiseDetailReport({super.key});

  @override
  ConsumerState<NumberWiseDetailReport> createState() {
    return _NumberWiseDetailReportState();
  }
}

class _NumberWiseDetailReportState
    extends ConsumerState<NumberWiseDetailReport> {
  var sales = [];
  double count = 0.0;
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

  getData() async {
    showLoadingIndicator();
    bool isTicketNo = false;
    var orders = FirebaseFirestore.instance
        .collection('orders')
        .where('play_date', isEqualTo: ref.watch(selectedDateFrom));
    if (ref.watch(selectedPlayCodeReport) != 'All') {
      orders =
          orders.where('play', isEqualTo: ref.watch(selectedPlayCodeReport));
    }
    if (ref.watch(selectedTicketReport) != 'All') {
      isTicketNo = true;
      orders =
          orders.where('ticket', isEqualTo: ref.watch(selectedTicketReport));
    }
    if (ref.watch(enteredTicketNumber) != '') {
      orders =
          orders.where('number', isEqualTo: ref.watch(enteredTicketNumber));
    }
    final ord = await orders.get().then((snapshot) {
      return snapshot.docs;
    });
    var grouped = [{}];
    for (var item in ord) {
      var l = {
        'number': item['number'],
        'ticket': item['ticket'],
        'numt': '${item['number']}_${item['ticket']}',
      };
      setState(() {
        grouped.add(l);
      });
    }
    var newMap = groupBy(grouped, (Map obj) => obj['numt']);
    var grpdNos = newMap.keys.nonNulls.toList();
    Query<Map<String, dynamic>> numberTot;
    for (var item in grpdNos) {
      int idx = item.toString().indexOf('_');
      List parts = [
        item.toString().substring(0, idx).trim(),
        item.toString().substring(idx + 1).trim()
      ];
      if (isTicketNo) {
        numberTot = orders;
      } else {
        numberTot = orders.where('number', isEqualTo: parts[0]);
      }
      final c = await numberTot.aggregate(sum('count')).get().then((res) {
        return res.getSum('count');
      });
      var finalItems = {
        'ticket': parts[1],
        'number': parts[0],
        'count': c,
      };
      setState(() {
        sales.add(finalItems);
        count = count + double.parse(c.toString());
      });
    }
    sales.sort((b, a) => a['ticket'].compareTo(b['ticket']));
    hideLoadingIndicator();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Number Details Report',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
        actions: [
          Text('$count\t',
              style: TextStyle(
                color: Theme.of(context).myGreenColorDark,
                fontSize: 18,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Ticket')),
            DataColumn(label: Text('Number')),
            DataColumn(label: Text('Count')),
          ],
          rows: sales
              .map(
                (item) => DataRow(
                  cells: [
                    DataCell(Text(item['ticket'])),
                    DataCell(Text(item['number'])),
                    DataCell(
                      Text(item['count'].toString()),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
