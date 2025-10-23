/// Base interface for any storable item (WheelItem, EventItem, etc.)
abstract class Item {
  Map<String, dynamic> toJson();
}
