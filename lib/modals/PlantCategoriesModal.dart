
import 'dart:convert';

PlantCategoriesModal plantCategoriesModalFromJson(String str) => PlantCategoriesModal.fromJson(json.decode(str));

String plantCategoriesModalToJson(PlantCategoriesModal data) => json.encode(data.toJson());

class PlantCategoriesModal {
    PlantCategoriesModal({
        this.status,
        this.data,
        this.message,
    });

    String? status;
    List<Datum>? data;
    String? message;

    factory PlantCategoriesModal.fromJson(Map<String, dynamic> json) => PlantCategoriesModal(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
    };
}

class Datum {
    Datum({
        this.id,
        this.locationId,
        this.name,
        this.iconUrl,
        this.iconName,
        this.status,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    int? locationId;
    String? name;
    String? iconUrl;
    String? iconName;
    int? status;
    int? isDeleted;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        locationId: json["location_id"],
        name: json["name"],
        iconUrl: json["icon_url"],
        iconName: json["icon_name"],
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "location_id": locationId,
        "name": name,
        "icon_url": iconUrl,
        "icon_name": iconName,
        "status": status,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
