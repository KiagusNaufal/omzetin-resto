import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:intl/intl.dart';
import 'package:omsetin_resto/model/product.dart';
import 'package:omsetin_resto/services/database_service.dart';
import 'package:omsetin_resto/utils/alert.dart';
import 'package:omsetin_resto/utils/colors.dart';
import 'package:omsetin_resto/utils/null_data_alert.dart';
import 'package:omsetin_resto/utils/responsif/fsize.dart';
import 'package:omsetin_resto/view/page/transaction/checkout_page.dart';
import 'package:omsetin_resto/view/page/transaction/select_product_page.dart';
import 'package:omsetin_resto/view/widget/antrian.dart';
import 'package:omsetin_resto/view/widget/back_button.dart';
import 'package:omsetin_resto/view/widget/card_transaction.dart';
import 'package:omsetin_resto/view/widget/expensiveFloatingButton.dart';
import 'package:omsetin_resto/view/widget/floating_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionPage extends StatefulWidget {
  final List<Product> selectedProducts;
  final Map<int, int>? initialQuantities;
  final int? transactionId;
  final bool isUpdate;

  const TransactionPage({
    super.key,
    required this.selectedProducts,
    this.initialQuantities,
    this.transactionId,
    this.isUpdate = false,
  });

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final Map<int, int> _quantities = {};
  double totalTransaksi = 0;
  int queueNumber = 1;
  bool isAutoReset = false;
  bool nonActivateQueue = false;
  final DatabaseService databaseService = DatabaseService.instance;

  Future<void> _loadQueueAndisAutoResetValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      queueNumber = prefs.getInt('queueNumber') ?? 1;
      isAutoReset = prefs.getBool('isAutoReset') ?? false;
      nonActivateQueue = prefs.getBool('nonActivateQueue') ?? false;

      if (nonActivateQueue == true) {
        queueNumber = 0;
      }
    });

    print('''
      loaded: 
      queueNumber: $queueNumber,
      isAutoReset: $isAutoReset,
      nonActivateQueue: $nonActivateQueue
    ''');
  }

  DateTime? lastTransactionDate;

  @override
  void initState() {
    super.initState();
    _loadQueueAndisAutoResetValue();

    if (widget.isUpdate && widget.transactionId != null) {
      _loadQueueNumberFromTransaction(widget.transactionId!);
    }

    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {});
    });

    _initializeProductsWithStockValidation();

    _calculateTotalTransaksi();
  }

  Future<void> _loadQueueNumberFromTransaction(int id) async {
    final transaction = await databaseService.getTransactionById(id);

    if (transaction != null) {
      setState(() {
        queueNumber = transaction.transactionQueueNumber;
      });
    }
  }

  Future<void> _initializeProductsWithStockValidation() async {
    final List<Product> validProducts = [];

    for (var product in widget.selectedProducts) {
      final initialQty = widget.initialQuantities?[product.productId] ?? 1;
      final availableStock =
          await databaseService.getProductStockById(product.productId);

      if (availableStock != null && availableStock >= initialQty) {
        validProducts.add(product);
        _quantities[product.productId] = initialQty;
      } else {
        if (widget.isUpdate) {
          validProducts.add(product);
          _quantities[product.productId] = initialQty;

          showWarningDialog(
            context,
            "Stok Makanan ${product.productName} sekarang kurang dari jumlah transaksi sebelumnya. Tetap edit?",
          );
        } else {
          showErrorDialog(
            context,
            "Stok Makanan ${product.productName} tidak mencukupi!",
          );
        }
      }
    }

    setState(() {
      widget.selectedProducts
        ..clear()
        ..addAll(validProducts);
      _calculateTotalTransaksi();
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _calculateTotalTransaksi() {
    double total = 0;
    for (var product in widget.selectedProducts) {
      final productId = product.productId;
      total += product.productSellPrice * (_quantities[productId] ?? 1);
    }
    setState(() {
      totalTransaksi = total;
    });
  }

  void _updateTotalPerItem(int index, int quantity) {
    final productId = widget.selectedProducts[index].productId;
    setState(() {
      _quantities[productId] = quantity;
      _calculateTotalTransaksi();
    });
  }

  void _removeProduct(int index) {
    final productId = widget.selectedProducts[index].productId;
    setState(() {
      widget.selectedProducts.removeAt(index);
      _quantities.remove(productId);
      _calculateTotalTransaksi();
    });
  }

  void _navigateToSelectProductPage() async {
    final List<Product>? newSelectedProducts = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectProductPage(
          selectedProducts: [...widget.selectedProducts],
        ),
      ),
    );

    if (newSelectedProducts != null) {
      setState(() {
        // Use a Set to automatically remove duplicates based on productId
        final uniqueProductsSet = <int, Product>{};

        // Add existing products to the set
        for (var product in widget.selectedProducts) {
          uniqueProductsSet[product.productId] = product;
        }

        // Add new products to the set (duplicates will be overwritten)
        for (var product in newSelectedProducts) {
          if (uniqueProductsSet.containsKey(product.productId)) {
            print("Makanan dengan ID ${product.productId} dipilih!");
          } else {
            uniqueProductsSet[product.productId] = product;
          }
        }

        // Convert the set values back to a list
        widget.selectedProducts.clear();
        widget.selectedProducts.addAll(uniqueProductsSet.values);
        for (var product in newSelectedProducts) {
          _quantities.putIfAbsent(product.productId, () => 1);
        }

        // Recalculate total transaction
        _calculateTotalTransaksi();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [secondaryColor, primaryColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: AppBar(
              backgroundColor: Colors.transparent,
              leading: const CustomBackButton(),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      final result = await showModalQueue(
                          context, queueNumber, isAutoReset, nonActivateQueue);
                      if (result != null) {
                        print(result);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setInt(
                            'queueNumber', result['queueNumber']);
                        await prefs.setBool(
                            'isAutoReset', result['isAutoReset']);

                        await _loadQueueAndisAutoResetValue();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              "Antrian",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
              title: Text(
                'TRANSAKSI',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeHelper.Fsize_normalTitle(context),
                  color: bgColor,
                ),
              ),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3 / 1,
                    ),
                    itemCount: widget.selectedProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = widget.selectedProducts[index];
                      return CardTransaction(
                        key: ValueKey(product.productId),
                        product: product,
                        initialQuantity: _quantities[product.productId] ?? 1,
                        onQuantityChanged: (quantity) {
                          _updateTotalPerItem(index, quantity);
                        },
                        onDelete: () {
                          _removeProduct(index);
                        },
                        onEdit: (editedProduct) {
                          _navigateToSelectProductPage();
                        },
                      );
                    },
                  ),
                ),
                Gap(18),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment(0, 2),
                      end: Alignment(-0, -2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TOTAL TRANSAKSI',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp. ',
                                    decimalDigits: 0)
                                .format(totalTransaksi),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.selectedProducts.isEmpty) {
                            showNullDataAlert(context);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  quantities: _quantities,
                                  queueNumber: queueNumber,
                                  lastTranasctionDate: lastTransactionDate,
                                  selectedProducts:
                                      widget.selectedProducts.toList(),
                                  transactionId: widget.transactionId,
                                  isUpdate: widget.isUpdate,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'BAYAR',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ExpensiveFloatingButton(
              onPressed: _navigateToSelectProductPage,
              text: 'PILIH MAKANAN',
              right: 12,
              left: 12,
              bottom: 100,
            ),
          ],
        ),
      ),
    );
  }
}
