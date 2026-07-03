import 'package:flutter/material.dart';

class ModernDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final String hintText;
  final ValueChanged<String?> onChanged;

  const ModernDropdown({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 45, 142, 177),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItem,
          hint: Text(
            hintText,
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          iconSize: 24,
          isExpanded: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
