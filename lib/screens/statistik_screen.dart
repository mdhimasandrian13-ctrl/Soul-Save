import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/savings_provider.dart';
import '../models/transaksi_model.dart';
import 'home_screen.dart';

enum PeriodFilter { mingguan, bulanan, tahunan }

class StatistikScreen extends StatefulWidget {
  const StatistikScreen({super.key});

  @override
  State<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  PeriodFilter _period = PeriodFilter.mingguan;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<SavingsProvider>();
      for (final c in provider.celenganList) {
        provider.loadTransaksi(c.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SavingsProvider>();
    final isDark = provider.isDarkMode;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final bgColor = isDark ? kBgDark : const Color(0xFFF5F5F0);
    final cardColor = isDark ? kCardDark : Colors.white;
    final textColor = isDark ? Colors.white : kNavy;
    final subTextColor = isDark ? Colors.white60 : Colors.grey[500]!;

    // Kumpulkan semua transaksi
    final allTransaksi = <Transaksi>[];
    for (final c in provider.celenganList) {
      allTransaksi.addAll(provider.getTransaksi(c.id!));
    }

    // Filter berdasarkan periode
    final now = DateTime.now();
    final periodDays = _period == PeriodFilter.mingguan ? 7
        : _period == PeriodFilter.bulanan ? 30 : 365;
    final filtered = allTransaksi.where((t) =>
        t.tanggal.isAfter(now.subtract(Duration(days: periodDays)))).toList();

    final totalSetor = filtered.where((t) => t.tipe == TipeTransaksi.setor)
        .fold(0.0, (sum, t) => sum + t.nominal);
    final totalTarik = filtered.where((t) => t.tipe == TipeTransaksi.tarik)
        .fold(0.0, (sum, t) => sum + t.nominal);
    final totalSaldo = provider.celenganList.fold(0.0, (sum, c) => sum + c.saldo);
    final selisih = totalSetor - totalTarik;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text('Statistik',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Total Saldo Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kNavy, kNavyLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: kNavy.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Saldo', style: TextStyle(color: Colors.white60, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text(formatter.format(totalSaldo),
                      style: const TextStyle(color: kGold, fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${provider.celenganList.length} celengan aktif',
                      style: const TextStyle(color: Colors.white60, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Filter Periode
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  _PeriodButton(label: 'Mingguan', selected: _period == PeriodFilter.mingguan,
                      onTap: () => setState(() => _period = PeriodFilter.mingguan),
                      subTextColor: subTextColor),
                  _PeriodButton(label: 'Bulanan', selected: _period == PeriodFilter.bulanan,
                      onTap: () => setState(() => _period = PeriodFilter.bulanan),
                      subTextColor: subTextColor),
                  _PeriodButton(label: 'Tahunan', selected: _period == PeriodFilter.tahunan,
                      onTap: () => setState(() => _period = PeriodFilter.tahunan),
                      subTextColor: subTextColor),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Summary Cards
            Row(children: [
              _StatCard(
                icon: Icons.arrow_downward_rounded,
                label: 'Total Setor',
                value: formatter.format(totalSetor),
                color: kGold,
                cardColor: cardColor,
                textColor: textColor,
                subTextColor: subTextColor,
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.arrow_upward_rounded,
                label: 'Total Tarik',
                value: formatter.format(totalTarik),
                color: const Color(0xFFE53935),
                cardColor: cardColor,
                textColor: textColor,
                subTextColor: subTextColor,
              ),
            ]),
            const SizedBox(height: 12),

            // Selisih Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selisih >= 0 ? kGold.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selisih', style: TextStyle(fontSize: 13, color: subTextColor)),
                      const SizedBox(height: 4),
                      Text(
                        _period == PeriodFilter.mingguan ? '7 hari terakhir'
                            : _period == PeriodFilter.bulanan ? '30 hari terakhir'
                            : '1 tahun terakhir',
                        style: TextStyle(fontSize: 11, color: subTextColor),
                      ),
                    ],
                  ),
                  Text(
                    '${selisih >= 0 ? '+' : ''}${formatter.format(selisih)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: selisih >= 0 ? kGold : const Color(0xFFE53935),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Progress Celengan
            Text('Progress Celengan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 12),

            if (provider.celenganList.isEmpty)
              Center(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text('Belum ada celengan', style: TextStyle(color: subTextColor)),
              ))
            else
              ...provider.celenganList.map((c) {
                final colors = [kGold, kNavyLight, const Color(0xFF8B6914),
                  const Color(0xFF1A4A8A), const Color(0xFFB8860B)];
                final color = colors[c.id! % colors.length];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Text(c.emoji, style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 10),
                            Text(c.nama,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 15, color: textColor)),
                          ]),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              c.target > 0
                                  ? '${(c.persentase * 100).toStringAsFixed(1)}%'
                                  : formatter.format(c.saldo),
                              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      if (c.target > 0) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: c.persentase,
                            backgroundColor: color.withOpacity(0.12),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatter.format(c.saldo),
                                style: TextStyle(fontSize: 12, color: subTextColor)),
                            Text(formatter.format(c.target),
                                style: TextStyle(fontSize: 12, color: subTextColor)),
                          ],
                        ),
                      ] else ...[
                        const SizedBox(height: 4),
                        Text('Tidak ada target nominal',
                            style: TextStyle(fontSize: 12, color: subTextColor)),
                      ],
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color subTextColor;

  const _PeriodButton({required this.label, required this.selected,
    required this.onTap, required this.subTextColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? kNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label, textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
                  color: selected ? kGold : subTextColor)),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color, cardColor, textColor, subTextColor;

  const _StatCard({required this.icon, required this.label, required this.value,
    required this.color, required this.cardColor,
    required this.textColor, required this.subTextColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontSize: 12, color: subTextColor)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}