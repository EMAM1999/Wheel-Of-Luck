import 'package:wheel_of_luck/models/event_item.dart';
import 'package:wheel_of_luck/services/local_storage.dart';

const _eventsKey = 'events_data';

List<EventItem> _storedElements = [
  EventItem(name: 'عيد ميلاد ميدو', date: DateTime(1999, 1, 10, 12, 00)),
  EventItem(name: 'عيد ميلاد دندن', date: DateTime(2005, 1, 1, 12, 00)),
  EventItem(name: 'الرؤية الشرعية', date: DateTime(2025, 6, 20, 20, 00)),
  EventItem(name: 'الخطوبة', date: DateTime(2025, 7, 2, 21, 00)),
];

List<EventItem> getEvents() => _storedElements;

void sortEvents() =>
    _storedElements.sort((a, s) => a.date.difference(s.date).inMinutes);

Future<void> saveEvents(List<EventItem> events) async {
  _storedElements = events;
  await LocalStorage.saveList(_eventsKey, events);
}

Future<List<EventItem>> loadEvents() async {
  _storedElements = await LocalStorage.loadList(
    _eventsKey,
    (json) => EventItem.fromJson(json),
  );
  return _storedElements;
}

Future<void> clear() async {
  _storedElements.clear();
  LocalStorage.clear(_eventsKey);
}

Future<void> initializeData() async {
  // Load from storage
  final localElements = await loadEvents();

  // If first time or no saved data → use hardcoded fallback
  if (localElements.isEmpty) {
    await saveEvents(_storedElements);
  } else {
    _storedElements = localElements;
  }
}
