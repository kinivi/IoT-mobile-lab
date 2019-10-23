class Worker {
    int id;
    int mineId;
    int transportId;
    int startTs;
    String transportName;
    String imageLink;

    Worker({
        this.id,
        this.mineId,
        this.transportId,
        this.startTs,
        this.transportName,
        this.imageLink,
    });

    factory Worker.fromJson(Map<String, dynamic> json) => Worker(
        id: json["id"],
        mineId: json["mine_id"],
        transportId: json["transport_id"],
        startTs: json["start_ts"],
        transportName: json["transport_name"],
        imageLink: json["image_link"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "mine_id": mineId,
        "transport_id": transportId,
        "start_ts": startTs,
        "transport_name": transportName,
        "image_link": imageLink,
    };
}