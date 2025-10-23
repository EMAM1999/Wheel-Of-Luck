import 'package:wheel_of_luck/models/Item.dart';

class EventItem extends Item {
  String name;
  DateTime date;

  EventItem({required this.name, required this.date});

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'date': date.toIso8601String(),
  };

  static EventItem fromJson(Map<String, dynamic> json) =>
      EventItem(name: json['name'], date: DateTime.parse(json['date']));
}
