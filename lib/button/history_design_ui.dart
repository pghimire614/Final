import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shila/allscreen/trips_history_screen.dart';
import 'package:shila/models/trips_history_model.dart';

class HistoryDesignUIWiget extends StatefulWidget {
  TripsHistoryModel? tripsHistoryModel;
  HistoryDesignUIWiget({this.tripsHistoryModel});

  @override
  State<HistoryDesignUIWiget> createState() => _HistoryDesignUIWigetState();
}

class _HistoryDesignUIWigetState extends State<HistoryDesignUIWiget> {
  String formatDateAndTime(String dateTimeFromDB) {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);

    String formattedDateTime =
        "${DateFormat.MMMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)}, ${DateFormat.jm().format(dateTime)}";
    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatDateAndTime(widget.tripsHistoryModel!.time!),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            //color: Colors.white
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tripsHistoryModel!.driverName!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "4.5",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            " ${widget.tripsHistoryModel!.status!}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Final Cost",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            " ${widget.tripsHistoryModel!.fareAmount!}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Divider(
                thickness: 3,
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      "Trip",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "${(widget.tripsHistoryModel!.originAddress!).substring(0, 15)}....",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "${(widget.tripsHistoryModel!.destinationAddress!)}....",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
