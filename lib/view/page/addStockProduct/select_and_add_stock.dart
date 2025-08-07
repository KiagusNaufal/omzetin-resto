import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omsetin_resto/model/product.dart';
import 'package:omsetin_resto/services/database_service.dart';
import 'package:omsetin_resto/utils/colors.dart';
import 'package:omsetin_resto/utils/null_data_alert.dart';
import 'package:omsetin_resto/utils/responsif/fsize.dart';
import 'package:omsetin_resto/utils/toast.dart';
import 'package:omsetin_resto/view/page/addStockProduct/add_stock_product.dart';
import 'package:omsetin_resto/view/page/addStockProduct/select_product.dart';
import 'package:omsetin_resto/view/widget/Notfound.dart';
import 'package:omsetin_resto/view/widget/add_product_stock_card.dart';
import 'package:omsetin_resto/view/widget/app_bar_stock.dart';
import 'package:omsetin_resto/view/widget/expensiveFloatingButton.dart';
import 'package:gap/gap.dart';

class SelectAndAddStockProduct extends StatefulWidget {
  final List<Product>? selectedProductStock;
  const SelectAndAddStockProduct({super.key, this.selectedProductStock});

  @override
  State<SelectAndAddStockProduct> createState() =>
      _SelectAndAddStockProductState();
}

class _SelectAndAddStockProductState extends State<SelectAndAddStockProduct> {
  List<Product> _selectedProductStock = [];
  List<Product> selectedProductStock = [];
  Map<String, int> productAmounts = {}; // Store amounts for each product
  Map<String, TextEditingController> noteControllers = {};

  @override
  void initState() {
    super.initState();
    selectedProductStock = widget.selectedProductStock ?? [];
  }

  void refreshPage() {
    setState(() {
      selectedProductStock = _selectedProductStock;
    });
  }

  Future<void> saveSelectedProductStock() async {
    final DatabaseService databaseService = DatabaseService.instance;
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    List<Map<String, dynamic>> stockAdditions = [];

    for (var product in selectedProductStock) {
      int amount = productAmounts[product.productId.toString()] ?? 0;
      String note = noteControllers[product.productId.toString()]?.text ?? '';

      if (amount > 0) {
        stockAdditions.add({
          'stock_addition_name': product.productName,
          'stock_addition_date': formattedDate,
          'stock_addition_amount': amount,
          'stock_addition_note':
              note.isNotEmpty ? note : 'Penambahan stok otomatis',
          'stock_addition_product_id': product.productId,
        });
      }
    }

    if (stockAdditions.isNotEmpty) {
      for (var stockData in stockAdditions) {
        await databaseService.addProductStock(stockData);
      }
      print('Stok produk berhasil disimpan ke database!');
    } else {
      print('Tidak ada stok yang ditambahkan.');
    }
  }

  Future<void> _updateJumlahStockProduct() async {
    final DatabaseService databaseService = DatabaseService.instance;

    for (var product in selectedProductStock) {
      int amount = productAmounts[product.productId.toString()] ?? 0;
      int productStock = product.productStock;
      int newStock = productStock + amount;
      await databaseService.updateProductStock(product.productId, newStock);
    }
  }

  Future<void> _validateAndSaveStock() async {
    bool hasValidStock = false;

    for (var product in selectedProductStock) {
      int amount = productAmounts[product.productId.toString()] ?? 0;
      if (amount > 0) {
        hasValidStock = true;
        break;
      }
    }

    if (!hasValidStock) {
      showNullDataAlert(
        context,
        message: "Harap isi jumlah stok minimal untuk satu produk!",
      );
      return;
    }

    try {
      await _updateJumlahStockProduct();
      await saveSelectedProductStock();

      Navigator.pop(context, true); // balik ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menambahkan stok produk: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Column(
            children: [
              AppBarStock(
                appBarText: "TAMBAH STOK PRODUK",
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectProduct(
                                  selectedProductStock: selectedProductStock),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              selectedProductStock = List<Product>.from(result);
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Pilih Produk",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: selectedProductStock.isEmpty
                    ? NotFoundPage(title: "Belum ada produk yang dipilih!")
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(4, 4, 4, 80),
                        itemCount: selectedProductStock.length,
                        itemBuilder: (context, index) {
                          final productSelectedList =
                              selectedProductStock[index];
                          return StockCardScreen(
                            product: productSelectedList,
                            onAmountChanged: (amount) {
                              setState(() {
                                productAmounts[productSelectedList.productId
                                    .toString()] = amount;
                              });
                            },
                            noteController: noteControllers.putIfAbsent(
                              productSelectedList.productId.toString(),
                              () => TextEditingController(),
                            ),
                          );
                        },
                      ),
              ),
              // const SizedBox(
              //     height: 130),
            ],
          ),
          ExpensiveFloatingButton(
              left: 15,
              right: 15,
              text: "SIMPAN",
              onPressed: _validateAndSaveStock),
        ],
      ),
    );
  }
}
