import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wheel_of_luck/pages/events_page/utils/events_storage.dart';
import '../../models/event_item.dart';
import '../../widgets/event_card.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  static const firstDate = 1950;
  static const lastDate = 2100;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    await loadEvents();
    setState(() {});
  }

  /// Add a new event
  Future<void> _addEvent() async {
    final nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Event'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Event name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(firstDate),
                  lastDate: DateTime(lastDate),
                );

                if (pickedDate == null) return;

                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime == null) return;

                final eventDate = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );

                setState(() {
                  getEvents().add(
                    EventItem(
                      name: nameController.text.isEmpty
                          ? 'Untitled Event'
                          : nameController.text,
                      date: eventDate,
                    ),
                  );
                });
                await saveEvents(getEvents());
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  /// Edit an existing event
  Future<void> _editEvent(EventItem event) async {
    final nameController = TextEditingController(text: event.name);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Event name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: Text('Change Date: ${_dateFormat.format(event.date)}'),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: event.date,
                    firstDate: DateTime(firstDate),
                    lastDate: DateTime(lastDate),
                  );

                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(event.date),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        event.date = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  event.name = nameController.text;
                });
                await saveEvents(getEvents());
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(EventItem event) async {
    setState(() {
      getEvents().remove(event);
    });
    await saveEvents(getEvents());
  }

  @override
  Widget build(BuildContext context) {
    sortEvents();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🎉 Events",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.info_outline),
          //   onPressed: () {
          //     showAboutDialog(
          //       context: context,
          //       applicationName: '🎉 Events',
          //       applicationVersion: '1.0.0',
          //       applicationLegalese:
          //           '© 2025 Eng.Mohamed Ashraf (EMAM)\nLicensed under the MIT License.\nVisit: github.com/EMAM1999',
          //     );
          //   },
          // ),
          // const SizedBox(width: 5),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEvent,
        icon: const Icon(Icons.add),
        label: const Text('Add Event', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: getEvents().isEmpty
          ? const Center(
              child: Text(
                'No events yet.\nTap + to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: getEvents().length,
              itemBuilder: (context, index) {
                final event = getEvents()[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // boxShadow: [
                    //   if (_isToday(event.date))
                    //     BoxShadow(
                    //       color: Colors.deepPurple.withOpacity(0.5),
                    //       blurRadius: 20,
                    //       spreadRadius: 2,
                    //     ),
                    // ],
                  ),
                  child: EventCard(
                    event: event,
                    onEdit: () => _editEvent(event),
                    onDelete: () => _deleteEvent(event),
                  ),
                );
              },
            ),
    );
  }

  // bool _isToday(DateTime date) {
  //   final now = DateTime.now();
  //   return now.month == date.month && now.day == date.day;
  // }
}
