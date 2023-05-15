import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shila/DataHandeler/appData.dart';
import 'package:shila/allscreen/global/global.dart';
import 'package:shila/allscreen/trips_history_screen.dart';

class EarningTabPage extends StatefulWidget {
  const EarningTabPage({super.key});

  @override
  State<EarningTabPage> createState() => _EarningTabPageState();
}

class _EarningTabPageState extends State<EarningTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Column(
        children: [
          Container(
            color: Colors.lightBlueAccent,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  Text(
                    "Your Earning",
                    style: TextStyle(
                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                      //color: Colors.blue),)
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    " " +
                        Provider.of<AppData>(context, listen: false)
                            .driverTotalEarnings,
                    style: TextStyle(
                        fontSize: 40,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          // total Number of trips
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => TripHistoryScreen()));
            },
            style: ElevatedButton.styleFrom(primary: Colors.white54),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Image.asset(
                    onlineDriverData.Vehicle_type == "Car"
                        ? "images/Car.jpg"
                        : "image/Bike.png",
                    scale: 2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Trip completed",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  Expanded(
                      child: Container(
                    child: Text(
                      " " +
                          Provider.of<AppData>(context, listen: false)
                              .allTripsHistoryInformationList
                              .length
                              .toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 20,
                          //letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
