import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shila/DataHandeler/appData.dart';
import 'package:shila/allscreen/constants.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RatingsTabPage extends StatefulWidget {
  const RatingsTabPage({super.key});

  @override
  State<RatingsTabPage> createState() => _RatingsTabPageState();
}

class _RatingsTabPageState extends State<RatingsTabPage> {
  double ratingNumber = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getRatingsNumber() {
    setState(() {
      ratingNumber = double.parse(
          Provider.of<AppData>(context, listen: false).driverAverageRatings);
    });
    setupRatingTitle();
  }

  setupRatingTitle() {
    if (countRatingStars == 1) {
      setState(() {
        titleStarsRating = "very Bad";
      });
    }
    if (countRatingStars == 2) {
      setState(() {
        titleStarsRating = "Bad";
      });
    }
    if (countRatingStars == 3) {
      setState(() {
        titleStarsRating = "Good";
      });
    }
    if (countRatingStars == 4) {
      setState(() {
        titleStarsRating = "very Good";
      });
    }
    if (countRatingStars == 5) {
      setState(() {
        titleStarsRating = "Excellent";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white60,
        child: Container(
          margin: EdgeInsets.all(4),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 22,
              ),
              Text(
                "Your Rating",
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SmoothStarRating(
                rating: ratingNumber,
                allowHalfRating: true,
                starCount: 5,
                color: Colors.blue,
                borderColor: Colors.blue,
                size: 46,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                titleStarsRating,
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
