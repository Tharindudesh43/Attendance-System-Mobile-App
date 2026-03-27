import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactUsBox extends ConsumerStatefulWidget {
  ContactUsBox({Key? key}) : super(key: key);

  @override
  ConsumerState<ContactUsBox> createState() => _ContactUsBoxState();
}

class _ContactUsBoxState extends ConsumerState<ContactUsBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shadowColor: Colors.white.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 300,
        height: 210,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              Icon(
                Icons.contact_mail,
                size: 50,
                color: Color.fromRGBO(2, 109, 148, 1),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(),
                child: const Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Contact Us at: tharindudeshanhimahansa43@gmail.com",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(2, 109, 148, 1),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
