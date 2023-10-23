import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BetingHistory extends StatefulWidget {
  const BetingHistory({Key? key}) : super(key: key);

  @override
  State<BetingHistory> createState() => _BetingHistoryState();
}

class _BetingHistoryState extends State<BetingHistory>
    with TickerProviderStateMixin {
  List<Trans> translist = [];
  Future<List<Trans>> getTrans() async {
    final prefs = await SharedPreferences.getInstance();
    final userid=prefs.getString("userId");
    final response = await http.get(
        Uri.parse('https://12xbull.foundercodes.com/admin/api/Mobile_app/bet?id=$userid'));
    var data = jsonDecode(response.body.toString())['data'];
    if (response.statusCode == 200) {
      translist.clear();
      for (var o in data) {
        Trans abcd = Trans(
          o["id"],
          o["user_id"],
          o["gameid"],
          o["metel_type"],
          o["amount"],
          o["betdate"],
          o["bettime"],
          o["winstatus"],
        );
        translist.add(abcd);
      }
      return translist;
    } else {
      return translist;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272139),

      // TransactionBar: TransactionBar(),
      body: FutureBuilder<List<Trans>>(
          future: getTrans(),
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
                          MainAxisAlignment.spaceEvenly,
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
                                  snapshot.data![index].metelType
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
                                ),
                                Text("Bet Date "+
                                  snapshot.data![index].betdate
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                Text("Bet Time " +
                                  snapshot.data![index].bettime
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Text(
                                snapshot.data![index].winstatus
                                    .toString(),
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

// class Trans {
//   String amount;
//   String gamename;
//   String betdate;
//   String total;
//
//   Trans({
//     required this.amount,
//     required this.gamename,
//     required this.betdate,
//     required this.total,
//   });
// }


class Trans{
  String? id;
  String? user_id;
  String? gameid;
  String? metelType;
  String? amount;
  String? betdate;
  String? bettime;
  String? winstatus;

  Trans(
        this.id,
        this.user_id,
        this.gameid,
        this.metelType,
        this.amount,
        this.betdate,
        this.bettime,
        this.winstatus);
}
