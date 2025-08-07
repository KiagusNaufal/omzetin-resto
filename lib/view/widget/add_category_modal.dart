import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:omsetin_resto/providers/securityProvider.dart';
import 'package:omsetin_resto/services/database_service.dart';
import 'package:omsetin_resto/utils/colors.dart';
import 'package:omsetin_resto/utils/failedAlert.dart';
import 'package:omsetin_resto/utils/null_data_alert.dart';
import 'package:omsetin_resto/utils/pinModalWithAnimation.dart';
import 'package:omsetin_resto/utils/successAlert.dart';
import 'package:omsetin_resto/view/widget/pinModal.dart';
import 'package:provider/provider.dart';

import 'dart:async';

Future<bool> createCategoryModal({
  required BuildContext context,
  required TextEditingController productCreateCategoryController,
  required FocusNode categoryFocusNode,
  required DatabaseService databaseService,
}) async {
  final completer = Completer<bool>(); // Digunakan untuk menunggu hasil
  var securityProvider = Provider.of<SecurityProvider>(context, listen: false);

  if (securityProvider.tambahKategori) {
    showPinModalWithAnimation(
      context,
      pinModal: PinModal(
        destination: null,
        onTap: () {
          print("Pin modal OK button pressed");
          Navigator.pop(context);

          showDialog(
            context: context,
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                categoryFocusNode.requestFocus();
              });
              return AlertDialog(
                backgroundColor: primaryColor,
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tambah Kategori',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: productCreateCategoryController,
                      focusNode: categoryFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        hintText: 'Nama Kategori',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: cardColor,
                      ),
                    ),
                    const Gap(5),
                    ElevatedButton(
                      onPressed: () async {
                        final categoryName =
                            productCreateCategoryController.text;
                        if (categoryName.isNotEmpty) {
                          final db = await databaseService.database;
                          final data = await db.rawQuery('''
                                SELECT *
                                FROM categories WHERE category_name = ?
                          ''', [categoryName]);

                          if (data.isNotEmpty) {
                            showFailedAlert(context,
                                message: "Kategori sudah ada!");
                          } else {
                            await databaseService.addCategory(
                              categoryName,
                              DateTime.now().toIso8601String(),
                            );
                            showSuccessAlert(context,
                                'Kategori "$categoryName" berhasil ditambahkan! ');
                            Navigator.pop(context, true);
                            completer.complete(true); // Selesaikan dengan true
                          }
                        } else {
                          showNullDataAlert(context,
                              message: "Nama Kategori Tidak Boleh Kosong");
                          return;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: secondaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Center(
                        child: Text(
                          "SIMPAN",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          categoryFocusNode.requestFocus();
        });
        return AlertDialog(
          backgroundColor: primaryColor,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tambah Kategori',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productCreateCategoryController,
                focusNode: categoryFocusNode,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  hintText: 'Nama Kategori',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: cardColor,
                ),
              ),
              const Gap(5),
              ElevatedButton(
                onPressed: () async {
                  final categoryName = productCreateCategoryController.text;
                  if (categoryName.isNotEmpty) {
                    final db = await databaseService.database;
                    final data = await db.rawQuery('''
                            SELECT *
                            FROM categories WHERE category_name = ?
                    ''', [categoryName]);

                    if (data.isNotEmpty) {
                      showFailedAlert(context, message: "Kategori sudah ada!");
                    } else {
                      await databaseService.addCategory(
                        categoryName,
                        DateTime.now().toIso8601String(),
                      );
                      showSuccessAlert(context,
                          'Kategori "$categoryName" berhasil ditambahkan! ');
                      Navigator.pop(context, true);
                      completer.complete(true); // Selesaikan dengan true
                    }
                  } else {
                    showNullDataAlert(context,
                        message: "Nama Kategori Tidak Boleh Kosong");
                    return;
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Center(
                  child: Text(
                    "SIMPAN",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
  return completer.future; // Tunggu hingga proses selesai
}
