
import 'package:flutter/material.dart';


class CommingList extends StatefulWidget {
  @override
  State createState() => _CommingListState();
}

class _CommingListState extends State{
  @override
  Widget build(BuildContext context) {
    return GridView.builder(

      padding:const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 10, // Spacing between columns
                        mainAxisSpacing: 10, // Spacing between rows
                      ),
                      itemCount: 4,
                      itemBuilder: (context,index){
                        return 
                        Container( 
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration( 
                            boxShadow: [
                              BoxShadow(offset: Offset(-3,5), 
                              blurRadius: 3,
                              color: Color.fromARGB(255, 158, 158, 158)
                            )
                            ],
                            borderRadius:
                                          BorderRadius.circular(16),
                                          border: Border.all(color: Colors.grey,width: 2)
                          ),
                          child: ClipRRect( 
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: Image.asset("assets/images/26690.jpg"),
                          ),
                        );
                      }
                        
                    
                    );
  }
}


  