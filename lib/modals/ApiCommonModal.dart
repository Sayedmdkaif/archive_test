
import 'dart:convert';

ApiCommonModal apiResponseFromJson(String str) => ApiCommonModal.fromJson(json.decode(str));

String apiResponseToJson(ApiCommonModal data) => json.encode(data.toJson());

class ApiCommonModal {
    ApiCommonModal({
        this.status,
        this.message,
        this.data,
    });

    String? status;
    String? message;
    Data? data;

    factory ApiCommonModal.fromJson(Map<String, dynamic> json) => ApiCommonModal(
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
    });

    String? id;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
