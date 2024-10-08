import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:movison/screens/Home/HomeScreen.dart';
import 'package:movison/screens/Home/TimeLeftOrOver.dart';
import 'package:movison/size_config.dart';



String name = "";
int maxLength = 3;
class BookPurchasedetails extends StatefulWidget {
  //var product;

  BookPurchasedetails({Key? key}) : super(key: key);

  @override
  State<BookPurchasedetails> createState() => _BookPurchasedetailsState();
}

class _BookPurchasedetailsState extends State<BookPurchasedetails> {
  final startDateTime = DateTime.now();
  DateTime endDateTime = DateTime(2023, 4, 10, 10, 0, 0);
  late Timer _timer;
  Duration _duration = const Duration();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateCountdown);
    _updateCountdown(_timer);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateCountdown(Timer timer) {
    setState(() {
      final now = DateTime.now();
      if (now.isAfter(endDateTime)) {
        _duration = const Duration();
        _timer.cancel();
      } else {
        _duration = endDateTime.difference(now);
        print("jnfkjnjf " + _duration.toString());
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    DateFormat inputFormat = DateFormat('dd-MM-yyyy hh:mm a');
    return Scaffold(
      
      body: SafeArea(
        child:Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  hintText: 'Search for product',
                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('StudentDetails').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // ... Rest of your code
                  if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    endDateTime = inputFormat.parse(
                        "${snapshot.data?.docs[index]['return_date']} ${snapshot.data?.docs[index]['End_Time']}");
                    var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    if (name.isEmpty) {
                      print("Lenght : ${snapshot.data!.docs.length}");
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TimeLeftOrOver(
                                    productId: snapshot.data!.docs[index].id,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                             child: Card(
                      elevation: 4, // Add elevation for a raised effect
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),

                    
                      child: Container(
                          //margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          // height: 200,
                          // color: Colors.amberAccent,
                          height: MediaQuery.of(context).size.height * 1 / 3.8,
                          width: MediaQuery.of(context).size.width * 1 / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              // gradient: LinearGradient(
                              //     colors: [Color(0xFF846AFF), Color(0xFF755EE8), Colors.purpleAccent,Colors.amber,],
                              //     begin: Alignment.topLeft,
                              //     end: Alignment.bottomRight)),
                              color: const Color(0xFFF5F6F9)),

                          child: SingleChildScrollView(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               Row(
                                  children: [
                                // IconBtnWithCounter(
                                //   svgSrc: "assets/icons/User.svg",
                                //   press: () {},
                                // ),
                                CategoryCard1(icon: "assets/icons/User.svg", press: () {  },),
                                
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "Name : " + snapshot.data?.docs[index]['name'],
                                    style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                                    maxLines: 1, // Ensure the text doesn't exceed the available space
                                    overflow: TextOverflow.ellipsis, // Handle long text
                                  ),
                                ),
                                ],
                              ),

                                
                                // Text(
                                //   "Name : " + snapshot.data?.docs[index]['name'],
                                //   style: TextStyle(color: Colors.white, fontSize: 17,fontFamily: "monospace"),
                                // ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // Text(
                                //   "Product : " + snapshot.data?.docs[index]['Product'],
                                //   style: TextStyle(color: Colors.white, fontSize: 17,fontFamily: "monospace"),
                                // ),
                              Row(
                                  children: [
                                // IconBtnWithCounter(
                                //   svgSrc: "assets/icons/User.svg",
                                //   press: () {},
                                // ),
                                CategoryCard1(icon: "assets/icons/Gift Icon.svg", press: () {  },),
                                
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child:Text(
                                  "BookPublication : " + snapshot.data?.docs[index]['publication'],
                                   style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                                
                                    maxLines: 1, // Ensure the text doesn't exceed the available space
                                    overflow: TextOverflow.ellipsis, // Handle long text
                                  ),
                                ),
                                ],
                              ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // Text(
                                //   "${"Quantity : " + snapshot.data?.docs[index]['Quantity in KG']} kg",
                                //   style: TextStyle(color: Colors.white, fontSize: 17,fontFamily: "monospace"),
                                // ),
                              Row(
                                  children: [
                                // IconBtnWithCounter(
                                //   svgSrc: "assets/icons/User.svg",
                                //   press: () {},
                                // ),
                                CategoryCard1(icon: "assets/icons/Bill Icon.svg", press: () {  },),
                                
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child:Text(
                                  "${"Date Of Deal: " + snapshot.data?.docs[index]['purchase_date']} ",
                                  style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                                  maxLines: 1, // Ensure the text doesn't exceed the available space
                                  overflow: TextOverflow.ellipsis,
                                ),
                                ),
                                ],
                              ),
                                const SizedBox(
                                  height: 5,
                                ),
                               
                              Row(
                                  children: [
                                // IconBtnWithCounter(
                                //   svgSrc: "assets/icons/User.svg",
                                //   press: () {},
                                // ),
                                CategoryCard1(icon: "assets/icons/clock2.svg", press: () {  },),
                                
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child:Text(
                                  "Return Time: ${snapshot.data?.docs[index]['return_date']}",
                                  style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                                
                                  maxLines: 1, // Ensure the text doesn't exceed the available space
                                    overflow: TextOverflow.ellipsis,
                                ),
                                ),
                                ],
                              ),

                                
                              ],
                            ),
                          ),
                        ),      
                      ),
                      )
                      );
                    }

                    if (data['publication'].toString().startsWith(name.toLowerCase()) ||
                        data['publication'].toString().startsWith(name.toUpperCase())) {
                      return  Padding(
                        padding: const EdgeInsets.all(10.0),
                        
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TimeLeftOrOver(
                                    productId: snapshot.data!.docs[index].id,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                             child: Card(
                      elevation: 4, // Add elevation for a raised effect
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),

                    
                      child: Container(
                          //margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          // height: 200,
                          // color: Colors.amberAccent,
                          height: MediaQuery.of(context).size.height * 1 / 3.8,
                          width: MediaQuery.of(context).size.width * 1 / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              // gradient: LinearGradient(
                              //     colors: [Color(0xFF846AFF), Color(0xFF755EE8), Colors.purpleAccent,Colors.amber,],
                              //     begin: Alignment.topLeft,
                              //     end: Alignment.bottomRight)),
                              color: const Color(0xFFF5F6F9)),

                          child: SingleChildScrollView(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               Row(
                                  children: [
                                // IconBtnWithCounter(
                                //   svgSrc: "assets/icons/User.svg",
                                //   press: () {},
                                // ),
                                CategoryCard1(icon: "assets/icons/User.svg", press: () {  },),
                                
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "Name : " + snapshot.data?.docs[index]['name'],
                                    style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                                    maxLines: 1, // Ensure the text doesn't exceed the available space
                                    overflow: TextOverflow.ellipsis, // Handle long text
                                  ),
                                ),
                                ],
                              ),

                                
                                // Text(
                                //   "Name : " + snapshot.data?.docs[index]['name'],
                                //   style: TextStyle(color: Colors.white, fontSize: 17,fontFamily: "monospace"),
                                // ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // Text(
                                //   "Product : " + snapshot.data?.docs[index]['Product'],
                                //   style: TextStyle(color: Colors.white, fontSize: 17,fontFamily: "monospace"),
                                // ),
                              Row(
                                  children: [
                                // IconBtnWithCounter(
                                //   svgSrc: "assets/icons/User.svg",
                                //   press: () {},
                                // ),
                                CategoryCard1(icon: "assets/icons/Gift Icon.svg", press: () {  },),
                                
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child:Text(
                                  "BookPublication : " + snapshot.data?.docs[index]['publication'],
                                   style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                                
                                    maxLines: 1, // Ensure the text doesn't exceed the available space
                                    overflow: TextOverflow.ellipsis, // Handle long text
                                  ),
                                ),
                                ],
                              ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // Text(
                                //   "${"Quantity : " + snapshot.data?.docs[index]['Quantity in KG']} kg",
                                //   style: TextStyle(color: Colors.white, fontSize: 17,fontFamily: "monospace"),
                                // ),
                              Row(
                                  children: [
                                // IconBtnWithCounter(
                                //   svgSrc: "assets/icons/User.svg",
                                //   press: () {},
                                // ),
                                CategoryCard1(icon: "assets/icons/Bill Icon.svg", press: () {  },),
                                
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child:Text(
                                  "${"Date Of Deal: " + snapshot.data?.docs[index]['purchase_date']} ",
                                  style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                                  maxLines: 1, // Ensure the text doesn't exceed the available space
                                  overflow: TextOverflow.ellipsis,
                                ),
                                ),
                                ],
                              ),
                                const SizedBox(
                                  height: 5,
                                ),
                               
                              Row(
                                  children: [
                                // IconBtnWithCounter(
                                //   svgSrc: "assets/icons/User.svg",
                                //   press: () {},
                                // ),
                                CategoryCard1(icon: "assets/icons/clock2.svg", press: () {},),
                                
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child:Text(
                                  "Return Time: ${snapshot.data?.docs[index]['return_date']}",
                                  style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                                
                                  maxLines: 1, // Ensure the text doesn't exceed the available space
                                    overflow: TextOverflow.ellipsis,
                                ),
                                ),
                                ],
                              ),

                                
                              ],
                            ),
                          ),
                        ),      
                      ),
                      )
                      );
                    }

                    
                    return Container();
                  });
            } else {
              return SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.width / 1.2,
                  //child: CircularProgressIndicator(),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(
                        height: 120,
                        width: 120,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Skeleton(width: 80),
                          SizedBox(
                            height: 8,
                          ),
                          Skeleton(),
                          SizedBox(
                            height: 8,
                          ),
                          Skeleton(),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(child: Skeleton()),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(child: Skeleton()),
                            ],
                          )
                        ],
                      ))
                    ],
                  ));
            }
          },
        ),
      ),
                
              
          
          ],
        ),
      ),
      )
    );
  }
}

class CategoryCard1 extends StatelessWidget {
  const CategoryCard1({
    Key? key,
    required this.icon,
    //required this.text,
    required this.press,
  }) : super(key: key);

  final String? icon;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(50),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(5)),
              height: getProportionateScreenWidth(30),
              width: getProportionateScreenWidth(30),
              decoration: BoxDecoration(
                color: const Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(icon!),
            ),
            const SizedBox(height: 5),
            //Text(text!, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
