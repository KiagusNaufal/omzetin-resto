import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omsetin_resto/model/expense.dart';
import 'package:omsetin_resto/services/database_service.dart';
import 'package:omsetin_resto/utils/alert.dart';
import 'package:omsetin_resto/utils/colors.dart';
import 'package:omsetin_resto/utils/null_data_alert.dart';
import 'package:omsetin_resto/utils/responsif/fsize.dart';
import 'package:omsetin_resto/utils/successAlert.dart';
import 'package:omsetin_resto/view/widget/back_button.dart';
import 'package:omsetin_resto/view/widget/custom_textfield.dart';
import 'package:intl/intl.dart';
import 'package:omsetin_resto/view/widget/expensiveFloatingButton.dart';

class EditExpensePage extends StatefulWidget {
  final Expense expense;

  EditExpensePage({super.key, required this.expense});

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  late TextEditingController nameController;
  late TextEditingController noteController;
  late TextEditingController amountController;

  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.expense.expenseName);
    noteController = TextEditingController(text: widget.expense.expenseNote);
    amountController = TextEditingController(
      text: NumberFormat.currency(
        locale: 'id',
        symbol: '',
        decimalDigits: 0,
      ).format(widget.expense.expenseAmount),
    );
    selectedDate = widget.expense.expenseDate != null
        ? DateTime.tryParse(widget.expense.expenseDate) ?? DateTime.now()
        : DateTime.now();
  }

  Future<void> editPengeluaran() async {
    final expenseName = nameController.text.trim();
    final expenseNote = noteController.text.trim();
    final expenseAmount = amountController.text.replaceAll('.', '').trim();

    if (expenseName.isEmpty || expenseNote.isEmpty || expenseAmount.isEmpty) {
      showNullDataAlert(context,
          message: "Harap isi semua kolom yang wajib diisi!");
      return;
    }

    Expense updateExpense = Expense(
        expenseId: widget.expense.expenseId ?? 0,
        expenseName: expenseName,
        expenseDateAdded: widget.expense.expenseDateAdded,
        expenseDate: selectedDate.toIso8601String(),
        expenseAmount: int.parse(expenseAmount),
        expenseNote: expenseNote);

    try {
      await _databaseService.updateExpense(updateExpense);
      showSuccessAlert(context, 'Pemasukan berhasil ditambahkan!');
      Navigator.pop(context, true);
    } catch (e) {
      showErrorDialog(context, 'Gagal menambahkan pemasukan: $e');
    }
  }

  TextInputFormatter currencyInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final formatter = NumberFormat.currency(
        locale: 'id',
        symbol: '',
        decimalDigits: 0,
      );
      String newText = newValue.text.replaceAll('.', '');
      if (newText.isNotEmpty) {
        newText = formatter.format(int.parse(newText));
      }
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  secondaryColor,
                  primaryColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: AppBar(
              title: Text(
                'EDIT PEMASUKAN',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeHelper.Fsize_normalTitle(context),
                  color: bgColor,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: CustomBackButton(),
              elevation: 0,
              toolbarHeight: kToolbarHeight + 20,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TextFieldLabel(label: 'Nama pemasukan'),
                                CustomTextField(
                                  fillColor: Colors.grey[200],
                                  obscureText: false,
                                  hintText: "Nama pemasukan...",
                                  prefixIcon: null,
                                  controller: nameController,
                                  maxLines: null,
                                  suffixIcon: null,
                                ),
                                const Gap(10),
                                const TextFieldLabel(label: 'Catatan'),
                                CustomTextField(
                                  fillColor: Colors.grey[200],
                                  obscureText: false,
                                  hintText: "Catatan tentang pemasukan ini...",
                                  prefixIcon: null,
                                  controller: noteController,
                                  maxLines: 5,
                                  suffixIcon: null,
                                ),
                                const Gap(10),
                                const TextFieldLabel(label: 'Nominal'),
                                CustomTextField(
                                  fillColor: Colors.grey[200],
                                  obscureText: false,
                                  hintText: null,
                                  prefixIcon: null,
                                  controller: amountController,
                                  maxLines: null,
                                  suffixIcon: null,
                                  prefixText: "Rp. ",
                                  keyboardType: TextInputType.number,
                                  inputFormatter: [currencyInputFormatter()],
                                ),
                                const Gap(10),
                                const TextFieldLabel(
                                    label: 'Tanggal pemasukan'),
                                GestureDetector(
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (picked != null &&
                                        picked != selectedDate) {
                                      setState(() {
                                        selectedDate = picked;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ExpensiveFloatingButton(
              right: 12,
              left: 12,
              onPressed: () async {
                await editPengeluaran();
              },
            )
          ],
        ),
      ),
    );
  }
}

class TextFieldLabel extends StatelessWidget {
  final String label;

  const TextFieldLabel({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
