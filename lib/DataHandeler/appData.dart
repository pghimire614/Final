import 'package:flutter/cupertino.dart';
import 'package:shila/allscreen/trips_history_screen.dart';
import '../models/address.dart';
import '../models/trips_history_model.dart';

class AppData extends ChangeNotifier {
  Address? pickUpLocation; //late nsagara
  Address? dropOffLocation; //late nagareney
  int countTotalTrips = 0;
  String driverTotalEarnings = "0";
  String driverAverageRatings = "0";
  List<String> historyTripskeyList = [];

  List<TripsHistoryModel> allTripsHistoryInformationList = [];

  void updatepickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners(); // update any changes happen ;;broadcast the changes
  }

  void updatedropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }

  updateOverAllTripsCounter(int overAllTripsCounter) {
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllTripsKeys(List<String> tripsKeysList) {
    historyTripskeyList = tripsKeysList;
    notifyListeners();
  }

  udateOverAllTripsHistoryInformation(TripsHistoryModel eachTripHistory) {
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }

  updateDriverTotalEarning(String driverEarnings) {
    driverTotalEarnings = driverEarnings;
  }

  updateDriverAverageRatings(String driverRatings) {
    driverAverageRatings = driverRatings;
  }
}
