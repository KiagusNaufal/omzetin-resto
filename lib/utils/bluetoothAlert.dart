// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omsetin_resto/providers/bluetoothProvider.dart';
import 'package:omsetin_resto/utils/modal_animation.dart';
import 'package:omsetin_resto/utils/successAlert.dart';
import 'package:omsetin_resto/view/page/settings/scanDevicePrinter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// void playBluetoothAlertSound() async {
//   final player = AudioPlayer();
//   await player.play(AssetSource('sounds/alert.mp3'));
// }

void showBluetoothAlert(BuildContext context) {
  // playBluetoothAlertSound();
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent accidental dismissal
    builder: (BuildContext context) {
      return Consumer<BluetoothProvider>(
        builder: (context, bluetoothProvider, child) {
          // Use a post-frame callback to handle connection changes safely
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (bluetoothProvider.isConnected) {
              Navigator.of(context).pop(); // Close only once
              Future.delayed(Duration(milliseconds: 300), () {
                // Small delay for smooth transition
                showSuccessAlert(context, "Bluetooth Berhasil Terhubung");
              });
            }
          });

          return Center(
            child: ModalAnimation(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                width: MediaQuery.of(context).size.width <= 400 ? 280 : 300,
                padding: const EdgeInsets.all(16.0),
                height: null,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          'assets/lottie/bluetooth-alert.json',
                          width: 150,
                          height: 150,
                        ),
                        Text(
                          'Bluetooth Tidak Terhubung',
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width <= 400
                                ? 14
                                : 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text:
                                'Hubungkan ke perangkat Bluetooth atau atur di ',
                            style: GoogleFonts.poppins(
                              fontSize: MediaQuery.of(context).size.width <= 400
                                  ? 13
                                  : 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Halaman Scan Bluetooth',
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      MediaQuery.of(context).size.width <= 400
                                          ? 13
                                          : 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .pop(); // Close dialog first
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ScanDevicePrinter(),
                                      ),
                                    );
                                  },
                              ),
                              TextSpan(
                                text: '.',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showBluetoothAlert2(BuildContext context) {
  // playBluetoothAlertSound();
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return Consumer<BluetoothProvider>(
        builder: (context, bluetoothProvider, child) {
          // Add listener for connection state changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (bluetoothProvider.isConnected) {
              Navigator.of(context).pop(); // Close the alert first
              showSuccessAlert(context, "Bluetooth Berhasil Terhubung");
            }
          });

          return Center(
            child: ModalAnimation(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                width: MediaQuery.of(context).size.width <= 400 ? 280 : 300,
                padding: const EdgeInsets.all(16.0),
                height: null,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          'assets/lottie/bluetooth-alert.json',
                          width: 150,
                          height: 150,
                        ),
                        Text(
                          'Bluetooth Tidak Terhubung',
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width <= 400
                                ? 14
                                : 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text:
                                'Hubungkan ke perangkat Bluetooth atau atur di ',
                            style: GoogleFonts.poppins(
                              fontSize: MediaQuery.of(context).size.width <= 400
                                  ? 13
                                  : 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Halaman Scan Bluetooth',
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      MediaQuery.of(context).size.width <= 400
                                          ? 13
                                          : 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(
                                        context); // Close the dialog first
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScanDevicePrinter()),
                                    );
                                  },
                              ),
                              TextSpan(
                                text: '.',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
