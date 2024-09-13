// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  List<String> laps = [];
  late Timer globalTimer;
  late Timer lapTimer;
  bool isStopWatchRunning = false;
  int globalStopWatchInMilliseconds = 0;
  int lapStopWatchInMilliseconds = 0;

  String _formatTime(int milliseconds) {
    int minutes = milliseconds ~/ 60000;
    int seconds = (milliseconds % 60000) ~/ 1000;
    int milli =
        (milliseconds % 1000) ~/ 10; // Displaying hundredths of a second
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milli.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 120),
              child: Text(
                _formatTime(globalStopWatchInMilliseconds),
                style: TextStyle(
                    fontSize: 90,
                    fontWeight: FontWeight.w200,
                    color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isStopWatchRunning == true) {
                        //lap code
                        laps.add(_formatTime(lapStopWatchInMilliseconds));
                        setState(() {
                          lapStopWatchInMilliseconds = 0;
                        });
                      } else {
                        setState(() {
                          globalStopWatchInMilliseconds = 0;
                          lapStopWatchInMilliseconds = 0;
                          laps = [];
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey[800]),
                      child: Text(
                        isStopWatchRunning ? "Lap" : "Reset",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isStopWatchRunning == false) {
                        setState(() {
                          isStopWatchRunning = true;
                        });
                        globalTimer = Timer.periodic(Duration(milliseconds: 1),
                            (duration) {
                          setState(() {
                            globalStopWatchInMilliseconds++;
                          });
                        });
                        lapTimer = Timer.periodic(Duration(milliseconds: 1),
                            (duration) {
                          setState(() {
                            lapStopWatchInMilliseconds++;
                          });
                        });
                      } else {
                        globalTimer.cancel();
                        lapTimer.cancel();
                        setState(() {
                          isStopWatchRunning = false;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color.fromARGB(88, 1, 154, 6)),
                      child: Text(
                        isStopWatchRunning ? "Stop" : "Start",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 3, 176, 9),
                            fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // lap list
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Visibility(
                        visible: isStopWatchRunning == true || lapStopWatchInMilliseconds != 0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lap ${laps.length + 1}",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                _formatTime(lapStopWatchInMilliseconds),
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: laps.isNotEmpty,
                        child: Divider(
                          color: Colors.grey[900],
                        ),
                      ),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        reverse: true,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        itemCount: laps.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: Colors.grey[900],
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lap ${index + 1}",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                laps[index],
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
