import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  DateTime? selectedDate;
  ValueChanged<DateTime> onDateSelected;

  DatePicker({super.key, this.selectedDate, required this.onDateSelected});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 00),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 25, 25, 26), // Border color
            width: 1.0, // Border width
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${widget.selectedDate?.toLocal()}".split(' ')[0],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today_sharp, size: 15),
                autofocus: true,
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: widget.selectedDate,
                    firstDate: DateTime(1980, 8),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != widget.selectedDate) {
                    setState(() {
                      widget.onDateSelected(picked);
                      widget.selectedDate = picked;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
