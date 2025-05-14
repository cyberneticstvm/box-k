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
