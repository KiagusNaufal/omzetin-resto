import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omsetin_resto/providers/securityProvider.dart';
import 'package:omsetin_resto/utils/colors.dart';
import 'package:omsetin_resto/utils/responsif/fsize.dart';
import 'package:omsetin_resto/utils/successAlert.dart';
import 'package:omsetin_resto/view/widget/back_button.dart';
import 'package:omsetin_resto/view/widget/expensiveFloatingButton.dart';
import 'package:omsetin_resto/view/widget/pinModal.dart';
import 'package:omsetin_resto/view/widget/pinModalChangePassword.dart';
import 'package:omsetin_resto/view/widget/primary_button.dart';

import 'package:omsetin_resto/services/sharedPrefences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  _SecuritySettingsPageState createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _kunciProduk = false;
  bool _tambahProduk = true;
  bool _editProduk = true;
  bool _hapusProduk = true;

  bool _tambahStokProduk = true;
  bool _hapusStokProduk = true;

  bool _kunciKategori = false;
  bool _tambahKategori = true;
  bool _editKategori = true;
  bool _hapusKategori = true;

  bool _kunciPemasukan = false;
  bool _tambahPemasukan = true;
  bool _editPemasukan = true;
  bool _hapusPemasukan = true;

  bool _kunciPengeluaran = false;
  bool _tambahPengeluaran = true;
  bool _editPengeluaran = true;
  bool _hapusPengeluaran = true;

  bool _tanggalTransaksi = false;
  bool _batalkanTransaksi = false;
  bool _editTransaksi = true;
  bool _hapusTransaksi = true;
  bool _sembunyikanProfit = false;

  bool _kunciRiwayatTransaksi = false;

  bool _tambahMetode = true;
  bool _editMetode = true;
  bool _hapusMetode = true;

  bool _kunciCetakStruk = false;
  bool _kunciBagikanStruk = false;

  bool _kunciLaporan = false;

  bool _kunciPengaturanToko = false;
  bool _kunciPengaturan = false;
  bool _kunciRestoreData = false;
  bool _kunciGantiPassword = true;
  bool _kunciKeamanan = true;

  bool _sembunyikanHapusBackup = false;
  bool _sembunyikanLogout = false;

  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _kunciRiwayatTransaksi =
          prefs.getBool('kunciRiwayatTransaksi') ?? _kunciRiwayatTransaksi;
      _kunciProduk = prefs.getBool('kunciProduk') ?? _kunciProduk;
      _tambahProduk = prefs.getBool('tambahProduk') ?? _tambahProduk;
      _tambahStokProduk =
          prefs.getBool('tambahStokProduk') ?? _tambahStokProduk;
      _hapusStokProduk = prefs.getBool('hapusStokProduk') ?? _hapusStokProduk;
      _editProduk = prefs.getBool('editProduk') ?? _editProduk;
      _hapusProduk = prefs.getBool('hapusProduk') ?? _hapusProduk;
      _tambahKategori = prefs.getBool('tambahKategori') ?? _tambahKategori;
      _kunciKategori = prefs.getBool('kunciKategori') ?? _kunciKategori;
      _editKategori = prefs.getBool('editKategori') ?? _editKategori;
      _hapusKategori = prefs.getBool('hapusKategori') ?? _hapusKategori;
      _kunciPengeluaran =
          prefs.getBool('kunciPengeluaran') ?? _kunciPengeluaran;
      _tambahPengeluaran =
          prefs.getBool('tambahPengeluaran') ?? _tambahPengeluaran;
      _editPengeluaran = prefs.getBool('editPengeluaran') ?? _editPengeluaran;
      _hapusPengeluaran =
          prefs.getBool('hapusPengeluaran') ?? _hapusPengeluaran;
      _kunciPemasukan = prefs.getBool('kunciPemasukan') ?? _kunciPemasukan;
      _tambahPemasukan = prefs.getBool('tambahPemasukan') ?? _tambahPemasukan;
      _editPemasukan = prefs.getBool('editPemasukan') ?? _editPemasukan;
      _hapusPemasukan = prefs.getBool('hapusPemasukan') ?? _hapusPemasukan;
      _sembunyikanProfit =
          prefs.getBool('sembunyikanProfit') ?? _sembunyikanProfit;
      _tanggalTransaksi =
          prefs.getBool('tanggalTransaksi') ?? _tanggalTransaksi;
      _batalkanTransaksi =
          prefs.getBool('batalkanTransaksi') ?? _batalkanTransaksi;
      _editTransaksi = prefs.getBool('editTransaksi') ?? _editTransaksi;
      _hapusTransaksi = prefs.getBool('hapusTransaksi') ?? _hapusTransaksi;
      _tambahMetode = prefs.getBool('tambahMetode') ?? _tambahMetode;
      _editMetode = prefs.getBool('editMetode') ?? _editMetode;
      _hapusMetode = prefs.getBool('hapusMetode') ?? _hapusMetode;
      _kunciCetakStruk = prefs.getBool('kunciCetakStruk') ?? _kunciCetakStruk;
      _kunciBagikanStruk =
          prefs.getBool('kunciBagikanStruk') ?? _kunciBagikanStruk;
      _kunciLaporan = prefs.getBool('kunciLaporan') ?? _kunciLaporan;
      _kunciPengaturanToko =
          prefs.getBool('kunciPengaturanToko') ?? _kunciPengaturanToko;
      _kunciPengaturan = prefs.getBool('kunciPengaturan') ?? _kunciPengaturan;
      _kunciGantiPassword =
          prefs.getBool('kunciGantiPassword') ?? _kunciGantiPassword;
      _kunciKeamanan = prefs.getBool('kunciKeamanan') ?? _kunciKeamanan;
      _kunciRestoreData =
          prefs.getBool('kunciRestoreData') ?? _kunciRestoreData;
      _sembunyikanHapusBackup =
          prefs.getBool('sembunyikanHapusBackup') ?? _sembunyikanHapusBackup;
      _sembunyikanLogout =
          prefs.getBool('sembunyikanLogout') ?? _sembunyikanLogout;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('kunciProduk', _kunciProduk);
    await prefs.setBool('kunciRiwayatTransaksi', _kunciRiwayatTransaksi);
    await prefs.setBool('tambahProduk', _tambahProduk);
    await prefs.setBool('tambahStokProduk', _tambahStokProduk);
    await prefs.setBool('hapusStokProduk', _hapusStokProduk);
    await prefs.setBool('editProduk', _editProduk);
    await prefs.setBool('hapusProduk', _hapusProduk);
    await prefs.setBool('kunciKategori', _kunciKategori);
    await prefs.setBool('tambahKategori', _tambahKategori);
    await prefs.setBool('editKategori', _editKategori);
    await prefs.setBool('hapusKategori', _hapusKategori);
    await prefs.setBool('kunciPengeluaran', _kunciPengeluaran);
    await prefs.setBool('tambahPengeluaran', _tambahPengeluaran);
    await prefs.setBool('editPengeluaran', _editPengeluaran);
    await prefs.setBool('hapusPengeluaran', _hapusPengeluaran);
    await prefs.setBool('kunciPemasukan', _kunciPemasukan);
    await prefs.setBool('tambahPemasukan', _tambahPemasukan);
    await prefs.setBool('editPemasukan', _editPemasukan);
    await prefs.setBool('hapusPemasukan', _hapusPemasukan);
    await prefs.setBool('sembunyikanProfit', _sembunyikanProfit);
    await prefs.setBool('tanggalTransaksi', _tanggalTransaksi);
    await prefs.setBool('batalkanTransaksi', _batalkanTransaksi);
    await prefs.setBool('editTransaksi', _editTransaksi);
    await prefs.setBool('hapusTransaksi', _hapusTransaksi);
    await prefs.setBool('tambahMetode', _tambahMetode);
    await prefs.setBool('editMetode', _editMetode);
    await prefs.setBool('hapusMetode', _hapusMetode);
    await prefs.setBool('kunciCetakStruk', _kunciCetakStruk);
    await prefs.setBool('kunciBagikanStruk', _kunciBagikanStruk);
    await prefs.setBool('kunciLaporan', _kunciLaporan);
    await prefs.setBool('kunciPengaturanToko', _kunciPengaturanToko);
    await prefs.setBool('kunciPengaturan', _kunciPengaturan);
    await prefs.setBool('kunciGantiPassword', _kunciGantiPassword);
    await prefs.setBool('kunciKeamanan', _kunciKeamanan);
    await prefs.setBool('kunciRestoreData', _kunciRestoreData);
    await prefs.setBool('sembunyikanHapusBackup', _sembunyikanHapusBackup);
    await prefs.setBool('sembunyikanLogout', _sembunyikanLogout);

    Provider.of<SecurityProvider>(context, listen: false).reloadPreferences();
  }

  @override
  Widget build(BuildContext context) {
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
              elevation: 0,
              toolbarHeight: kToolbarHeight + 20,
              leading: CustomBackButton(),
              title: Text(
                'KEAMANAN',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeHelper.Fsize_normalTitle(context),
                  color: bgColor,
                ),
              ),
              scrolledUnderElevation: 0,
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildSettingSection('Transaksi', [
                              Divider(
                                color: primaryColor,
                                thickness: 2,
                              ),
                              _buildSettingItem('Kunci Riwayat Transaksi',
                                  _kunciRiwayatTransaksi, (value) {
                                setState(() {
                                  _kunciRiwayatTransaksi = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Sembunyikan Profit', _sembunyikanProfit,
                                  (value) {
                                setState(() {
                                  _sembunyikanProfit = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Tanggal Transaksi', _tanggalTransaksi,
                                  (value) {
                                setState(() {
                                  _tanggalTransaksi = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Batalkan Transaksi', _batalkanTransaksi,
                                  (value) {
                                setState(() {
                                  _batalkanTransaksi = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Edit Transaksi', _editTransaksi, (value) {
                                setState(() {
                                  _editTransaksi = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Hapus Transaksi', _hapusTransaksi, (value) {
                                setState(() {
                                  _hapusTransaksi = value;
                                });
                              }),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    // Produk
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildSettingSection('Makanan', [
                              Divider(color: primaryColor, thickness: 2),
                              _buildSettingItem('Kunci Makanan', _kunciProduk,
                                  (value) {
                                setState(() {
                                  _kunciProduk = value;
                                });
                              }),
                              _buildSettingItem('Tambah Makanan', _tambahProduk,
                                  (value) {
                                setState(() {
                                  _tambahProduk = value;
                                });
                              }),
                              _buildSettingItem('Edit Makanan', _editProduk,
                                  (value) {
                                setState(() {
                                  _editProduk = value;
                                });
                              }),
                              _buildSettingItem('Hapus Makanan', _hapusProduk,
                                  (value) {
                                setState(() {
                                  _hapusProduk = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Tambah Stok Makanan', _tambahStokProduk,
                                  (value) {
                                setState(() {
                                  _tambahStokProduk = value;
                                });
                              }),
                              // _buildSettingItem(
                              //     'Hapus Stok Produk', _hapusStokProduk,
                              //     (value) {
                              //   setState(() {
                              //     _hapusStokProduk = value;
                              //   });
                              // }),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    // Kategori
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildSettingSection('Kategori', [
                              Divider(
                                color: primaryColor,
                                thickness: 2,
                              ),
                              // _buildSettingItem(
                              //     'Kunci Kategori', _kunciKategori, (value) {
                              //   setState(() {
                              //     _kunciKategori = value;
                              //   });
                              // }),
                              _buildSettingItem(
                                  'Kunci Tambah Kategori', _tambahKategori,
                                  (value) {
                                setState(() {
                                  _tambahKategori = value;
                                });
                              }),
                              _buildSettingItem('Edit Kategori', _editKategori,
                                  (value) {
                                setState(() {
                                  _editKategori = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Hapus Kategori', _hapusKategori, (value) {
                                setState(() {
                                  _hapusKategori = value;
                                });
                              }),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    // Pengeluaran
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildSettingSection('Pengeluaran', [
                              Divider(
                                color: primaryColor,
                                thickness: 2,
                              ),
                              _buildSettingItem(
                                  'Kunci Pengeluaran', _kunciPengeluaran,
                                  (value) {
                                setState(() {
                                  _kunciPengeluaran = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Tambah Pengeluaran', _tambahPengeluaran,
                                  (value) {
                                setState(() {
                                  _tambahPengeluaran = value;
                                });
                              }),
                              // _buildSettingItem(
                              //     'Edit Pengeluaran', _editPengeluaran,
                              //     (value) {
                              //   setState(() {
                              //     _editPengeluaran = value;
                              //   });
                              // }),
                              // _buildSettingItem(
                              //     'Hapus Pengeluaran', _hapusPengeluaran,
                              //     (value) {
                              //   setState(() {
                              //     _hapusPengeluaran = value;
                              //   });
                              // }),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildSettingSection('Pemasukan', [
                              Divider(
                                color: primaryColor,
                                thickness: 2,
                              ),
                              _buildSettingItem(
                                  'Kunci Pemasukan', _kunciPemasukan, (value) {
                                setState(() {
                                  _kunciPemasukan = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Tambah Pemasukan', _tambahPemasukan,
                                  (value) {
                                setState(() {
                                  _tambahPemasukan = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Edit Pemasukan', _editPemasukan, (value) {
                                setState(() {
                                  _editPemasukan = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Hapus Pemasukan', _hapusPemasukan, (value) {
                                setState(() {
                                  _hapusPemasukan = value;
                                });
                              }),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    // Transaksi
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildSettingSection('Laporan', [
                              Divider(color: primaryColor, thickness: 2),
                              _buildSettingItem('Kunci Laporan', _kunciLaporan,
                                  (value) {
                                setState(() {
                                  _kunciLaporan = value;
                                });
                              }),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    // Metode
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildSettingSection('Metode Pembayaran', [
                              Divider(color: primaryColor, thickness: 2),
                              _buildSettingItem(
                                  'Tambah Metode Pembayaran', _tambahMetode,
                                  (value) {
                                setState(() {
                                  _tambahMetode = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Edit Metode Pembayaran', _editMetode,
                                  (value) {
                                setState(() {
                                  _editMetode = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Hapus Metode Pembayaran', _hapusMetode,
                                  (value) {
                                setState(() {
                                  _hapusMetode = value;
                                });
                              }),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    // Cetak Struk
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildSettingSection('Cetak Struk', [
                              Divider(color: primaryColor, thickness: 2),
                              _buildSettingItem(
                                  'Kunci Cetak Struk', _kunciCetakStruk,
                                  (value) {
                                setState(() {
                                  _kunciCetakStruk = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Kunci Bagikan Struk', _kunciBagikanStruk,
                                  (value) {
                                setState(() {
                                  _kunciBagikanStruk = value;
                                });
                              }),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    // Laporan

                    // Pengaturan Toko
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildSettingSection('Pengaturan Toko', [
                              Divider(color: primaryColor, thickness: 2),
                              _buildSettingItem(
                                  'Kunci Pengaturan Toko', _kunciPengaturanToko,
                                  (value) {
                                setState(() {
                                  _kunciPengaturanToko = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Kunci Pengaturan', _kunciPengaturan,
                                  (value) {
                                setState(() {
                                  _kunciPengaturan = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Kunci Keamanan', _kunciKeamanan, (value) {
                                setState(() {
                                  _kunciKeamanan = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Kunci Ganti Password', _kunciGantiPassword,
                                  (value) {
                                setState(() {
                                  _kunciGantiPassword = value;
                                });
                              }),
                              _buildSettingItem(
                                  'Kunci Restore Data', _kunciRestoreData,
                                  (value) {
                                setState(() {
                                  _kunciRestoreData = value;
                                });
                              }),
                              // _buildSettingItem('Sembunyikan Hapus Backup',
                              //     _sembunyikanHapusBackup, (value) {
                              //   setState(() {
                              //     _sembunyikanHapusBackup = value;
                              //   });
                              // }),
                              _buildSettingItem(
                                  'Sembunyikan Logout', _sembunyikanLogout,
                                  (value) {
                                setState(() {
                                  _sembunyikanLogout = value;
                                });
                              }),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    Gap(5),
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment(0.8, 1),
                                colors: const <Color>[
                                  primaryColor,
                                  secondaryColor
                                ],
                                tileMode: TileMode.mirror,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) => GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      color: Colors.transparent,
                                      child: GestureDetector(
                                          onTap: () {},
                                          child: PinModalChangePassword()),
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                );
                              },
                              child: const Text(
                                "UBAH SANDI",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Gap(65),
                  ],
                ),
              ),
            ),
            ExpensiveFloatingButton(
              onPressed: () async {
                await _saveSettings();
                showSuccessAlert(context, "Pengaturan berhasil disimpan");
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: primaryColor,
          inactiveTrackColor: greyColor,
          inactiveThumbColor: primaryColor,
        ),
      ],
    );
  }
}
