import 'package:boxk/colors/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BillDeleteScreen extends ConsumerStatefulWidget {
  const BillDeleteScreen({super.key});
  @override
  ConsumerState<BillDeleteScreen> createState() {
    return _BillScreenState();
  }
}

class _BillScreenState extends ConsumerState<BillDeleteScreen> {
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

  Future<QuerySnapshot<Map<String, dynamic>>>? _getBills() async {
    final collection = FirebaseFirestore.instance.collection('orders').where(
        'play_date',
        isGreaterThanOrEqualTo: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    var bills = await collection.get();
    return bills;
  }

  void _delete(String docId) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Proceed?'),
          content: const Text('Are you sure want to delete this bill?'),
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
      var now = DateFormat("HH:mm:ss").format(DateTime.now());
      final play = await FirebaseFirestore.instance
          .collection('orders')
          .doc(docId)
          .get()
          .then((snapshot) async {
        return await FirebaseFirestore.instance
            .collection('plays')
            .where('code', isEqualTo: snapshot['play'])
            .where('locked_from', isGreaterThan: now)
            .get();
      });
      if (play.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(docId)
            .delete();
        _message("Bill deleted successfully!", Colors.white, Colors.green);
      } else {
        _message("Not permitted at this time!", Colors.white, Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bills',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _getBills(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No Bills found.',
                  style: TextStyle(color: Theme.of(context).myRedColorDark),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).myBlueColorDark),
              );
            }
            return SizedBox(
              child: DataTable(
                columnSpacing: MediaQuery.of(context).size.height * .03,
                columns: const [
                  DataColumn(label: Text('Bill No.')),
                  DataColumn(label: Text('Play')),
                  DataColumn(label: Text('Ticket')),
                  DataColumn(label: Text('Number')),
                  DataColumn(label: Text('Count')),
                  DataColumn(label: Text('Delete')),
                ],
                rows: snapshot.data!.docs
                    .map(
                      (item) => DataRow(
                        cells: [
                          DataCell(Text(item['bill_number'].toString())),
                          DataCell(Text(item['play'])),
                          DataCell(Text(item['ticket'])),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
