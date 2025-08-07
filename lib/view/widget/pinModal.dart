import 'package:flutter/material.dart';
import 'package:omsetin_resto/utils/colors.dart';
import 'package:omsetin_resto/utils/null_data_alert.dart';
import 'package:omsetin_resto/view/widget/pin_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinModal extends StatefulWidget {
  final Widget? destination;
  final Function? onTap;

  const PinModal({
    super.key,
    this.destination,
    this.onTap,
  });

  @override
  State<PinModal> createState() => _PinModalState();
}

class _PinModalState extends State<PinModal> {
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

  void _validatePin(String pin) {
    if (pin == securityPassword.toString()) {
      if (widget.onTap != null) {
        widget.onTap!();
      } else if (widget.destination != null) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => widget.destination!),
        );
      } else {
        Navigator.pop(context);
      }
    } else {
      showNullDataAlert(context, message: "Pin Salah, Silahkan coba kembali.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Masukkan PIN', style: TextStyle(color: Colors.black)),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      content: SizedBox(
        width: double.maxFinite, // penting agar content bisa melar
        child: PinInputWidget(
          controllers: pinControllers,
          onCompleted: (pin) {
            _validatePin(pin);
          },
        ),
      ),
    );
  }
}
