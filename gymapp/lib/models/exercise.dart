class Exercise {
  final int? id;
  final String name;
  final int seconds;

  Exercise({this.id, required this.name, required this.seconds});

  factory Exercise.fromMap(Map<String, dynamic> json) => Exercise(
        id: json['id'],
        name: json['name'],
        seconds: json['seconds'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'seconds': seconds,
    };
  }
}
