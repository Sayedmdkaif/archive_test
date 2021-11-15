
import 'dart:convert';

PlantProductDetailModal2 plantProductDetailModal2FromJson(String str) => PlantProductDetailModal2.fromJson(json.decode(str));

String plantProductDetailModal2ToJson(PlantProductDetailModal2 data) => json.encode(data.toJson());

class PlantProductDetailModal2 {
    PlantProductDetailModal2({
        this.status,
        this.message,
        this.data,
    });

    String? status;
    String? message;
    Data? data;

    factory PlantProductDetailModal2.fromJson(Map<String, dynamic> json) => PlantProductDetailModal2(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
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
        this.groupName,
        this.groupDetails,
    });

    String? groupName;
    List<GroupDetail>? groupDetails;

    factory DataDetail.fromJson(Map<String, dynamic> json) => DataDetail(
        groupName: json["group_name"],
        groupDetails: List<GroupDetail>.from(json["group_details"].map((x) => GroupDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "group_name": groupName,
        "group_details": List<dynamic>.from(groupDetails!.map((x) => x.toJson())),
    };
}

class GroupDetail {
    GroupDetail({
        this.label,
        this.value,
        this.valueAlt,
    });

    String? label;
    String? value;
    String? valueAlt;

    factory GroupDetail.fromJson(Map<String, dynamic> json) => GroupDetail(
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

class Note {
    Note({
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

    factory Note.fromJson(Map<String, dynamic> json) => Note(
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
}



