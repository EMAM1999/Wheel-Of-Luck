import 'package:wheel_of_luck/models/Item.dart';

class WheelItem extends Item {
  String symbol;
  String content;
  int points;

  WheelItem({
    required this.symbol,
    required this.content,
    required this.points,
  });

  @override
  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'content': content,
    'points': points,
  };

  factory WheelItem.fromJson(Map<String, dynamic> map) => WheelItem(
    symbol: map['symbol'] ?? '',
    content: map['content'] ?? '',
    points: map['points'] ?? 0,
  );
}
