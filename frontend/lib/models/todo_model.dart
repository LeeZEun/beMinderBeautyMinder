// ignore_for_file: invalid_annotation_target

bool intToBool(int value) => value == 1;
int boolToInt(bool value) => value ? 1 : 0;

class TodoModel {
  TodoModel({
    required this.id,
    required this.name,
    required this.date,
    required this.morningOrEvening,
    this.isFinished = false,
    this.imagePath,
  });

  late final int id;
  late final String name;
  late final DateTime date;
  late final String morningOrEvening;
  bool isFinished = false;
  String? imagePath;

  @override
  String toString() {
    return '''
Todo {
  id: $id,
  name: $name,
  date: $date,
  morningOrEvening: $morningOrEvening,
  isFinished: $isFinished,
  imagePath: $imagePath,
}''';
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      morningOrEvening: json['morningOrEvening'],
      isFinished: intToBool(json['isFinished']),
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'morningOrEvening': morningOrEvening,
      'isFinished': boolToInt(isFinished),
      'imagePath': imagePath,
    };
  }
}