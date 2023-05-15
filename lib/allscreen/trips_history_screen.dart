import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shila/DataHandeler/appData.dart';
import 'package:shila/button/history_design_ui.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: darkTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: darkTheme ? Colors.black : Colors.white,
        title: Text(
          "Trip History",
          style: TextStyle(
            color: darkTheme ? Colors.amber.shade400 : Colors.black,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: darkTheme ? Colors.amber.shade400 : Colors.black,
            )),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
          itemBuilder: (context, i) {
            return Card(
              color: Colors.grey,
              shadowColor: Colors.transparent,
              child: HistoryDesignUIWiget(
                  tripsHistoryModel:
                      Provider.of<AppData>(context, listen: false)
                          .allTripsHistoryInformationList[1]),
            );
          },
          separatorBuilder: (context, i) => SizedBox(
            height: 30,
          ),
          itemCount: Provider.of<AppData>(context, listen: false)
              .allTripsHistoryInformationList
              .length,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
        ),
      ),
    );
  }
}
