import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final List<String>? Data;
  final String? selecteddata;
  final Function(String)? onChanged;

  const Dropdown({Key? key, this.Data, this.selecteddata, this.onChanged})
    : super(key: key);

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selecteddata;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 25, 25, 26),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          style: const TextStyle(
            color: Color.fromARGB(255, 210, 17, 17),
            fontSize: 11,
          ),
          dropdownColor: const Color.fromARGB(255, 243, 244, 245),
          value: null,
          hint: Text(
            selectedValue ?? "Select",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          items: widget.Data?.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: SizedBox(
                width: 120,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 6, 169, 82),
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            final match = RegExp(r'\((.*?)\)').firstMatch(value ?? '');
            final finalValue = match?.group(1) ?? value!;
            setState(() {
              selectedValue = finalValue;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(finalValue);
            }
          },
        ),
      ),
    );
  }
}
