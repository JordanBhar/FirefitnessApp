
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/settings.dart';
import 'package:project/workEd/workEd-screen.dart';
import 'package:project/workEd/workEdDetail-screen.dart';

class CreateWorkoutList extends StatefulWidget{
  const CreateWorkoutList({Key? key, required this.index }) : super(key: key);
  final String index;

  @override
  _WorkList createState() => _WorkList();
}

class _WorkList extends State<CreateWorkoutList>{
  late var data;
  late final DatabaseReference _workoutRef = FirebaseDatabase.instance.ref().child('Plan1/${widget.index}');
  late final DatabaseReference _workoutRef2 = FirebaseDatabase.instance.ref().child('Plan2/${widget.index}');

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }


  void _activateListeners(){
    _workoutRef.onValue.listen((event) {
      setState(() {
        data = Map<String, dynamic>.from(event.snapshot.value as Map);
      });
      log(data.toString());
    });

    _workoutRef2.onValue.listen((event) {
      setState(() {
        data = Map<String, dynamic>.from(event.snapshot.value as Map);
      });
      log(data.toString());
    });

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return const WorkEdScreen();
            }));
          },
          ),
          automaticallyImplyLeading: false,
          title: Text(widget.index),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SettingsScreen();
                }));
              },
            )
          ],
          backgroundColor: const Color.fromRGBO(255, 130, 100, 1),
        ),
        body: Center(
            child: Column(children: [

            Flexible( child: FirebaseAnimatedList(query: _workoutRef, itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

              return ListTile(title:  Text(snapshot.key.toString()),

                onTap:() {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => WorkEdDetailScreen(data: data[snapshot.key.toString()],)

                  ));
                },
              );
            },
            )
            ),

              Flexible( child: FirebaseAnimatedList(query: _workoutRef2, itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

                return ListTile(title:  Text(snapshot.key.toString()),

                  onTap:() {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => WorkEdDetailScreen(data: data[snapshot.key.toString()],)

                    ));
                  },
                );
              },
              )
              )

            ]),

        )
    );
  }
}
