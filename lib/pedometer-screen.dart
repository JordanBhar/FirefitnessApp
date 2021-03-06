import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/home-screen.dart';
import 'package:project/settings.dart';
import 'package:project/workEd/workEd-screen.dart';
import 'calendar-screen.dart';
import 'createWorkout-screen.dart';
import 'package:pedometer/pedometer.dart';

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({Key? key}) : super(key: key);

  @override
  State<PedometerScreen> createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  int _currentIndex = 4;
  double _cals = 0;
  int _calsInt = 0;
  int _stepsInt = 0;

  late Stream<StepCount> _stepCountStream;
  String _steps = '0';
  //String _steps = '?';
  // _steps used to be a '?' instead of '0', if anything breaks that is why. needed to do this for the calorie counter

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }
  //
  // void calculateCalories(){
  //   setState(() {
  //     // _stepsInt = int.parse(_steps);
  //     // _cals = (_stepsInt) / 40;
  //     // _calsInt = _cals.toInt();
  //     // var rng = Random();
  //     // for (var i = 0; i < 10; i++) {
  //     //    _calsInt = (rng.nextInt(100));
  //     // }
  //
  //
  //
  //   });
  // }

  void showCalories() {

    // _steps = "1000";
    _stepsInt = int.parse(_steps);
    _cals = (_stepsInt) / 40;
    _calsInt = _cals.toInt();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("$_calsInt"),
          content: const Text("Calories Burned!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Pedometer"),

          actions: [IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SettingsScreen();
              }));
            },
          )],
          backgroundColor: const Color.fromRGBO(255, 130, 100, 1),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          backgroundColor: const Color.fromRGBO(255, 130, 100, 1),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: (value) {
            if (value == 0) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const HomeScreen();
              }));
            } else if (value == 1) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const CalendarScreen();
              }));
            } else if (value == 2) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const CreateWorkoutScreen();
              }));
            } else if (value == 3) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const WorkEdScreen();
              }));
            } else if (value == 4) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const PedometerScreen();
              }));
            }
            setState(() => _currentIndex = value);
          },
          items: const [
            BottomNavigationBarItem(
              label: ('Home'),
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: ('Calendar'),
              icon: Icon(Icons.calendar_month),
            ),
            BottomNavigationBarItem(
              label: ('Workout Plan'),
              icon: Icon(Icons.whatshot),
            ),
            BottomNavigationBarItem(
              label: ('Exercises'),
              icon: Icon(Icons.fitness_center),
            ),
            BottomNavigationBarItem(
              label: ('Pedometer'),
              icon: FaIcon(FontAwesomeIcons.personWalking),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            const Center(
              child: FaIcon(FontAwesomeIcons.personWalking,
                  size: 190, color: Color.fromRGBO(255, 130, 100, 1)),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(_steps,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Color.fromRGBO(255, 130, 100, 1))),
            const Text("Steps Today!", style: TextStyle(fontSize: 25)),
            const SizedBox(
              height: 80,
            ),
            FloatingActionButton(
              onPressed: (){showCalories();},
              backgroundColor: const Color.fromRGBO(255, 130, 100, 1),
              child: const Icon(Icons.local_fire_department),
            ),
            // Row(
            //   children: [
            //     const SizedBox(
            //       width: 25,
            //     ),
            //     const Icon(Icons.local_fire_department, size: 60),
            //     Text("$_calsInt",
            //         style: const TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 25,
            //             color: Color.fromRGBO(255, 130, 100, 1))),
            //     const Text(" Calories Burned!",
            //         style: TextStyle(
            //             fontSize: 25)),
            //   ],
            // ),
          ],
        ));
  }
}
