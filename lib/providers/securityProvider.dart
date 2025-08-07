import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityProvider with ChangeNotifier {
  // === PRODUK ===
  bool _kunciProduk = false;
  bool _tambahProduk = true;
  bool _editProduk = true;
  bool _hapusProduk = true;

  // === STOK PRODUK ===
  bool _tambahStokProduk = true;
  bool _hapusStokProduk = true;

  // === KATEGORI ===
  bool _kunciKategori = false;
  bool _tambahKategori = true;
  bool _editKategori = true;
  bool _hapusKategori = true;

  // === PEMASUKAN ===
  bool _kunciPemasukan = false;
  bool _tambahPemasukan = true;
  bool _editPemasukan = true;
  bool _hapusPemasukan = true;

  // === PENGELUARAN ===
  bool _kunciPengeluaran = false;
  bool _tambahPengeluaran = true;
  bool _editPengeluaran = true;
  bool _hapusPengeluaran = true;

  // === TRANSAKSI ===
  bool _tanggalTransaksi = false;
  bool _batalkanTransaksi = false;
  bool _editTransaksi = true;
  bool _hapusTransaksi = true;
  bool _sembunyikanProfit = false;

  // === RIWAYAT ===
  bool _kunciRiwayatTransaksi = false;

  // === METODE BAYAR ===
  bool _tambahMetode = true;
  bool _editMetode = true;
  bool _hapusMetode = true;

  // === CETAK ===
  bool _kunciCetakStruk = false;
  bool _kunciBagikanStruk = false;

  // === LAPORAN ===
  bool _kunciLaporan = false;

  // === PENGATURAN TOKO ===
  bool _kunciPengaturanToko = false;
  bool _kunciPengaturan = false;
  bool _kunciRestoreData = false;
  bool _kunciGantiPassword = true;
  bool _kunciKeamanan = true;

  // === SEMBUNYIKAN ===
  bool _sembunyikanHapusBackup = false;
  bool _sembunyikanLogout = false;

  // === GETTERS ===
  bool get kunciProduk => _kunciProduk;
  bool get tambahProduk => _tambahProduk;
  bool get editProduk => _editProduk;
  bool get hapusProduk => _hapusProduk;

  bool get tambahStokProduk => _tambahStokProduk;
  bool get hapusStokProduk => _hapusStokProduk;

  bool get kunciKategori => _kunciKategori;
  bool get tambahKategori => _tambahKategori;
  bool get editKategori => _editKategori;
  bool get hapusKategori => _hapusKategori;

  bool get kunciPemasukan => _kunciPemasukan;
  bool get tambahPemasukan => _tambahPemasukan;
  bool get editPemasukan => _editPemasukan;
  bool get hapusPemasukan => _hapusPemasukan;

  bool get kunciPengeluaran => _kunciPengeluaran;
  bool get tambahPengeluaran => _tambahPengeluaran;
  bool get editPengeluaran => _editPengeluaran;
  bool get hapusPengeluaran => _hapusPengeluaran;

  bool get tanggalTransaksi => _tanggalTransaksi;
  bool get batalkanTransaksi => _batalkanTransaksi;
  bool get editTransaksi => _editTransaksi;
  bool get hapusTransaksi => _hapusTransaksi;
  bool get sembunyikanProfit => _sembunyikanProfit;

  bool get tambahMetode => _tambahMetode;
  bool get editMetode => _editMetode;
  bool get hapusMetode => _hapusMetode;

  bool get kunciRiwayatTransaksi => _kunciRiwayatTransaksi;

  bool get kunciCetakStruk => _kunciCetakStruk;
  bool get kunciBagikanStruk => _kunciBagikanStruk;

  bool get kunciLaporan => _kunciLaporan;

  bool get kunciPengaturanToko => _kunciPengaturanToko;
  bool get kunciPengaturan => _kunciPengaturan;
  bool get kunciGantiPassword => _kunciGantiPassword;
  bool get kunciRestoreData => _kunciRestoreData;
  bool get kunciKeamanan => _kunciKeamanan;

  bool get sembunyikanHapusBackup => _sembunyikanHapusBackup;
  bool get sembunyikanLogout => _sembunyikanLogout;

  void reloadPreferences() async {
    await loadPreferences();
  }

// === PREFERENCES LOADING ===
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    _kunciProduk = prefs.getBool('kunciProduk') ?? _kunciProduk;
    _tambahProduk = prefs.getBool('tambahProduk') ?? _tambahProduk;
    _editProduk = prefs.getBool('editProduk') ?? _editProduk;
    _hapusProduk = prefs.getBool('hapusProduk') ?? _hapusProduk;

    _tambahStokProduk = prefs.getBool('tambahStokProduk') ?? _tambahStokProduk;
    _hapusStokProduk = prefs.getBool('hapusStokProduk') ?? _hapusStokProduk;

    _kunciKategori = prefs.getBool('kunciKategori') ?? _kunciKategori;
    _tambahKategori = prefs.getBool('tambahKategori') ?? _tambahKategori;
    _editKategori = prefs.getBool('editKategori') ?? _editKategori;
    _hapusKategori = prefs.getBool('hapusKategori') ?? _hapusKategori;

    _kunciPemasukan = prefs.getBool('kunciPemasukan') ?? _kunciPemasukan;
    _tambahPemasukan = prefs.getBool('tambahPemasukan') ?? _tambahPemasukan;
    _editPemasukan = prefs.getBool('editPemasukan') ?? _editPemasukan;
    _hapusPemasukan = prefs.getBool('hapusPemasukan') ?? _hapusPemasukan;

    _kunciPengeluaran = prefs.getBool('kunciPengeluaran') ?? _kunciPengeluaran;
    _tambahPengeluaran =
        prefs.getBool('tambahPengeluaran') ?? _tambahPengeluaran;
    _editPengeluaran = prefs.getBool('editPengeluaran') ?? _editPengeluaran;
    _hapusPengeluaran = prefs.getBool('hapusPengeluaran') ?? _hapusPengeluaran;

    _sembunyikanProfit =
        prefs.getBool('sembunyikanProfit') ?? _sembunyikanProfit;
    _tanggalTransaksi = prefs.getBool('tanggalTransaksi') ?? _tanggalTransaksi;
    _batalkanTransaksi =
        prefs.getBool('batalkanTransaksi') ?? _batalkanTransaksi;
    _editTransaksi = prefs.getBool('editTransaksi') ?? _editTransaksi;
    _hapusTransaksi = prefs.getBool('hapusTransaksi') ?? _hapusTransaksi;

    _kunciRiwayatTransaksi =
        prefs.getBool('kunciRiwayatTransaksi') ?? _kunciRiwayatTransaksi;

    _tambahMetode = prefs.getBool('tambahMetode') ?? _tambahMetode;
    _editMetode = prefs.getBool('editMetode') ?? _editMetode;
    _hapusMetode = prefs.getBool('hapusMetode') ?? _hapusMetode;

    _kunciCetakStruk = prefs.getBool('kunciCetakStruk') ?? _kunciCetakStruk;
    _kunciBagikanStruk =
        prefs.getBool('kunciBagikanStruk') ?? _kunciBagikanStruk;

    _kunciLaporan = prefs.getBool('kunciLaporan') ?? _kunciLaporan;

    _kunciPengaturanToko =
        prefs.getBool('kunciPengaturanToko') ?? _kunciPengaturanToko;
    _kunciPengaturan =
        prefs.getBool('kunciPengaturan') ?? _kunciPengaturan;
    _kunciGantiPassword =
        prefs.getBool('kunciGantiPassword') ?? _kunciGantiPassword;
    _kunciKeamanan = prefs.getBool('kunciKeamanan') ?? _kunciKeamanan;
    _kunciRestoreData = prefs.getBool('kunciRestoreData') ?? _kunciRestoreData;

    _sembunyikanHapusBackup =
        prefs.getBool('sembunyikanHapusBackup') ?? _sembunyikanHapusBackup;
    _sembunyikanLogout =
        prefs.getBool('sembunyikanLogout') ?? _sembunyikanLogout;
    notifyListeners();
  }
}
