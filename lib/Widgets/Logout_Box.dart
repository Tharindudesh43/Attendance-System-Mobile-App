import 'package:attendance_system_flutter_application/Providers/riverpod.dart';
import 'package:attendance_system_flutter_application/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutDialog extends ConsumerStatefulWidget {
  String? userImageUrl;
  LogoutDialog({Key? key, required this.userImageUrl}) : super(key: key);

  @override
  ConsumerState<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends ConsumerState<LogoutDialog> {
  bool isLoading = false;

  void _handleLogout(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    ref.read(riverpodUserData).clearUserData();
    await FirebaseAuth.instance.signOut();

    if (mounted) {
      Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (Route<dynamic> route) => false,
      );
    }
  }

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
              const SizedBox(height: 10),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: const Color.fromRGBO(2, 109, 148, 1),
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.userImageUrl ??
                        'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-High-Quality-Image.png',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Failed to load image'));
                    },
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
                  InkWell(
                    onTap: isLoading ? null : () => _handleLogout(context),
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.red,
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Log Out",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
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
