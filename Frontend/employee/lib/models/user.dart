
class User {

  int id;
  String firstname;
  String lastname;
  String email;
  String password;
  String cnpassword;
  String phnumber;
  String cpname;
  String rhnumber;
  String birthdate;
  String cin;

  User({required this.id , required this.firstname,required this.lastname,required this.email, required this.password,required this.cnpassword,required this.phnumber,required this.cpname, required this.rhnumber, required this.birthdate,required this.cin});

  // User({ this.login, this.password});



  Map<String,dynamic> toJson(){
    return {"id":id ,firstname:'firstname',lastname:'lastname'
      ,email:'email',password:'password',
      cnpassword:'cnpassword',phnumber:'phnumber',cpname:'cpname',
      rhnumber:'rhnumber',birthdate:'birthdate',cin:'cin'};
  }
}