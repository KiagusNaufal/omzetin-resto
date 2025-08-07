import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omsetin_resto/utils/colors.dart';
import 'package:omsetin_resto/utils/modal_animation.dart';
import 'package:lottie/lottie.dart';
import 'package:gap/gap.dart';

// void playSuccessSound() async {
//   final player = AudioPlayer();
//   await player.play(AssetSource('sounds/success-2.mp3'));
// }

void showFailedAlert(BuildContext context, {String? message}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 2), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
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
            width: 300,
            height: 300,
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/lottie/failed.json',
                        width: 150,
                        height: 150,
                      ),
                      const Gap(10),
                      Text(
                        message ?? 'Ada kesalahan, coba ulangi kembali!',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
