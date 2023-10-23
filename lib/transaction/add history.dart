import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddHistory extends StatefulWidget {
  const AddHistory({Key? key}) : super(key: key);

  @override
  State<AddHistory> createState() => _AddHistoryState();
}

class _AddHistoryState extends State<AddHistory>
    with TickerProviderStateMixin {
  List<Add> Addlist = [];
  Future<List<Add>> getAdd() async {
    final prefs = await SharedPreferences.getInstance();
    final userid=prefs.getString("userId");
    final response = await http.get(
        Uri.parse('https://12xbull.foundercodes.com/admin/api/Mobile_app/payinuserlist?user_id=$userid'));
    var data = jsonDecode(response.body.toString())['data'];
    if (response.statusCode == 200) {
      Addlist.clear();
      for (var o in data) {
        Add abcd = Add(
          amount: o["amount"],
          upi: o["upi"],
          date: o["date"],
          time: o["time"],
        );
        Addlist.add(abcd);
      }
      return Addlist;
    } else {
      return Addlist;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272139),

      // TransactionBar: TransactionBar(),
      body: FutureBuilder<List<Add>>(
          future: getAdd(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                // scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        height: 80,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            Text("₹ "+
                              snapshot.data![index].amount.toString(),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  snapshot.data![index].upi
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                Text(
                                  snapshot.data![index].date
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                Text(
                                  snapshot.data![index].time
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Text("Status"),
                          ],
                        )),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class Add {
  String amount;
  String upi;
  String date;
  String time;

  Add({
    required this.amount,
    required this.upi,
    required this.date,
    required this.time,
  });
}

