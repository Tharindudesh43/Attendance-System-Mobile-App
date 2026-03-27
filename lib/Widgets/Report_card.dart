import 'package:attendance_system_flutter_application/Widgets/Report_Card_delete.dart';
import 'package:flutter/material.dart';

class ReportCard extends StatefulWidget {
  final String title;
  final String description;
  final String status;
  final String date;
  final String time;
  final String student_email;
  final List<dynamic> images;
  final String report_type;
  final String reportId;

  const ReportCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    required this.time,
    required this.student_email,
    required this.images,
    required this.report_type,
    required this.reportId,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool customIcon = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top box: Full width, height 100
          Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(31, 255, 255, 255),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              children: [
                Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: index == 0
                                ? Radius.circular(20)
                                : Radius.zero,
                            bottomLeft: index == 0
                                ? Radius.circular(20)
                                : Radius.zero,
                            topRight: index == 2
                                ? Radius.circular(20)
                                : Radius.zero,
                            bottomRight: index == 2
                                ? Radius.circular(20)
                                : Radius.zero,
                          ),
                        ),
                        child: widget.images.length > index
                            ? ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: index == 0
                                      ? Radius.circular(20)
                                      : Radius.zero,
                                  bottomLeft: index == 0
                                      ? Radius.circular(0)
                                      : Radius.zero,
                                  topRight: index == 2
                                      ? Radius.circular(20)
                                      : Radius.zero,
                                  bottomRight: index == 2
                                      ? Radius.circular(20)
                                      : Radius.zero,
                                ),
                                child: Image.network(
                                  widget.images[index],
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.broken_image,
                                        color: Colors.white,
                                      ),
                                  fit: BoxFit
                                      .cover, // ✅ makes it fill without distortion
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: index == 2
                                        ? Radius.circular(20)
                                        : Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                  color: Colors.grey.shade300,
                                ),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white,
                                ),
                              ), // placeholder if missing
                      ),
                    );
                  }),
                ),

                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(
                        0.6,
                      ), // semi-transparent box
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Text(
                                  widget.title ?? 'No title provided',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  width: 1,
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.report_type!,
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          key: widget.key,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  width: 1,
                                ),
                                color: const Color.fromARGB(255, 66, 65, 65),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.date_range_outlined,
                                    size: 14,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    widget.date!,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  width: 1,
                                ),
                                color: const Color.fromARGB(255, 66, 65, 65),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    widget.time!,
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            widget.student_email == 'Anonymous'
                                ? Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                              255,
                                              255,
                                              255,
                                              255,
                                            ),
                                            width: 1,
                                          ),
                                          color: const Color.fromARGB(
                                            255,
                                            66,
                                            65,
                                            65,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.unpublished_sharp,
                                              size: 14,
                                              color: Color.fromARGB(
                                                255,
                                                180,
                                                233,
                                                4,
                                              ),
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              'Anonymous',
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                  255,
                                                  180,
                                                  233,
                                                  4,
                                                ),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      color: widget.status == "Not Watched"
                          ? Colors.grey
                          : widget.status == "Watching"
                          ? const Color.fromARGB(255, 252, 228, 3)
                          : const Color.fromARGB(255, 0, 255, 0),

                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ReportCardDelete(
                            reportId: widget.reportId,
                            imagesUrls: widget.images,
                          );
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 250, 99, 99),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Icons.delete,
                        size: 20,
                        color: const Color.fromARGB(255, 231, 100, 100),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Material(
            elevation: 5,
            shadowColor: Colors.black26,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ExpansionTile(
                collapsedBackgroundColor: const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ).withOpacity(0.5),
                backgroundColor: const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ).withOpacity(0.5),
                minTileHeight: 0,
                collapsedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                visualDensity: const VisualDensity(vertical: -3),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                title: Container(
                  width: 50, // Adjusted width to fit 'Description' text
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  // padding: const EdgeInsets.all(5),
                  child: Container(
                    child: const Text(
                      'DETAILS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                trailing: Icon(
                  customIcon
                      ? Icons.arrow_drop_down_circle
                      : Icons.arrow_drop_down,
                  size: 20, // Kept smaller size from previous code
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth:
                            MediaQuery.of(context).size.width -
                            16, // Adjust for padding
                      ),
                      child: Text(
                        widget.description ?? 'No description provided',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(2, 109, 148, 1),
                        ),
                        softWrap: true, // Allow text to wrap
                        overflow:
                            TextOverflow.visible, // Ensure text fits and wraps
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    customIcon = expanded;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
