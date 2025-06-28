import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/user.dart';
import 'package:boxk/screens/scheme_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchemeScreen extends ConsumerStatefulWidget {
  const SchemeScreen({super.key});

  @override
  ConsumerState<SchemeScreen> createState() {
    return _SchemeScreenState();
  }
}

class _SchemeScreenState extends ConsumerState<SchemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schemes',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('schemes')
              .orderBy('ticket')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No schemes found.'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).myBlueColorDark),
              );
            }
            return DataTable(
              columnSpacing: MediaQuery.of(context).size.height * .025,
              columns: const [
                DataColumn(label: Text('Ticket')),
                DataColumn(label: Text('Position')),
                DataColumn(label: Text('Count')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Super')),
                DataColumn(label: Text('Edit')),
              ],
              rows: snapshot.data!.docs
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(Text(item['ticket'])),
                        DataCell(Text(item['position'].toString())),
                        DataCell(Text(item['count'].toString())),
                        DataCell(Text(item['amount'].toString())),
                        DataCell(Text(item['super'].toString())),
                        (ref.watch(currentUserProvider)['role'] == 'Admin')
                            ? DataCell(
                                Icon(
                                  Icons.edit,
                                  color: Theme.of(context).myAmberColorDark,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => SchemeEditScreen(
                                        docId: item.id,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : DataCell(Text('')),
                      ],
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
