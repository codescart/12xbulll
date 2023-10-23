import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawlHistory extends StatefulWidget {
  const WithdrawlHistory({Key? key}) : super(key: key);

  @override
  State<WithdrawlHistory> createState() => _WithdrawlHistoryState();
}

class _WithdrawlHistoryState extends State<WithdrawlHistory>
    with TickerProviderStateMixin {
   List<Withdraw> withdrawlist = [];
  Future<List<Withdraw>> getWithdraw() async {

    final prefs = await SharedPreferences.getInstance();
    final userid=prefs.getString("userId");
    final response = await http.get(
        Uri.parse('https://12xbull.foundercodes.com/admin/api/Mobile_app/getwithdrawl?user_id=$userid'));
    var data = jsonDecode(response.body.toString())['data'];
    if (response.statusCode == 200) {
      withdrawlist.clear();
      for (var o in data) {
        Withdraw abcd = Withdraw(
          amount: o["amount"],
          account_number: o["account_number"],
          ifsc_code: o["ifsc_code"],
          upi: o["upi"],
          date: o["date"],
          name: o["name"],
        );
        withdrawlist.add(abcd);
      }
      return withdrawlist;
    } else {
      return withdrawlist;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272139),

      // WithdrawactionBar: WithdrawactionBar(),
      body: FutureBuilder<List<Withdraw>>(
          future: getWithdraw(),
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
                        height: 90,
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
                                Text("A/c - " +
                                  snapshot.data![index].account_number
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                Text("IFSC - " +
                                  snapshot.data![index].ifsc_code
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                Text("UPI " +
                                  snapshot.data![index].upi
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                Text("Date " +
                                    snapshot.data![index].date
                                        .toString(),
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                Text("Name " +
                                    snapshot.data![index].name
                                        .toString(),
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Text("status",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
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

class Withdraw {
  String amount;
  String account_number;
  String ifsc_code;
  String upi;
  String date;
  String name;

  Withdraw({
    required this.amount,
    required this.account_number,
    required this.ifsc_code,
    required this.upi,
    required this.date,
    required this.name,
  });
}

