
class OperationModal {
    OperationModal({
        this.status,
        this.data,
        this.message,
    });

    String? status;
    List<Datum>? data;
    String? message;

    factory OperationModal.fromJson(Map<String, dynamic> json) => OperationModal(
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
        this.name,
        this.image,
        this.type,
    });

    int? id;
    String? name;
    String? image;
    String? type;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
    };
}
