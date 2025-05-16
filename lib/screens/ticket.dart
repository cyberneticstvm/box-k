import 'package:boxk/colors/color.dart';
import 'package:boxk/screens/ticket_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketScreen extends ConsumerStatefulWidget {
  const TicketScreen({super.key});

  @override
  ConsumerState<TicketScreen> createState() {
    return _TicketScreenState();
  }
}

class _TicketScreenState extends ConsumerState<TicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tickets',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('tickets')
              .orderBy('id')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No tickets found.'),
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
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('A.Rate')),
                DataColumn(label: Text('L.Rate')),
                DataColumn(label: Text('U.Rate')),
                DataColumn(label: Text('Count')),
                DataColumn(label: Text('Edit')),
              ],
              rows: snapshot.data!.docs
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(Text(item['id'].toString())),
                        DataCell(Text(item['name'])),
                        DataCell(Text(item['admin_rate'].toString())),
                        DataCell(Text(item['leader_rate'].toString())),
                        DataCell(Text(item['user_rate'].toString())),
                        DataCell(Text(item['max_count'].toString())),
                        DataCell(
                          Icon(
                            Icons.edit,
                            color: Theme.of(context).myAmberColorDark,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => TicketEditScreen(
                                  docId: item.id,
                                ),
                              ),
                            );
                          },
                        ),
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
