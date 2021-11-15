

class ControlRoomModal {
    ControlRoomModal({
        this.status,
        this.data,
        this.message,
    });

    String? status;
    List<Datum>? data;
    String? message;

    factory ControlRoomModal.fromJson(Map<String, dynamic> json) => ControlRoomModal(
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
        this.label,
        this.value,
        this.valueAlt,
    });

    String? label;
    String? value;
    String? valueAlt;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
