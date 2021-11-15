
import 'dart:convert';

LockOutDetailModal lockOutDetailModalFromJson(String str) => LockOutDetailModal.fromJson(json.decode(str));

String lockOutDetailModalToJson(LockOutDetailModal data) => json.encode(data.toJson());

class LockOutDetailModal {
    LockOutDetailModal({
        this.status,
        this.message,
        this.data,
    });

    String? status;
    String? message;
    List<Datum>? data;

    factory LockOutDetailModal.fromJson(Map<String, dynamic> json) => LockOutDetailModal(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.title,
        this.image,
        this.caption,
        this.details,
    });

    int? id;
    String? title;
    String? image;
    String? caption;
    List<Detail>? details;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        caption: json["caption"],
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "caption": caption,
        "details": List<dynamic>.from(details!.map((x) => x.toJson())),
    };
}

class Detail {
    Detail({
        this.label,
        this.value,
    });

    String? label;
    String? value;

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        label: json["label"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
    };
}
