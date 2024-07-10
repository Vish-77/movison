
import 'package:flutter/material.dart';


class CommingList extends StatefulWidget {
  @override
  State createState() => _CommingListState();
}

class _CommingListState extends State{
  @override
  Widget build(BuildContext context) {
    return GridView(
      padding:const EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        childAspectRatio: 3/2,
                        crossAxisSpacing: 5, // Spacing between columns
                        mainAxisSpacing: 8, // Spacing between rows
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8),
                          child: Container( 
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration( 
                              borderRadius:
                                            BorderRadius.circular(16),
                                            border: Border.all(color: Colors.grey,width: 2)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8),
                          child: Container( 
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration( 
                              borderRadius:
                                            BorderRadius.circular(16),
                                            border: Border.all(color: Colors.grey,width: 2)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8),
                          child: Container( 
                            height:50,
                            width: 50,
                            decoration: BoxDecoration( 
                              borderRadius:
                                            BorderRadius.circular(16),
                                            border: Border.all(color: Colors.grey,width: 2)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8),
                          child: Container( 
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration( 
                              borderRadius:
                                            BorderRadius.circular(16),
                                            border: Border.all(color: Colors.grey,width: 2)
                            ),
                          ),
                        ),
                        
                      ],
                        
                    
                    );
  }
}


  