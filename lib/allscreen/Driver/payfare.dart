import 'package:flutter/material.dart';
import 'package:shila/button/splash.dart';

class PayFareAmountDialog extends StatefulWidget {
  double? fareAmount;
  PayFareAmountDialog({this.fareAmount});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}

class _PayFareAmountDialogState extends State<PayFareAmountDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Fare Amount".toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 2,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Rs." + widget.fareAmount.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "This is yours FareAmount.. Please pay it to the driver",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () {
                    Future.delayed(Duration(microseconds: 10000), () {
                      Navigator.pop(context, "Cash Paid");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Pay Cash",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rs." + widget.fareAmount.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
