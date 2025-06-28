import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/user.dart';
import 'package:boxk/screens/play_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PlayScreen extends ConsumerStatefulWidget {
  const PlayScreen({super.key});

  @override
  ConsumerState<PlayScreen> createState() {
    return _PlayScreenState();
  }
}

class _PlayScreenState extends ConsumerState<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plays',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('plays')
              .where('name', isNotEqualTo: 'All')
              .orderBy('id')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No plays found.'),
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
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Code')),
                  DataColumn(label: Text('L.From')),
                  DataColumn(label: Text('L.To')),
                  DataColumn(label: Text('Edit')),
                ],
                rows: snapshot.data!.docs
                    .map(
                      (item) => DataRow(
                        cells: [
                          DataCell(Text(item['id'].toString())),
                          DataCell(Text(item['name'])),
                          DataCell(Text(item['code'])),
                          DataCell(Text(TimeOfDay.fromDateTime(
                                  DateFormat('HH:mm:ss')
                                      .parse(item['locked_from']))
                              .format(context))),
                          DataCell(Text(TimeOfDay.fromDateTime(
                                  DateFormat('HH:mm:ss')
                                      .parse(item['locked_to']))
                              .format(context))),
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
                                        builder: (ctx) => PlayEditScreen(
                                          playId: item['id'],
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
              ),
            );
          },
        ),
      ),
    );
  }
}
