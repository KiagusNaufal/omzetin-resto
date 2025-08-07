import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:omsetin_resto/model/paymentMethod.dart';
import 'package:omsetin_resto/providers/securityProvider.dart';
import 'package:omsetin_resto/services/database_service.dart';
import 'package:omsetin_resto/utils/colors.dart';
import 'package:omsetin_resto/utils/failedAlert.dart';
import 'package:omsetin_resto/utils/modal_animation.dart';
import 'package:omsetin_resto/utils/null_data_alert.dart';
import 'package:omsetin_resto/utils/responsif/fsize.dart';
import 'package:omsetin_resto/utils/successAlert.dart';
import 'package:omsetin_resto/view/widget/back_button.dart';
import 'package:omsetin_resto/view/widget/bottomSheetModal.dart';
import 'package:omsetin_resto/view/widget/confirm_delete_dialog.dart';
import 'package:omsetin_resto/view/widget/expensiveFloatingButton.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PaymentManagement extends StatefulWidget {
  const PaymentManagement({super.key});

  @override
  State<PaymentManagement> createState() => _PaymentManagementState();
}

class _PaymentManagementState extends State<PaymentManagement> {
  TextEditingController _searchController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;

  TextEditingController _updatePaymentMethodController =
      TextEditingController();
  TextEditingController _addPaymentMethodController = TextEditingController();

  List<PaymentMethod> _futurePayment = [];

  void _addPaymentMethod() async {
    try {
      if (_addPaymentMethodController.text.isEmpty) {
        showNullDataAlert(context, message: "Input tidak boleh kosong!");
        return;
      }

      final existingMethods = await _databaseService.getPaymentMethods();
      if (existingMethods.any((method) =>
          method.paymentMethodName.toLowerCase() ==
          _addPaymentMethodController.text.toLowerCase())) {
        showNullDataAlert(context, message: "Metode Pembayaran sudah ada!");
        return;
      }

      _databaseService.insertPaymentMethod(
          _addPaymentMethodController.text, '');

      showSuccessAlert(context, "Berhasil menambahkan Metode Pembayaran baru.");

      setState(() {
        _loadPaymentMethod();
      });

      Navigator.of(context).pop();
    } catch (e) {
      showFailedAlert(context, message: "Ada kesalahan, Silahkan Lapor Admin!");
    }
  }

  Future<void> _loadPaymentMethod() async {
    final paymentMethod = await _databaseService.getPaymentMethods();
    setState(() {
      _futurePayment = paymentMethod;
    });
  }

  Future<void> _deletePaymentMethod(int payment) async {
    try {
      await _databaseService.deletePaymentMethod(payment);
      showSuccessAlert(context, "Metode Pembayaran berhasil dihapus.");
      setState(() {
        _loadPaymentMethod();
      });
    } catch (e) {
      showFailedAlert(context, message: "Gagal menghapus Metode Pembayaran.");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPaymentMethod();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var securityProvider = Provider.of<SecurityProvider>(context);

    return Scaffold(
        backgroundColor: bgColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 20),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                secondaryColor,
                primaryColor,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  "KELOLA METODE PEMBAYARAN",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeHelper.Fsize_title1(context),
                    color: bgColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                elevation: 0,
                toolbarHeight: kToolbarHeight + 20,
                centerTitle: true,
                leading: const CustomBackButton(),
              ),
            ),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Gap(10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _futurePayment.length,
                        itemBuilder: (context, index) {
                          final payment = _futurePayment[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (payment.paymentMethodId.toString() !=
                                          "1" &&
                                      payment.paymentMethodId.toString() !=
                                          "2") {
                                    if (securityProvider.editMetode) {
                                      bottomSheetModal(context,
                                          title: "Ubah Metode Bayar",
                                          controller:
                                              _updatePaymentMethodController,
                                          hintText: "Ubah Metode Pembayaran",
                                          onPressed: () {
                                        _databaseService
                                            .updatePaymentMethodName(
                                                payment.paymentMethodId,
                                                _updatePaymentMethodController
                                                    .text);
                                        showSuccessAlert(context,
                                            "Metode Pembayaran berhasil diubah!");

                                        setState(() {
                                          _loadPaymentMethod();
                                          _updatePaymentMethodController.text =
                                              "";
                                        });

                                        Navigator.pop(context);
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    children: [
                                      Text(
                                        _futurePayment[index].paymentMethodName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width <=
                                                    400
                                                ? 16
                                                : 18),
                                      ),
                                      Spacer(),
                                      // jika payment method id nya 1 dan 2 maka action delete tidak ada, karena sudah default
                                      if (payment.paymentMethodId.toString() !=
                                              "1" &&
                                          payment.paymentMethodId.toString() !=
                                              "2")

                                        // CONFIRM
                                        if (securityProvider.hapusMetode)
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return ConfirmDeleteDialog(
                                                      message:
                                                          "Hapus metode pembayaran ini?",
                                                      onConfirm: () async {
                                                        await _databaseService
                                                            .deletePaymentMethod(
                                                                payment
                                                                    .paymentMethodId);

                                                        Navigator.pop(
                                                            context, true);

                                                        showSuccessAlert(
                                                            context,
                                                            "Metode Pembayaran berhasil dihapus!");

                                                        setState(() {
                                                          _loadPaymentMethod();
                                                        });
                                                      },
                                                    );
                                                  });
                                            },
                                            child: const Iconify(
                                              Bi.trash,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                              Gap(10),
                            ],
                          );
                        },
                      ),
                    ),
                    Gap(MediaQuery.of(context).size.width <= 400 ? 80 : 60),
                  ],
                ),
                if (securityProvider.tambahMetode)
                  ExpensiveFloatingButton(
                    bottom: 25,
                    onPressed: () {
                      bottomSheetModal(context,
                          title: "Tambah Metode Bayar",
                          hintText: "Masukkan Metode Bayar",
                          controller: _addPaymentMethodController,
                          onPressed: _addPaymentMethod);
                    },
                    text: "TAMBAH",
                  )
              ],
            )));
  }
}
