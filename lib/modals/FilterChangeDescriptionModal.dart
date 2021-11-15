
import 'package:zacharchive_flutter/modals/PlantProductDetailModal2.dart';

class FilterChangeDescriptionModal {
    FilterChangeDescriptionModal({
        this.status,
        this.data,
        this.message,
    });

    String? status;
    Data? data;
    String? message;

    factory FilterChangeDescriptionModal.fromJson(Map<String, dynamic> json) => FilterChangeDescriptionModal(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
    };
}

class Data {
    Data({
        this.name,
        this.title,
        this.image,
        this.details,
        this.notes,
    });

    String? name;
    String? title;
    String? image;
    List<DataDetail>? details;
    List<Note>? notes;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        title: json["title"],
        image: json["image"],
        details: List<DataDetail>.from(json["details"].map((x) => DataDetail.fromJson(x))),
        notes: List<Note>.from(json["notes"].map((x) => Note.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "image": image,
        "details": List<dynamic>.from(details!.map((x) => x.toJson())),
        "notes": List<dynamic>.from(notes!.map((x) => x.toJson())),
    };
}

class DataDetail {
    DataDetail({
        this.label,
        this.value,
        this.valueAlt,
    });

    String? label;
    String? value;
    String? valueAlt;

    factory DataDetail.fromJson(Map<String, dynamic> json) => DataDetail(
        label: json["label"],
        value: json["value"],
        valueAlt: json["value_alt"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "value_alt": valueAlt,
    };
}
/*
class Note2 {
    Note2({
        this.id,
        this.userName,
        this.createdAt,
        this.title,
        this.notes,
        this.details,
    });

    int? id;
    String? userName;
    String? createdAt;
    String? title;
    String? notes;
    List<NoteDetail>? details;

    factory Note2.fromJson(Map<String, dynamic> json) => Note2(
        id: json["id"],
        userName: json["user_name"],
        createdAt: json["created_at"],
        title: json["title"],
        notes: json["notes"],
        details: List<NoteDetail>.from(json["details"].map((x) => NoteDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "created_at": createdAt,
        "title": title,
        "notes": notes,
        "details": List<dynamic>.from(details!.map((x) => x.toJson())),
    };
}

class NoteDetail {
    NoteDetail({
        this.files,
    });

    String? files;

    factory NoteDetail.fromJson(Map<String, dynamic> json) => NoteDetail(
        files: json["files"],
    );

    Map<String, dynamic> toJson() => {
        "files": files,
    };
}*/
