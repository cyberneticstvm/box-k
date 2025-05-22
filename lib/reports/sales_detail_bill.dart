import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesDetailBillReport extends ConsumerStatefulWidget {
  const SalesDetailBillReport(
      {super.key, required this.userId, required this.userName});

  final userId, userName;

  @override
  ConsumerState<SalesDetailBillReport> createState() {
    return _SalesDetailBillReportState();
  }
}

class _SalesDetailBillReportState extends ConsumerState<SalesDetailBillReport> {
  var sales = [];
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
    var orders = FirebaseFirestore.instance
        .collection('orders')
        .where('play_date',
            isGreaterThanOrEqualTo: ref.watch(selectedDateFrom),
            isLessThanOrEqualTo: ref.watch(selectedDateTo))
        .where('user_id', isEqualTo: widget.userId);
    /*if (ref.watch(enteredBillNumber) > 0) {
      orders =
          orders.where('bill_number', isEqualTo: ref.watch(enteredBillNumber));
    }*/
    if (ref.watch(selectedPlayCodeReport) != 'All') {
      orders =
          orders.where('play', isEqualTo: ref.watch(selectedPlayCodeReport));
    }
    if (ref.watch(selectedTicketReport) != 'All') {
      orders =
          orders.where('ticket', isEqualTo: ref.watch(selectedTicketReport));
    }
    final ord = await orders.get().then((snapshot) {
      return snapshot.docs;
    });
    var grouped = [{}];
    for (var item in ord) {
      var l = {
        'bill_number': item['bill_number'],
      };
      setState(() {
        grouped.add(l);
      });
    }
    var newMap = groupBy(grouped, (Map obj) => obj['bill_number']);
    var grpdBillNos = newMap.keys.nonNulls.toList();
    for (var item in grpdBillNos) {
      final data =
          await orders.where('bill_number', isEqualTo: item).get().then(
        (snapshot) {
          return snapshot.docs[0];
        },
      );
      final c = await orders
          .where('bill_number', isEqualTo: item)
          .aggregate(sum('count'))
          .get()
          .then((res) {
        return res.getSum('count');
      });
      final s = await orders
          .where('bill_number', isEqualTo: item)
          .aggregate(sum('total'))
          .get()
          .then((res) {
        return res.getSum('total');
      });
      var finalItems = {
        'bill_number': item,
        'total': s,
        'count': c,
        'cdate': data['created_at']
      };
      setState(() {
        sales.add(finalItems);
      });
    }
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
        title: Text('Sales Details Bill',
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).myBlueColorDark)),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: sales.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionTile(
              title: Text(sales[index]['bill_number'].toString()),
            );
          },
        ),
      ),
    );
  }
}
