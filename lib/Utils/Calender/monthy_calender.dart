import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
class MonthyCalender extends StatefulWidget {
  const MonthyCalender({super.key});

  @override
  State<MonthyCalender> createState() => _MonthyCalenderState();
}

class _MonthyCalenderState extends State<MonthyCalender> {
  DateTime? _dateTime;
  DateTime _focusDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Colors.white,
        elevation: 10,
        child: TableCalendar(
          firstDay: DateTime.utc(2025  , 1 , 1),
          lastDay:DateTime.utc(2030 ,12 , 31) ,
          focusedDay: _focusDay,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) => isSameDay(_dateTime, day),
          onDaySelected: (selectedDay , focusDay){
            setState(() {
              _dateTime = selectedDay;
              _focusDay = focusDay;
            });
          },
          headerVisible: true,
          availableGestures: AvailableGestures.horizontalSwipe,
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

}
