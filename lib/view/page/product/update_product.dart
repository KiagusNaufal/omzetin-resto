import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/mdi_light.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:omsetin_resto/model/code.dart';
import 'package:omsetin_resto/model/product.dart';
import 'package:omsetin_resto/providers/bluetoothProvider.dart';
import 'package:omsetin_resto/providers/securityProvider.dart';
import 'package:omsetin_resto/services/database_service.dart';
import 'package:omsetin_resto/utils/bluetoothAlert.dart';
import 'package:omsetin_resto/utils/colors.dart';
import 'package:omsetin_resto/utils/failedAlert.dart';
import 'package:omsetin_resto/utils/formatters.dart';
import 'package:omsetin_resto/utils/image.dart';
import 'package:omsetin_resto/utils/null_data_alert.dart';
import 'package:omsetin_resto/utils/printer_helper.dart';
import 'package:omsetin_resto/utils/responsif/fsize.dart';
import 'package:omsetin_resto/utils/successAlert.dart';
import 'package:omsetin_resto/view/page/product/select_category.dart';
import 'package:omsetin_resto/view/page/qr_code_scanner.dart';
import 'package:omsetin_resto/view/widget/add_category_modal.dart';
import 'package:omsetin_resto/view/widget/back_button.dart';
import 'package:omsetin_resto/view/widget/custom_textfield.dart';
import 'package:omsetin_resto/view/widget/expensiveFloatingButton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class UpdateProductPage extends StatefulWidget {
  final Product? product;

  const UpdateProductPage({super.key, required this.product});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  // db

  final DatabaseService _databaseService = DatabaseService.instance;

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productBarcodeController =
      TextEditingController();
  final TextEditingController _productStockController = TextEditingController();
  final TextEditingController _productSatuanController =
      TextEditingController();
  final TextEditingController _productHargaBeliController =
      TextEditingController(text: '0');
  final TextEditingController _productHargaJualController =
      TextEditingController(text: '0');
  final TextEditingController _productCreateCategoryController =
      TextEditingController();
  final TextEditingController _productCategoryController =
      TextEditingController();
  final TextEditingController _productBarcodeTypeController =
      TextEditingController(text: "barcode");
  final TextEditingController _productBarcodeTextController =
      TextEditingController(text: "Barcode Saja");
  final TextEditingController _keuntunganController = TextEditingController();
  final TextEditingController _persentaseController = TextEditingController();
  final TextEditingController _productSoldController =
      TextEditingController(text: "0");
  final TextEditingController _productIdController = TextEditingController();

  // focus node for add category textfield
  final FocusNode _categoryFocusNode = FocusNode();

  File? image;

  void _validateImage() {
    if (image?.path == noImage) {
      setState(() {
        image = null;
      });
    }
  }

  bool _isBarcodeFilled = false;
  bool _isChecked = false;

  String noImage = "assets/products/no-image.png";

  void _checkBarcodeInput() {
    setState(() {
      _productBarcodeController.text.isNotEmpty
          ? _isBarcodeFilled = true
          : _isBarcodeFilled = false;
    });
  }

  void _handleCheckboxChange(bool? value) {
    setState(() {
      _isChecked = value ?? false;
      if (_isChecked) {
        _productStockController.text = '0';
      }
    });
  }

  void _checkboxChangeStatus() {
    if (widget.product!.productStock == 0) {
      _isChecked = true;
    } else {
      _isChecked = false;
    }
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return formatter.format(value);
  }

  Future pickImage(ImageSource source, context) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      Navigator.pop(context);
      if (pickedImage == null) return;

      final imageTemporary = File(pickedImage.path);
      print(pickedImage);
      setState(() => this.image = imageTemporary);

      final croppedImage = await cropImage(imageTemporary);

      if (croppedImage != null) {
        setState(() {
          image = croppedImage;
        });
      }
    } on PlatformException catch (e) {
      print("Error: $e");
    }
  }

  Future<void> scanQRCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrCodeScanner()),
    );

    if (result != null && mounted) {
      setState(() {
        _productBarcodeController.text = result;
        _checkBarcodeInput();
      });
    }
  }

  void _selectCameraOrGalery() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => pickImage(ImageSource.camera, context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Iconify(
                    MdiLight.camera,
                    size: 40,
                  ),
                  Gap(10),
                  Text(
                    "Kamera",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const Gap(15),
            const Divider(
              color: Colors.black,
              indent: 1.0,
            ),
            const Gap(15),
            GestureDetector(
              onTap: () => pickImage(ImageSource.gallery, context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Iconify(
                    Ion.ios_albums_outline,
                    size: 40,
                  ),
                  Gap(15),
                  Text(
                    "Galeri",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBarcodeModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Type Code',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Iconify(
                        Ion.close_circled,
                        color: Colors.white,
                        size: 20,
                      ))
                ],
              ),
              const Gap(10),
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 14, 94, 134),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(
                    top: 5, right: 10, bottom: 5, left: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Saat ini:',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Text(
                          _productBarcodeTextController.text,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 36, 99, 131),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: SingleChildScrollView(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: itemQRCode.length,
                itemBuilder: (context, index) {
                  return ZoomTapAnimation(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        // ini untuk teks yang ada di button nya
                        _productBarcodeTextController.text =
                            itemQRCode[index].text;
                        // ini untuk teks yang akan di kirim lewat
                        _productBarcodeTypeController.text =
                            itemQRCode[index].type;
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.asset(
                                  itemQRCode[index].image,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Text(
                              itemQRCode[index].text,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkBarcodeInput();
    _productHargaBeliController.addListener(() => _onFieldChanged('beli'));
    _productHargaJualController.addListener(() => _onFieldChanged('jual'));
    _persentaseController.addListener(() => _onFieldChanged('persen'));
    _keuntunganController.addListener(() => _onFieldChanged('untung'));
    // auto format
    _productHargaBeliController.addListener(() {
      final formatter = NumberFormat.decimalPattern('id');
      int value =
          int.tryParse(_productHargaBeliController.text.replaceAll('.', '')) ??
              0;
      String newText = formatter.format(value);
      if (_productHargaBeliController.text != newText) {
        _productHargaBeliController.value =
            _productHargaBeliController.value.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    });

    // auto format hargaJual
    _productHargaJualController.addListener(() {
      final formatter = NumberFormat.decimalPattern('id');
      int value =
          int.tryParse(_productHargaJualController.text.replaceAll('.', '')) ??
              0;
      String newText = formatter.format(value);
      if (_productHargaJualController.text != newText) {
        _productHargaJualController.value =
            _productHargaJualController.value.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    });

    _keuntunganController.addListener(() {
      final formatter = NumberFormat.decimalPattern('id');
      int value =
          int.tryParse(_keuntunganController.text.replaceAll('.', '')) ?? 0;
      String newText = formatter.format(value);
      if (_keuntunganController.text != newText) {
        _keuntunganController.value = _keuntunganController.value.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    });

    _validateImage();
    _checkboxChangeStatus();
    _productNameController.text = widget.product!.productName;
    _productIdController.text = widget.product!.productId.toString();
    _productBarcodeController.text = widget.product!.productBarcode;
    _productStockController.text = widget.product!.productStock.toString();
    _productSatuanController.text = widget.product!.productUnit;
    _productHargaBeliController.text =
        widget.product!.productPurchasePrice.toString();
    _productHargaJualController.text =
        widget.product!.productSellPrice.toString();
    _productCategoryController.text = widget.product!.categoryName ?? '';
    _productSoldController.text = widget.product!.productSold.toString();
    image = File(widget.product!.productImage);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productBarcodeController.dispose();
    _productStockController.dispose();
    _productHargaBeliController.dispose();
    _productHargaJualController.dispose();
    _productCategoryController.dispose();
    _productSoldController.dispose();
    _keuntunganController.dispose();
    _persentaseController.dispose();

    _productHargaBeliController.dispose();
    _productHargaJualController.dispose();
    _keuntunganController.dispose();
    _persentaseController.dispose();
    super.dispose();
  }

  bool _isManual = false;
  final formatterDecimal = NumberFormat.decimalPattern('id');
  void _onFieldChanged(String source) {
    if (_isManual) return;

    _isManual = true;

    final beli =
        int.tryParse(_productHargaBeliController.text.replaceAll('.', '')) ?? 0;
    final jual =
        int.tryParse(_productHargaJualController.text.replaceAll('.', '')) ?? 0;
    final persen =
        double.tryParse(_persentaseController.text.replaceAll(',', '.')) ?? 0;
    final untung =
        int.tryParse(_keuntunganController.text.replaceAll('.', '')) ?? 0;

    switch (source) {
      case 'beli':
        if (jual > 0) {
          final u = jual - beli;
          final p = beli > 0 ? (u / beli * 100) : 0;
          _keuntunganController.text = u.toString();
          _persentaseController.text = p.toStringAsFixed(2);
        } else if (persen > 0) {
          final u = (beli * persen / 100).round();
          _keuntunganController.text = u.toString();
          _productHargaJualController.text = (beli + u).toString();
        } else if (untung > 0) {
          _productHargaJualController.text = (beli + untung).toString();
          final p = beli > 0 ? (untung / beli * 100) : 0;
          _persentaseController.text = p.toStringAsFixed(2);
        }
        break;

      case 'jual':
        final u = jual - beli;
        final p = beli > 0 ? (u / beli * 100) : 0;
        _keuntunganController.text = u.toString();
        _persentaseController.text = p.toStringAsFixed(2);
        break;

      case 'persen':
        final u = (beli * persen / 100).round();
        _keuntunganController.text = u.toString();
        _productHargaJualController.text = (beli + u).toString();
        break;

      case 'untung':
        _productHargaJualController.text = (beli + untung).toString();
        final p = beli > 0 ? (untung / beli * 100) : 0;
        _persentaseController.text = p.toStringAsFixed(2);
        break;
    }

    _isManual = false;
  }

  Future<void> _updateProduct() async {
    final productName = _productNameController.text;
    final productBarcode = _productBarcodeController.text;
    final productStock = int.tryParse(_productStockController.text) ?? 0;
    final productSatuan = _productSatuanController.text;
    final productHargaBeli =
        int.tryParse(_productHargaBeliController.text.replaceAll('.', '')) ?? 0;
    final productHargaJual =
        int.tryParse(_productHargaJualController.text.replaceAll('.', '')) ?? 0;
    final productCategory = _productCategoryController.text;
    final productSold = int.tryParse(_productSoldController.text) ?? 0;
    //  image?.path ?? widget.product!.productImag

    String productImage;

    if (image == null ||
        image!.path.isEmpty ||
        image!.path.contains('assets/products/no-image.png')) {
      productImage = "assets/products/no-image.png";
    } else {
      final directory = await getExternalStorageDirectory();
      final productDir = Directory('${directory!.path}/product');
      if (!await productDir.exists()) {
        await productDir.create(recursive: true);
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final savedImage = await image!.copy('${productDir.path}/$fileName');
      productImage = savedImage.path;
    }

    if (productName.isEmpty || productCategory.isEmpty) {
      showNullDataAlert(context,
          message: "Harap isi semua kolom yang wajib diisi!");
      return;
    }

    final updatedProduct = Product(
      productId: widget.product!.productId,
      productBarcode: productBarcode,
      productBarcodeType: widget.product!.productBarcodeType,
      productName: productName,
      productStock: productStock,
      productUnit: productSatuan,
      productSold: productSold,
      productPurchasePrice: productHargaBeli,
      productSellPrice: productHargaJual,
      productDateAdded: widget.product!.productDateAdded,
      productImage: productImage,
      categoryName: productCategory,
    );

    try {
      await _databaseService.updateProduct(updatedProduct);

      showSuccessAlert(context, "Produk Berhasil Diperbarui!");

      Navigator.pop(context, true);
    } catch (e) {
      showFailedAlert(context, message: "Gagal menambahkan Produk: $e");
    }
  }

  // productPurchasePrice: int.parse(_productHargaBeliController.text.replaceAll('.', '')),
  // productSellPrice: int.parse(_productHargaJualController.text.replaceAll('.', '')),
  // categoryId: selectedCategoryId, // Pastikan Anda memiliki ID kategori yang dipilih
  // productImage: image?.path ?? '', // Pastikan Anda memiliki gambar produk
  // dateAdded: DateTime.now().toIso8601String(),

  @override
  Widget build(BuildContext context) {
    var bluetoothProvider = Provider.of<BluetoothProvider>(context);
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
              elevation: 0,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              scrolledUnderElevation: 0,
              titleSpacing: 0,
              leading: const CustomBackButton(),
              toolbarHeight: kToolbarHeight + 20,
              title: Text(
                image != null
                    ? 'LIHAT MAKANAN ${widget.product!.productName}'
                    : 'LIHAT MAKANAN ${widget.product!.productName}',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _selectCameraOrGalery();
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: image != null
                                    ? Hero(
                                        tag:
                                            "productImage_${widget.product!.productId}",
                                        child: Image.file(
                                          image!,
                                          width: 160,
                                          height: 160,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/products/add-image.png",
                                              width: 160,
                                              height: 160,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      )
                                    : Hero(
                                        tag: "productImage",
                                        child: Image.asset(
                                          "assets/products/add-image.png",
                                          width: 160,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                            if (image != null)
                              Positioned(
                                top: 10,
                                right: 15,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Iconify(
                                      Bi.x,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      image = null;
                                      // hanya variable image yang akan di kosongkan, tidak ada yang lain
                                      // jawaban: tidak, setState hanya digunakan untuk mengubah UI, tidak untuk mengisi variable. Kalau ingin mengisi variable, maka kita perlu mengisi variable nya secara langsung seperti di atas ini.
                                      // setState(() {
                                      //   image = null;
                                      //   _imageController.text = '';
                                      // });

                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom:
                                  10, // Adjust this value to move the button higher or lower
                              right:
                                  10, // Adjust this value to move the button left or right
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const IconButton(
                                  icon: Iconify(
                                    Bi.camera_fill,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(20),
                    const Text(
                      "Nama Makanan",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    const Gap(10),
                    CustomTextField(
                        fillColor: cardColor,
                        obscureText: false,
                        hintText: "Nama Makanan",
                        prefixIcon: const Icon(Icons.shopping_bag_rounded),
                        controller: _productNameController,
                        maxLines: 1,
                        suffixIcon: null),
                    const Gap(15),
                    const Text(
                      "Kategori",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        // Bagian Kiri
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectCategory()),
                              );

                              if (result != null) {
                                setState(() {
                                  _productCategoryController.text = result;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: cardColor,
                              foregroundColor: Colors.grey[800],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20))),
                              minimumSize: const Size(0, 55),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.list_outlined,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _productCategoryController.text.isEmpty
                                        ? "Kategori"
                                        : _productCategoryController
                                                    .text.length >
                                                15
                                            ? '${_productCategoryController.text.substring(0, 15)}...'
                                            : _productCategoryController.text,
                                    style: const TextStyle(
                                        fontSize: 16, fontFamily: 'Poppins'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bagian Kanan
                        ElevatedButton(
                          onPressed: () {
                            createCategoryModal(
                              context: context,
                              productCreateCategoryController:
                                  _productCreateCategoryController,
                              categoryFocusNode: _categoryFocusNode,
                              databaseService: _databaseService,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(13),
                                bottomRight: Radius.circular(13),
                              ),
                            ),
                            minimumSize: const Size(0, 55),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add_circle,
                                size: 20,
                                color: Colors.white,
                              ),
                              // SizedBox(width: 5),
                              // Text(
                              //   "Tambah",
                              //   style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),
                    const Text(
                      "Harga Beli",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    const Gap(10),
                    CustomTextField(
                      fillColor: cardColor,
                      hintText: "Harga Beli",
                      prefixIcon: const Icon(Icons.calculate),
                      controller: _productHargaBeliController,
                      maxLines: 1,
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        currencyInputFormatter(),
                      ],
                      prefixText: _productHargaBeliController.text.length <= 3
                          ? "Rp. "
                          : "Rp. ",
                      obscureText: false,
                      suffixIcon: null,
                      keyboardType: TextInputType.number,
                    ),
                    const Gap(15),
                    const Text(
                      "Presentase Keuntungan",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    const Gap(10),
                    CustomTextField(
                      fillColor: cardColor,
                      hintText: "Persentase Keuntungan",
                      prefixIcon: null,
                      controller: _persentaseController,
                      maxLines: 1,
                      obscureText: false,
                      suffixText: '%',
                      suffixIcon: null,
                      keyboardType: TextInputType.number,
                    ),
                    const Gap(5),
                    Text(
                      "Harga Jual",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    const Gap(10),
                    CustomTextField(
                        fillColor: cardColor,
                        hintText: "Harga Jual",
                        prefixIcon: const Icon(Icons.calculate),
                        controller: _productHargaJualController,
                        maxLines: 1,
                        prefixText: _productHargaJualController.text.length <= 3
                            ? "Rp. "
                            : "Rp. ",
                        obscureText: false,
                        readOnly: false,
                        suffixIcon: null,
                        keyboardType: TextInputType.number,
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          currencyInputFormatter()
                        ]),
                    const Gap(15),
                    Text(
                      "Keuntungan",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    const Gap(10),
                    CustomTextField(
                      fillColor: cardColor,
                      hintText: "Keuntungan",
                      prefixIcon: null,
                      controller: _keuntunganController,
                      maxLines: 1,
                      prefixText: _keuntunganController.text.length <= 3
                          ? "Rp. "
                          : "Rp. ",
                      obscureText: false,
                      suffixIcon: null,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        currencyInputFormatter()
                      ],
                      // readOnly: true,
                    ),
                    const Gap(78)
                  ],
                ),
              ),
              if (securityProvider.editProduk)
                ExpensiveFloatingButton(onPressed: () => _updateProduct())
            ],
          ),
        ),
      ),
    );
  }
}
