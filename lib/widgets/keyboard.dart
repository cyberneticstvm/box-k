import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/item.dart';
import 'package:boxk/providers/order.dart';
import 'package:boxk/providers/page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class KeyboardWidget extends ConsumerStatefulWidget {
  const KeyboardWidget({super.key});

  @override
  ConsumerState<KeyboardWidget> createState() {
    return _KeyboardWidgetState();
  }
}

class _KeyboardWidgetState extends ConsumerState<KeyboardWidget> {
  TextEditingController activeController = TextEditingController();
  final countController = TextEditingController();
  final numberController = TextEditingController();
  final fromNumberController = TextEditingController();
  final toNumberController = TextEditingController();
  final FocusNode countFieldFocusNode = FocusNode();
  final FocusNode toNumberFocusNode = FocusNode();
  final FocusNode fromNumberFocusNode = FocusNode();
  late FocusNode numberFocusNode;

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

  void _buttonPressed(int number) {
    final selNumSet = ref.watch(selectedNumberSet);
    final selNumGrp = ref.watch(selectedNumberGroup);

    if (activeController == numberController &&
        activeController.text.length == selNumGrp &&
        (selNumSet == 0 || selNumSet == 1)) {
      setState(() {
        FocusScope.of(context).requestFocus(countFieldFocusNode);
        activeController = countController;
      });
    }
    if (activeController == fromNumberController &&
        activeController.text.length == selNumGrp &&
        selNumSet > 1) {
      setState(() {
        FocusScope.of(context).requestFocus(toNumberFocusNode);
        activeController = toNumberController;
      });
    }
    if (activeController == toNumberController &&
        activeController.text.length == selNumGrp &&
        selNumSet > 1) {
      setState(() {
        FocusScope.of(context).requestFocus(countFieldFocusNode);
        activeController = countController;
      });
    }
    if (activeController.text.length < 3) {
      setState(() {
        activeController.text += number.toString();
      });
    }
  }

  void _add() async {
    if (ref.watch(isPlayBlocked)) {
      _message('Play has been locked', Colors.white,
          Theme.of(context).myRedColorDark);
      return;
    }
    if (ref.watch(selectedNumberSet) == 0 ||
        ref.watch(selectedNumberSet) == 1) {
      if (numberController.text.length != ref.watch(selectedNumberGroup)) {
        _message('Please Enter Valid Number', Colors.white,
            Theme.of(context).myRedColorDark);
        return;
      }
    } else {
      if (fromNumberController.text.length != ref.watch(selectedNumberGroup)) {
        _message('Please Enter Valid Start Number', Colors.white,
            Theme.of(context).myRedColorDark);
        return;
      }
      if (toNumberController.text.length != ref.watch(selectedNumberGroup)) {
        _message('Please Enter Valid End Number', Colors.white,
            Theme.of(context).myRedColorDark);
        return;
      }
    }
    if (countController.text.isEmpty || countController.text == '') {
      _message('Please Enter Valid Count', Colors.white,
          Theme.of(context).myRedColorDark);
      return;
    }
    List ticketList;
    var number = [];
    int count = int.parse(countController.text);
    if (ref.watch(selectedNumberSet) == 0) {
      number.add(numberController.text);
    }
    if (ref.watch(selectedNumberSet) == 1) {
      number = _getPermutation(numberController.text);
    }
    if (ref.watch(selectedNumberSet) == 2 ||
        ref.watch(selectedNumberSet) == 3 ||
        ref.watch(selectedNumberSet) == 4) {
      var start = int.parse(fromNumberController.text);
      var end = int.parse(toNumberController.text);
      if (start < end || start == end) {
        if (ref.watch(selectedNumberSet) == 2) {
          for (int i = start; i <= end; i++) {
            number.add(i.toString());
          }
        } else {
          if (ref.watch(selectedNumberSet) == 3) {
            for (int i = start; i <= end; i += 100) {
              number.add(i.toString());
            }
          } else {
            for (int i = start; i <= end; i += 111) {
              number.add(i.toString());
            }
          }
        }
      } else {
        _message('Please Enter Valid Start and End Number', Colors.white,
            Theme.of(context).myRedColorDark);
        return;
      }
    }
    if (ref.watch(selectedNumberGroup) == 3 &&
        ref.watch(selectedTicket) == 'all') {
      ticketList = ['king', 'box-k'];
    } else if (ref.watch(selectedNumberGroup) == 2 &&
        ref.watch(selectedTicket) == 'all') {
      ticketList = ['ab', 'bc', 'ac'];
    } else if (ref.watch(selectedNumberGroup) == 1 &&
        ref.watch(selectedTicket) == 'all') {
      ticketList = ['a', 'b', 'c'];
    } else {
      ticketList = [ref.watch(selectedTicket)];
    }
    final btc = await FirebaseFirestore.instance
        .collection('blocked_numbers')
        .where('number', whereIn: number)
        .aggregate(sum("count"))
        .get()
        .then((res) {
      return res.getSum('count');
    }); // Blocked Ticket Count
    final btco = await FirebaseFirestore.instance
        .collection('orders')
        .where('number', whereIn: number)
        .where('play', isEqualTo: ref.watch(selectedPlayCode))
        .where('play_date', isEqualTo: ref.watch(playDate))
        .aggregate(sum("count"))
        .get()
        .then((res) {
      return res.getSum('count');
    }); // Blocked Ticket Count Ordered

    final tickets = FirebaseFirestore.instance.collection('tickets');
    final rate = await tickets.where('name', whereIn: ticketList).get().then(
      (snapshot) {
        return snapshot.docs.toList();
      },
    );
    /*double ticketRate = double.parse(item['user_rate']);
      if (ref.watch(selectedUserProvider)['role'] == 'Admin') {
        ticketRate = double.parse(item['admin_rate']);
      }
      if (ref.watch(selectedUserProvider)['role'] == 'Leader') {
        ticketRate = double.parse(item['leader_rate']);
      }*/
    number.sort((b, a) => a.compareTo(b)); // Sorting descending
    for (var item in rate) {
      for (var n in number) {
        ref.read(itemAddProvider.notifier).addItem(
              (ref.watch(selectedNumberGroup) == 3 &&
                          ref.watch(selectedTicket) != 'box-k' &&
                          ref.watch(selectedTicket) != 'all' ||
                      item['name'] == 'king')
                  ? ref.watch(selectedPlayCode)
                  : item['name'],
              ref.watch(selectedUser).toString(),
              ref.watch(selectedPlayCode),
              n,
              count,
              double.parse(item['user_rate'].toString()),
              double.parse((count * item['user_rate']).toStringAsFixed(2)),
              ref.watch(playDate),
              DateTime.now(),
            );
      }
    }
    _clearForm();
  }

