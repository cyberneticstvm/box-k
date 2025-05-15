import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  Item({
    required this.ticket,
    required this.userId,
    required this.play,
    required this.number,
    required this.count,
    required this.rate,
    required this.total,
    required this.playDate,
    required this.createdAt,
  });
  final String ticket;
  final String userId;
  final String play;
  final String number;
  final int count;
  final double rate;
  final num total;
  final DateTime playDate;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'ticket': ticket,
        'userId': userId,
        'play': play,
        'number': number,
        'count': count,
        'userPrice': rate,
        'total': total,
        'playDate': playDate.toString(),
        'createdAt': createdAt.toString()
      };
}

class Orderd {
  Future<void> addItemToDB(List<Item> list) async {
    List<Map<String, dynamic>> listOfMaps =
        list.map((item) => item.toJson()).toList();
    await FirebaseFirestore.instance
        .collection('orders')
        .add({'my_list': listOfMaps});
  }
}
