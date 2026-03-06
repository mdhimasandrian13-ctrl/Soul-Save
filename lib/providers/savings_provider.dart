import 'package:flutter/material.dart';
import '../models/celengan_model.dart';
import '../models/transaksi_model.dart';
import '../database/database_helper.dart';

class SavingsProvider extends ChangeNotifier {
  List<Celengan> _celenganList = [];
Map<int, List<Transaksi>> _transaksiMap = {};
bool _isDarkMode = false;

bool get isDarkMode => _isDarkMode;

void toggleDarkMode() {
  _isDarkMode = !_isDarkMode;
  notifyListeners();
}
  List<Celengan> get celenganList => _celenganList;

  double get totalSaldo =>
      _celenganList.fold(0, (sum, c) => sum + c.saldo);

  List<Transaksi> getTransaksi(int celenganId) =>
      _transaksiMap[celenganId] ?? [];

  Future<void> loadData() async {
    _celenganList = await DatabaseHelper.instance.getAllCelengan();
    notifyListeners();
  }

  Future<void> loadTransaksi(int celenganId) async {
    _transaksiMap[celenganId] =
        await DatabaseHelper.instance.getTransaksiBycelengan(celenganId);
    notifyListeners();
  }

  Future<void> tambahCelengan(Celengan celengan) async {
    final id = await DatabaseHelper.instance.insertCelengan(celengan);
    _celenganList.insert(0, celengan.copyWith(id: id));
    notifyListeners();
  }

  Future<void> editCelengan(Celengan celengan) async {
    await DatabaseHelper.instance.updateCelengan(celengan);
    final index = _celenganList.indexWhere((c) => c.id == celengan.id);
    if (index != -1) _celenganList[index] = celengan;
    notifyListeners();
  }

  Future<void> hapusCelengan(int id) async {
    await DatabaseHelper.instance.deleteCelengan(id);
    _celenganList.removeWhere((c) => c.id == id);
    _transaksiMap.remove(id);
    notifyListeners();
  }

  Future<void> tambahTransaksi({
    required Celengan celengan,
    required TipeTransaksi tipe,
    required double nominal,
    String? catatan,
  }) async {
    final transaksi = Transaksi(
      celenganId: celengan.id!,
      tipe: tipe,
      nominal: nominal,
      catatan: catatan,
      tanggal: DateTime.now(),
    );

    await DatabaseHelper.instance.insertTransaksi(transaksi);

    final saldoBaru = tipe == TipeTransaksi.setor
        ? celengan.saldo + nominal
        : celengan.saldo - nominal;

    final updated = celengan.copyWith(saldo: saldoBaru);
    await DatabaseHelper.instance.updateCelengan(updated);

    final index = _celenganList.indexWhere((c) => c.id == celengan.id);
    if (index != -1) _celenganList[index] = updated;

    await loadTransaksi(celengan.id!);
    notifyListeners();
  }
}