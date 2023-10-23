import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twelve_x_bull/home/betting_popup.dart';
import 'package:twelve_x_bull/home/drawer.dart';
import 'package:twelve_x_bull/otp.dart';
import 'package:twelve_x_bull/profile/profile_page.dart';
import 'package:twelve_x_bull/profile/setting_page.dart';
import 'package:http/http.dart' as http;
import 'package:twelve_x_bull/transaction/add_money.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  List<Metals> metalslist = [];
  Future<List<Metals>> getMetals() async {
    final response = await http.get(Uri.parse(
        'https://12xbull.foundercodes.com/admin/api/Mobile_app/get_metel'));
    var data = jsonDecode(response.body.toString())['data'];
    if (response.statusCode == 200) {
      metalslist.clear();
      for (var o in data) {
        Metals abcd = Metals(
          metel_type: o["metel_type"],
          meteltypehindi: o["meteltypehindi"],
          metal_icon: o["metal_icon"],
          id: o["id"],
        );
        metalslist.add(abcd);
      }
      return metalslist;
    } else {
      return metalslist;
    }
  }


  void initState() {
    viewprofile();
    super.initState();
  }
  var map;
  Future viewprofile() async {
    final prefs = await SharedPreferences.getInstance();
    final userid=prefs.getString("userId");
    final response = await http.get(
      Uri.parse("https://12xbull.foundercodes.com/admin/api/Mobile_app/get?id=$userid"),
    );
    var data = jsonDecode(response.body);
    print(data);
    print("mmmmmmmmmmmmmmm");
    if (data['success'] == '200') {
      setState(() {
        map =data['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272139),
      appBar: AppBar(
        backgroundColor: Color(0xff272139),
        centerTitle: true,
        // leading: Image.asset('assets/images/img.png'),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Money()));
            },
            child: Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.account_balance_wallet_rounded),
                  map == null
                      ? Text("₹")
                      : Text(
                    map['wallet'].toString(),
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          )
        ],
        title: Text(
          '12xBull',
          style: TextStyle(fontSize: 30),
        ),
        elevation: 0,
      ),
      drawer: Drawer_Page(),

      body: RefreshIndicator(
        onRefresh: (){
          return Future.delayed(Duration(seconds: 1),
                  (){
                setState(() {
                });
              }
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: [
              Divider(
                thickness: 1.5,
                color: Colors.white,
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  map==null?'Name':
                  'welcome '+ map['name'].toString()+',',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffd2b086), Color(0xff594f43)]),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.white),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/gold.png'),
                    ),
                    Text(
                      'Gold is Winner',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Image.asset('assets/images/winner.gif')
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1.5,
                color: Colors.white,
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.53,
                child: FutureBuilder<List<Metals>>(
                    future: getMetals(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: InkWell(
                                onTap: (){
                                   showDialog(
                                     context: context,
                                     builder: (BuildContext context) => betting_Popup(
                                         snapshot.data![index]
                                     ),
                                   );

                                 },
                                  child: Container(
                                    height: 70,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      // gradient: LinearGradient(
                                      //     begin: Alignment.topLeft,
                                      //     end: Alignment.bottomRight,
                                      //     stops: [0.1, 0.3, 0.7, 1],
                                      //     colors: [Color(0xff5a268a), Color(0xff765e8d), Color(0xffd7c3eb), Color(0xff421d64)]),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2, color: Colors.white),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://12xbull.foundercodes.com/admin/uploads/" +
                                                  snapshot.data![index].metal_icon
                                                      .toString()),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data![index].metel_type
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data![index].meteltypehindi
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                            height: 60,
                                            width: 60,
                                            child: Image.asset(
                                                'assets/images/graph.png')),
                                        Text(
                                          '100',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }


}





class Metals {
  String metel_type;
  String meteltypehindi;
  String metal_icon;
  String id;

  Metals(
     {required this.metel_type, required this.meteltypehindi, required this.metal_icon,required this.id});
}
