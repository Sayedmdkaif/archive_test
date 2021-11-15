
import 'dart:convert';

LoginModal loginModalFromJson(String str) => LoginModal.fromJson(json.decode(str));

String loginModalToJson(LoginModal data) => json.encode(data.toJson());

class LoginModal {
  LoginModal({
    this.data,
    this.message,
    this.status,
  });

  Data? data;
  String? message;
  String? status;

  factory LoginModal.fromJson(Map<String, dynamic> json) => LoginModal(
    data: Data.fromJson(json["data"]),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "message": message,
    "status": status,
  };
}

class Data {
  Data({
    this.token,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.company,
    this.location,
    this.changeLocation,
    this.allLocations,
  });

  String? token;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? company;
  String? location;
  int? changeLocation;
  List<AllLocation>? allLocations;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    phone: json["phone"],
    company: json["company"],
    location: json["location"],
    changeLocation: json["change_location"],
    allLocations: List<AllLocation>.from(json["all_locations"].map((x) => AllLocation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "name": name,
    "email": email,
    "password": password,
    "phone": phone,
    "company": company,
    "location": location,
    "change_location": changeLocation,
    "all_locations": List<dynamic>.from(allLocations!.map((x) => x.toJson())),
  };
}

class AllLocation {
  AllLocation({
    this.id,
    this.city,
  });

  int? id;
  String? city;

  factory AllLocation.fromJson(Map<String, dynamic> json) => AllLocation(
    id: json["id"],
    city: json["city"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city": city,
  };
}
