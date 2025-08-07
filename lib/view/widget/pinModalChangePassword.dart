import 'package:flutter/material.dart';
import 'package:omsetin_resto/providers/securityProvider.dart';
import 'package:omsetin_resto/utils/colors.dart';
import 'package:omsetin_resto/utils/null_data_alert.dart';
import 'package:omsetin_resto/utils/successAlert.dart';
import 'package:omsetin_resto/view/widget/pin_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinModalChangePassword extends StatefulWidget {
  final Widget? destination;
  final Function? onTap;

  const PinModalChangePassword({
    super.key,
    this.destination,
    this.onTap,
  });

  @override
  State<PinModalChangePassword> createState() => _PinModalChangePasswordState();
}

class _PinModalChangePasswordState extends State<PinModalChangePassword> {
  List<TextEditingController> pinControllers =
      List.generate(6, (index) => TextEditingController());

  int? securityPassword;

  @override
  void initState() {
    super.initState();
    _loadSecurityPassword();
  }

  void _loadSecurityPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    securityPassword = prefs.getInt('securityPassword') ?? null;
  }

  Future<void> _changePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('securityPassword', int.parse(pin));
    Provider.of<SecurityProvider>(context, listen: false).reloadPreferences();

    showSuccessAlert(context, "Pin keamanan berhasil diperbarui!");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Masukkan PIN Baru',
            style: TextStyle(color: Colors.black),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      content: SizedBox(
          width: double.maxFinite,
          child: PinInputWidget(
            controllers: pinControllers,
            obscure: false,
          )),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            elevation: 0,
          ),
          onPressed: () async {
            String pin =
                pinControllers.map((controller) => controller.text).join();

            if (pin.length != 6 || int.tryParse(pin) == null) {
              showNullDataAlert(context, message: "PIN harus 6 digit angka.");
              return;
            }

            if (pin == securityPassword.toString()) {
              showNullDataAlert(context,
                  message: "PIN masih sama dengan sebelumnya!");
              return;
            }

            await _changePin(pin);
          },
          child: Text(
            'Ganti',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
