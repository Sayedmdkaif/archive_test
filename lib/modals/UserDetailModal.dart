
import 'dart:convert';

UserDetailModal userDetailModalFromJson(String str) => UserDetailModal.fromJson(json.decode(str));

String userDetailModalToJson(UserDetailModal data) => json.encode(data.toJson());

class UserDetailModal {
    UserDetailModal({
        this.status,
        this.message,
        this.data,
    });

    String? status;
    String? message;
    Data? data;

    factory UserDetailModal.fromJson(Map<String, dynamic> json) => UserDetailModal(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    Data({
        this.id,
        this.name,
        this.email,
        this.phone,
        this.companyName,
        this.companyLocation,
    });

    int? id;
    String? name;
    String? email;
    String? phone;
    String? companyName;
    String? companyLocation;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        companyName: json["company_name"],
        companyLocation: json["company_location"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "company_name": companyName,
        "company_location": companyLocation,
    };
}
