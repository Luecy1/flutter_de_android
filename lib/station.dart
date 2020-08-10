class Station {
  final String id;
  final String name;
  final String image;

  Station({
    this.id,
    this.name,
    this.image,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
