import 'dart:async';
import 'package:attendance_system_flutter_application/Pages/DiscoverPage.dart';
import 'package:attendance_system_flutter_application/Pages/Qr_ResultScreeen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Providers/riverpod.dart';

class Qrcodepage extends ConsumerStatefulWidget {
  const Qrcodepage({Key? key}) : super(key: key);

  @override
  ConsumerState<Qrcodepage> createState() => _QrcodepageState();
}

class _QrcodepageState extends ConsumerState<Qrcodepage>
    with WidgetsBindingObserver {
  final MobileScannerController _cameraController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    autoStart: false,
  );
  double _zoom = 0.0;
  bool _torchOn = false;
  bool _hasScanned = false;
  StreamSubscription<Object?>? _barcodeSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _barcodeSubscription = _cameraController.barcodes.listen(_onDetect);
      await _cameraController.start();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required')),
      );
    }
  }

  void _setZoom(double value) {
    if (_zoom != value) {
      setState(() {
        _zoom = value;
      });
      _cameraController.setZoomScale(_zoom);
    }
  }

  void _toggleTorch() async {
    await _cameraController.toggleTorch();
    final newTorchState = _cameraController.torchEnabled;
    if (_torchOn != newTorchState) {
      setState(() {
        _torchOn = newTorchState;
      });
    }
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_hasScanned) return;

    setState(() {
      _hasScanned = true;
    });

    final scannedValue = capture.barcodes.first.rawValue;
    if (scannedValue != null && scannedValue.isNotEmpty) {
      await _cameraController.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QrResultscreeen(
            AcademicYear: ref.watch(riverpodUserData).UserData[0].year!,
            Semester: ref.watch(riverpodUserData).UserData[0].semester!,
            Name: ref.watch(riverpodUserData).UserData[0].initialname!,
            RegisterNo: ref.watch(riverpodUserData).UserData[0].registernumber!,
            qr_scanned: scannedValue,
          ),
        ),
      );
    } else {
      setState(() {
        _hasScanned = false;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_cameraController.value.hasCameraPermission) return;
    switch (state) {
      case AppLifecycleState.resumed:
        _barcodeSubscription = _cameraController.barcodes.listen(_onDetect);
        _cameraController.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _barcodeSubscription?.cancel();
        _barcodeSubscription = null;
        _cameraController.stop();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _barcodeSubscription?.cancel();
    _barcodeSubscription = null;
    _cameraController.stop();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Discoverpage(pagenumber: 1),
              ),
            );
          },
        ),
        title: const Text('QR Scanner', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(2, 109, 148, 1),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(color: const Color.fromRGBO(2, 109, 148, 1)),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: const Color.fromRGBO(245, 245, 245, 1),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Spacer(),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: MobileScanner(
                            controller: _cameraController,
                            onDetect: _onDetect,
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    children: [
                      const Icon(Icons.zoom_out),
                      Expanded(
                        child: Slider(
                          value: _zoom,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: "${(_zoom * 100).toStringAsFixed(0)}%",
                          onChanged: _setZoom,
                        ),
                      ),
                      const Icon(Icons.zoom_in),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.cameraswitch, size: 30),
                      onPressed: () => _cameraController.switchCamera(),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      icon: Icon(
                        _torchOn ? Icons.flash_on : Icons.flash_off,
                        size: 30,
                        color: _torchOn ? Colors.yellow : null,
                      ),
                      onPressed: _toggleTorch,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
