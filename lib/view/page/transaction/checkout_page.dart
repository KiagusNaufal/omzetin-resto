import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omsetin_resto/model/product.dart';
import 'package:omsetin_resto/providers/cashierProvider.dart';
import 'package:omsetin_resto/utils/colors.dart';
import 'package:omsetin_resto/utils/responsif/fsize.dart';
import 'package:omsetin_resto/view/widget/back_button.dart';
import 'package:omsetin_resto/view/widget/confirmation_transaction.dart';
import 'package:omsetin_resto/view/widget/modals.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  final List<Product> selectedProducts;
  final Map<int, int> quantities;
  final int queueNumber;
  final DateTime? lastTranasctionDate;
  final int? transactionId;
  final bool isUpdate;

  const CheckoutPage({
    super.key,
    required this.selectedProducts,
    required this.quantities,
    required this.queueNumber,
    required this.lastTranasctionDate,
    this.transactionId,
    this.isUpdate = false,
  });

  @override
  Widget build(BuildContext context) {
    return DetailCheckoutPage(
      quantities: quantities,
      products: selectedProducts,
      queueNumber: queueNumber,
      lastTransactionDate: lastTranasctionDate,
      transactionId: transactionId,
      isUpdate: isUpdate,
    );
  }
}

class DetailCheckoutPage extends StatefulWidget {
  final List<Product> products;
  final Map<int, int> quantities;
  final int queueNumber;
  final DateTime? lastTransactionDate;
  final int? transactionId;
  final bool isUpdate;

  DetailCheckoutPage({
    super.key,
    required this.products,
    required this.quantities,
    required this.queueNumber,
    required this.lastTransactionDate,
    this.transactionId,
    this.isUpdate = false,
  });

  @override
  _DetailCheckoutPageState createState() => _DetailCheckoutPageState();
}

class _DetailCheckoutPageState extends State<DetailCheckoutPage> {
  String selectedPaymentMethod = "Cash";
  bool isPercentDiscount = false;
  int subtotal = 0;
  int discount = 0;
  int totalItems = 0;
  List<String> _paymentMethods = [];

  @override
  void initState() {
    super.initState();
    _calculateSubtotalAndTotalItems();
    Provider.of<CashierProvider>(context, listen: false)
        .loadCashierDataFromSharedPreferences();
  }

  void _calculateSubtotalAndTotalItems() {
    subtotal = 0;
    totalItems = 0;

    for (int i = 0; i < widget.products.length; i++) {
      final product = widget.products[i];
      final quantity = widget.quantities[product.productId] ?? 1;

      subtotal += product.productSellPrice * quantity;
      totalItems += quantity;
    }
  }

  int get totalPrice =>
      subtotal - (isPercentDiscount ? (subtotal * discount) ~/ 100 : discount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              secondaryColor,
              primaryColor,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: AppBar(
              title: Text(
                "RINCIAN CHECKOUT",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeHelper.Fsize_normalTitle(context),
                  color: bgColor,
                ),
              ),
              centerTitle: true,
              toolbarHeight: kToolbarHeight + 20,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: CustomBackButton(), // Custom back button
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daftar barang
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.products.length + 1,
                      itemBuilder: (context, index) {
                        if (index == widget.products.length) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "SubTotal Produk",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  NumberFormat.currency(
                                          locale: 'id_ID',
                                          symbol: 'Rp.',
                                          decimalDigits: 0)
                                      .format(subtotal),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }

                        final product = widget.products[index];
                        final quantity =
                            widget.quantities[product.productId] ?? 1;
                        return Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 8, top: 10),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              // Gambar barang
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.file(
                                  File(product.productImage.toString()),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      product.productImage,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Detail barang
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product
                                          .productName, // Ganti dengan nama produk
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "$quantity x ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0).format(product.productSellPrice)}",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      "SubTotal ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0).format(product.productSellPrice * quantity)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Subtotal produk

                  const SizedBox(height: 16),
                  // Metode bayar
                  Row(
                    children: [
                      const Text(
                        "Metode Bayar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FutureBuilder<List<String>>(
                          future: databaseService.getPaymentMethods().then(
                                (paymentMethods) => paymentMethods
                                    .map((method) => method.paymentMethodName)
                                    .toList(),
                              ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text(
                                  "Error loading payment methods");
                            } else {
                              _paymentMethods = snapshot.data ?? [];
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedPaymentMethod,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  items: _paymentMethods
                                      .map((method) => DropdownMenuItem(
                                            value: method,
                                            child: Text(method),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPaymentMethod = value!;
                                    });
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  // Diskon
                  Row(
                    children: [
                      // Ikon diskon
                      const Icon(Icons.discount, color: Colors.blue),
                      const SizedBox(width: 8),
                      // Input diskon
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: isPercentDiscount
                                ? "Diskon Persen %"
                                : "Diskon Rupiah Rp",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              discount = NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp. ',
                                      decimalDigits: 0)
                                  .parse(value)
                                  .toInt();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Pilihan diskon
                      Column(
                        children: [
                          Row(
                            children: [
                              const Text("Persen %"),
                              Transform.scale(
                                scale: 0.6,
                                child: Switch(
                                  value: isPercentDiscount,
                                  activeColor: greenColor,
                                  inactiveThumbColor: redColor,
                                  inactiveTrackColor: redColor.withOpacity(0.5),
                                  onChanged: (value) {
                                    setState(() {
                                      isPercentDiscount = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Rupiah Rp"),
                              Transform.scale(
                                scale: 0.6,
                                child: Switch(
                                  value: !isPercentDiscount,
                                  activeColor: greenColor,
                                  inactiveThumbColor: redColor,
                                  inactiveTrackColor: redColor.withOpacity(0.5),
                                  onChanged: (value) {
                                    setState(() {
                                      isPercentDiscount = !value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Gap(110)
                  // Total harga dan tombol bayar
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
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
                        Row(
                          children: [
                            const Text(
                              'Total Jumlah: ',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '$totalItems',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const Text(
                          'TOTAL HARGA',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          NumberFormat.currency(
                                  locale: "id_ID",
                                  decimalDigits: 0,
                                  symbol: "Rp. ")
                              .format(totalPrice),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        List<Map<String, dynamic>> productData =
                            widget.products.map((product) {
                          int quantity =
                              widget.quantities[product.productId] ?? 1;
                          return {
                            'productId': product.productId,
                            'product_barcode': product.productBarcode,
                            'product_barcode_type': product.productBarcodeType,
                            'product_name': product.productName,
                            'product_stock': product.productStock,
                            'product_unit': product.productUnit,
                            'product_sold': product.productSold,
                            'product_purchase_price':
                                product.productPurchasePrice,
                            'product_sell_price': product.productSellPrice,
                            'product_date_added': product.productDateAdded,
                            'product_image': product.productImage,
                            'category_name': product.categoryName,
                            'quantity': quantity,
                          };
                        }).toList();

                        int discountAmount = subtotal - totalPrice;

                        showModalKonfirmasi(
                          context,
                          totalPrice,
                          totalItems,
                          discountAmount,
                          productData,
                          widget.quantities,
                          selectedPaymentMethod,
                          widget.queueNumber,
                          widget.lastTransactionDate,
                          isUpdate: widget.isUpdate,
                          transactionId: widget.transactionId,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'BAYAR',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
