import 'package:flutter/material.dart';
import 'package:shila/button/splash.dart';

class FareAmountCollectionDialog extends StatefulWidget {
  double? totalFareAmount;
  FareAmountCollectionDialog({this.totalFareAmount});

  @override
  State<FareAmountCollectionDialog> createState() =>
      _FareAmountCollectionDialogState();
}

class _FareAmountCollectionDialogState
    extends State<FareAmountCollectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            // Trip Fare Amount",
            Text(
              "Trip Fare Amount",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber.shade400,
                fontSize: 20,
              ),
            ),
            Text(
              "  " + widget.totalFareAmount.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber.shade400,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Text(
                "This is the Total  Trip Amount Please collect it from rider",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.amber.shade400,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.amber.shade400),
                onPressed: () {
                  Future.delayed(Duration(milliseconds: 2000), () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => SplashScreen()));
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "collect Cash",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "  " + widget.totalFareAmount.toString(),
                      //textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
