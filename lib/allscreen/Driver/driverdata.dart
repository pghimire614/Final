class driverdata {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? address;
  String? license;
  String? ratings;
  String? vehicle_color;
  String? vehicle_Model;
  String? vehicle_number;
  String? Vehicle_type;

  driverdata(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.address,
      this.license,
      this.ratings,
      this.vehicle_Model,
      this.vehicle_color,
      this.vehicle_number,
      this.Vehicle_type});
  // driverdata.fromSnapshot(DataSnapshot dataSnapshot) {

  //   id = dataSnapshot.key;
  //   email = (dataSnapshot.child("email").value.toString());
  //   name =  (dataSnapshot.child("name").value.toString());
  //   phone =  (dataSnapshot.child("phone").value.toString());
  //   address =  (dataSnapshot.child("address").value.toString());

  // }
}