  Future<void> _save() async {
    final items = ref.watch(itemAddProvider);
    if (items.isEmpty) {
      _message(
          'Items are empty.', Colors.white, Theme.of(context).myRedColorDark);
      return;
    }
    try {
      final result = await showDialog(
        context: (mounted) ? context : context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Proceed?'),
            content: const Text('Are you sure want to proceed?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).myRedColorDark,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Save',
                  style: TextStyle(color: Theme.of(context).myGreenColorDark),
                ),
              ),
            ],
          );
        },
      );
      if (result) {
        //Orderd().addItemToDB(items);
        for (var item in items) {
          final Map<String, dynamic> itemMap = {
            "ticket": item.ticket,
            "user_id": item.userId,
            "play": item.play,
            "number": item.number,
            "count": item.count,
            "rate": item.rate,
            "total": item.total,
            "play_date": item.playDate,
            "created_at": item.createdAt,
          };
          FirebaseFirestore.instance.collection('orders').add(itemMap);
        }
        _message("Order saved successfully", Colors.white, Colors.green);
        _clearForm();
        ref.invalidate(itemListCountProvider);
        ref.invalidate(itemListAmountProvider);
        ref.invalidate(itemAddProvider);
      }
    } catch (err) {
      _message(
        err.toString(),
        Colors.white,
        Color(0xFFEA4335),
      );
    }
  }

  void _clearForm() {
    numberController.clear();
    fromNumberController.clear();
    toNumberController.clear();
    countController.clear();
    FocusScope.of(context).requestFocus(numberFocusNode);
    activeController = numberController;
  }

  void _clearProviders() {
    ref.invalidate(selectedNumberGroup);
    ref.invalidate(selectedNumberSet);
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

  @override
  void dispose() {
    /*countController.dispose();
    numberController.dispose();
    fromNumberController.dispose();
    toNumberController.dispose();
    activeController.dispose();*/
    countFieldFocusNode.dispose();
    toNumberFocusNode.dispose();
    fromNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    numberFocusNode = FocusNode();
    activeController = numberController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.432,
      color: Theme.of(context).myBlueColorLight,
      child: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            if (ref.watch(selectedNumberGroup) == 3)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(selectedTicket.notifier)
                            .update((satate) => 'king');
                        _add();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Theme.of(context).myAmberColorDark,
                      ),
                      child: Text(
                        ref.watch(selectedPlayCode).toUpperCase(),
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(selectedTicket.notifier)
                            .update((satate) => 'box-k');
                        _add();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Theme.of(context).myGreenColorDark,
                      ),
                      child: const Text(
                        'BOX-K',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(selectedTicket.notifier)
                            .update((satate) => 'all');
                        _add();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Theme.of(context).myRedColorDark,
                      ),
                      child: const Text(
                        'ALL',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (ref.watch(selectedNumberGroup) == 2)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(selectedTicket.notifier)
                            .update((satate) => 'ab');
                        _add();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Theme.of(context).myAmberColorDark,
                      ),
                      child: const Text(
                        'AB',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(selectedTicket.notifier)
                            .update((satate) => 'bc');
                        _add();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Theme.of(context).myGreenColorDark,
                      ),
                      child: const Text(
                        'BC',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(selectedTicket.notifier)
                            .update((satate) => 'ac');
                        _add();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Theme.of(context).myPurpleColorDark,
                      ),
                      child: const Text(
                        'AC',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(selectedTicket.notifier)
                            .update((satate) => 'all');
                        _add();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Theme.of(context).myRedColorDark,
                      ),
                      child: const Text(
                        'ALL',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (ref.watch(selectedNumberGroup) == 1)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(selectedTicket.notifier)
                            .update((satate) => 'a');
                        _add();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Theme.of(context).myAmberColorDark,
                      ),
                      child: const Text(
                        'A',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(selectedTicket.notifier)
                            .update((satate) => 'b');
                        _add();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Theme.of(context).myGreenColorDark,
                      ),
                      child: const Text(
                        'B',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(selectedTicket.notifier)
                            .update((satate) => 'c');
                        _add();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Theme.of(context).myPurpleColorDark,
                      ),
                      child: const Text(
                        'C',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(selectedTicket.notifier)
                            .update((satate) => 'all');
                        _add();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Theme.of(context).myRedColorDark,
                      ),
                      child: const Text(
                        'ALL',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                if (ref.watch(selectedNumberSet) == 0 ||
                    ref.watch(selectedNumberSet) == 1)
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        autofocus: true,
                        controller: numberController,
                        keyboardType: TextInputType.none,
                        textAlign: TextAlign.center,
                        maxLength: 3,
                        focusNode: numberFocusNode,
                        onTap: () {
                          setState(() {
                            activeController = numberController;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Number',
                          counterText: '',
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                if (ref.watch(selectedNumberSet) > 1)
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: fromNumberController,
                        focusNode: fromNumberFocusNode,
                        keyboardType: TextInputType.none,
                        textAlign: TextAlign.center,
                        maxLength: 3,
                        onTap: () {
                          setState(() {
                            activeController = fromNumberController;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Start',
                          counterText: '',
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                if (ref.watch(selectedNumberSet) > 1)
                  const SizedBox(
                    width: 5,
                  ),
                if (ref.watch(selectedNumberSet) > 1)
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: toNumberController,
                        focusNode: toNumberFocusNode,
                        keyboardType: TextInputType.none,
                        textAlign: TextAlign.center,
                        maxLength: 3,
                        onTap: () {
                          setState(() {
                            activeController = toNumberController;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'End',
                          counterText: '',
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: TextField(
                      controller: countController,
                      focusNode: countFieldFocusNode,
                      keyboardType: TextInputType.none,
                      textAlign: TextAlign.center,
                      maxLength: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Count',
                        counterText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onTap: () {
                        setState(() {
                          activeController = countController;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: OutlinedButton(
                      onPressed: () {
                        _buttonPressed(1);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: OutlinedButton(
                      onPressed: () {
                        _buttonPressed(2);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: const Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: OutlinedButton(
                      onPressed: () {
                        _buttonPressed(3);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: TextButton(
                      onPressed: () {
                        if (activeController.text.isNotEmpty) {
                          setState(() {
                            activeController.text = activeController.text
                                .substring(0, activeController.text.length - 1);
                          });
                        }
                      },
                      child: const Icon(
                        Icons.backspace,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: OutlinedButton(
                      onPressed: () {
                        _buttonPressed(4);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: const Text(
                        '4',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: OutlinedButton(
                      onPressed: () {
                        _buttonPressed(5);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: const Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: OutlinedButton(
                      onPressed: () {
                        _buttonPressed(6);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: const Text(
                        '6',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: TextButton(
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Proceed?'),
                              content: const Text(
                                  'Are you sure want to clear items?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color(0xFFEA4335),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text(
                                    'Clear',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (result) {
                          ref.invalidate(itemAddProvider);
                          _clearForm();
                        }
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: OutlinedButton(
                      onPressed: () {
                        _buttonPressed(7);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: const Text(
                        '7',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: OutlinedButton(
                      onPressed: () {
                        _buttonPressed(8);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: const Text(
                        '8',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: OutlinedButton(
                      onPressed: () {
                        _buttonPressed(9);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: const Text(
                        '9',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: TextButton(
                      onPressed: () {},
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: TextButton(
                      onPressed: () {
                        ref.read(selectedPage.notifier).update((state) => 4);
                        ref.invalidate(itemAddProvider);
                        _clearForm();
                        _clearProviders();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: OutlinedButton(
                      onPressed: () {
                        _buttonPressed(0);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        side: const BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: const Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: IconButton(
                      onPressed: () {
                        //
                      },
                      icon: const Icon(
                        Icons.dialpad,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        _save();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Colors.black,
                      ),
                      child: Text(
                        'SAVE',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
