class WheelItem {
  String symbol;
  String content;
  int points;

  WheelItem({
    required this.symbol,
    required this.content,
    required this.points,
  });

  Map<String, dynamic> toMap() => {
    'symbol': symbol,
    'content': content,
    'points': points,
  };

  factory WheelItem.fromMap(Map<String, dynamic> map) => WheelItem(
    symbol: map['symbol'] ?? '',
    content: map['content'] ?? '',
    points: map['points'] ?? 0,
  );
}
