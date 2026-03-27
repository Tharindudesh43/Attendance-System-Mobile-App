import 'package:flutter/material.dart';

class DataLable extends StatefulWidget {
  String DataLableTitle;
  String DataLableDetail;
  DataLable({
    super.key,
    required this.DataLableDetail,
    required this.DataLableTitle,
  });

  @override
  State<DataLable> createState() => _DataLableState();
}

class _DataLableState extends State<DataLable> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.DataLableTitle,
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              widget.DataLableDetail,
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
