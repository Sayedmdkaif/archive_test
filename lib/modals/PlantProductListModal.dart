
import 'dart:convert';

PlantProductListModal plantProductListModalFromJson(String str) => PlantProductListModal.fromJson(json.decode(str));

String plantProductListModalToJson(PlantProductListModal data) => json.encode(data.toJson());

class PlantProductListModal {
    PlantProductListModal({
        this.status,
        this.data,
        this.message,
    });

    String? status;
    List<Datum>? data;
    String? message;

    factory PlantProductListModal.fromJson(Map<String, dynamic> json) => PlantProductListModal(
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
        this.categoryId,
        this.name,
        this.title,
        this.description,
        this.imageUrl,
    });

    int? id;
    int? categoryId;
    String? name;
    String? title;
    String? description;
    String? imageUrl;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        title: json["title"],
        description: json["description"],
        imageUrl: json["image_url"],

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "title": title,
        "description": description,
        "image_url": imageUrl,

    };
}
