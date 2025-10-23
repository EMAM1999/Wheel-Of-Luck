import 'package:flutter/material.dart';
import '../models/event_item.dart';
import 'dart:async';

class EventCard extends StatefulWidget {
  final EventItem event;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const EventCard({
    super.key,
    required this.event,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late Duration diff;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _updateTimer();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimer());
  }

  void _updateTimer() {
    setState(() {
      diff = widget.event.date.difference(DateTime.now());
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPast = diff.isNegative;
    final displayDiff = diff.abs();
    final message =
        "(${displayDiff.inDays ~/ 365}) year , (${displayDiff.inDays % 365}) day , (${displayDiff.inHours % 24}) hour , (${displayDiff.inMinutes % 60}) minute";
    // glows if less than 1 day
    final glow = !isPast && displayDiff.inSeconds < 60 * 60 * 24;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      // margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: glow ? Colors.blueAccent.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (glow)
            BoxShadow(color: Colors.blueAccent, blurRadius: 5, spreadRadius: 5)
          else if (isPast)
            BoxShadow(color: Colors.blueGrey, blurRadius: 2, spreadRadius: 2)
          else
            BoxShadow(color: Colors.redAccent, blurRadius: 2, spreadRadius: 2),
        ],
      ),
      child: ListTile(
        title: Text(
          widget.event.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Text("${isPast ? "Time passed: " : "Time left: "}\n$message"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: widget.onEdit, icon: const Icon(Icons.edit)),
            IconButton(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
