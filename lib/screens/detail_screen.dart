import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import '../models/celengan_model.dart';
import '../models/transaksi_model.dart';
import '../providers/savings_provider.dart';
import 'tambah_celengan_screen.dart';

class DetailScreen extends StatefulWidget {
  final Celengan celengan;
  const DetailScreen({super.key, required this.celengan});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    Future.microtask(() {
      context.read<SavingsProvider>().loadTransaksi(widget.celengan.id!);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showTransaksiSheet(TipeTransaksi tipe) {
    final nominalCtrl = TextEditingController();
    final catatanCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                tipe == TipeTransaksi.setor
                    ? '💰 Tambah Setoran'
                    : '💸 Tarik Dana',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: nominalCtrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Nominal',
                prefixText: 'Rp ',
                filled: true,
                fillColor: const Color(0xFFFDF6ED),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: catatanCtrl,
              decoration: InputDecoration(
                labelText: 'Catatan (opsional)',
                filled: true,
                fillColor: const Color(0xFFFDF6ED),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final nominal = double.tryParse(
                      nominalCtrl.text.replaceAll('.', ''));
                  if (nominal == null || nominal <= 0) return;

                  final celengan = context
                      .read<SavingsProvider>()
                      .celenganList
                      .firstWhere((c) => c.id == widget.celengan.id);

                  await context.read<SavingsProvider>().tambahTransaksi(
                        celengan: celengan,
                        tipe: tipe,
                        nominal: nominal,
                        catatan: catatanCtrl.text.trim().isEmpty
                            ? null
                            : catatanCtrl.text.trim(),
                      );

                  Navigator.pop(ctx);

                  // Cek apakah target tercapai setelah setor
                  final updated = context
                      .read<SavingsProvider>()
                      .celenganList
                      .firstWhere((c) => c.id == widget.celengan.id);
                  if (updated.sudahTercapai && tipe == TipeTransaksi.setor) {
                    _confettiController.play();
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('🎉 Selamat!'),
                          content: Text(
                              'Target celengan "${updated.nama}" sudah tercapai! Kamu luar biasa!'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Terima Kasih! 😊'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tipe == TipeTransaksi.setor
                      ? const Color(0xFF2EC4A0)
                      : const Color(0xFFFF6B6B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Simpan',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SavingsProvider>();
    final celengan = provider.celenganList.firstWhere(
        (c) => c.id == widget.celengan.id,
        orElse: () => widget.celengan);
    final transaksiList = provider.getTransaksi(celengan.id!);
    final formatter = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6ED),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: const Color(0xFF2EC4A0),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                TambahCelenganScreen(celengan: celengan))),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.white),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Hapus Celengan?'),
                        content: Text(
                            'Celengan "${celengan.nama}" dan semua riwayatnya akan dihapus permanen.'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal')),
                          TextButton(
                            onPressed: () {
                              provider.hapusCelengan(celengan.id!);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('Hapus',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2EC4A0), Color(0xFF1FA085)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20, 60, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${celengan.emoji} ${celengan.nama}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(formatter.format(celengan.saldo),
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16)),
                            if (celengan.targetTanggal != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                '📅 ${celengan.targetTanggal!.difference(DateTime.now()).inDays} hari lagi',
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (celengan.target > 0) ...[
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Progress',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      '${(celengan.persentase * 100).toStringAsFixed(1)}%',
                                      style: const TextStyle(
                                          color: Color(0xFF2EC4A0),
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: celengan.persentase,
                                  backgroundColor: const Color(0xFF2EC4A0)
                                      .withOpacity(0.15),
                                  valueColor:
                                      const AlwaysStoppedAnimation(
                                          Color(0xFF2EC4A0)),
                                  minHeight: 10,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  '${formatter.format(celengan.saldo)} dari ${formatter.format(celengan.target)}',
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showTransaksiSheet(
                                  TipeTransaksi.setor),
                              icon: const Icon(Icons.add),
                              label: const Text('Setor'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF2EC4A0),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14)),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showTransaksiSheet(
                                  TipeTransaksi.tarik),
                              icon: const Icon(Icons.remove),
                              label: const Text('Tarik'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFFF6B6B),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14)),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('Riwayat Transaksi',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      if (transaksiList.isEmpty)
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 32),
                            child: Column(
                              children: [
                                const Text('📋',
                                    style: TextStyle(fontSize: 40)),
                                const SizedBox(height: 8),
                                Text('Belum ada transaksi',
                                    style: TextStyle(
                                        color: Colors.grey[500])),
                              ],
                            ),
                          ),
                        )
                      else
                        ...transaksiList.map((t) => Container(
                              margin:
                                  const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: t.tipe ==
                                              TipeTransaksi.setor
                                          ? const Color(0xFFD6F5EE)
                                          : const Color(0xFFFFEBEB),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      t.tipe == TipeTransaksi.setor
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: t.tipe ==
                                              TipeTransaksi.setor
                                          ? const Color(0xFF2EC4A0)
                                          : const Color(0xFFFF6B6B),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            t.tipe ==
                                                    TipeTransaksi.setor
                                                ? 'Setoran'
                                                : 'Penarikan',
                                            style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.w600)),
                                        if (t.catatan != null)
                                          Text(t.catatan!,
                                              style: TextStyle(
                                                  color:
                                                      Colors.grey[500],
                                                  fontSize: 12)),
                                        Text(
                                            dateFormatter
                                                .format(t.tanggal),
                                            style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${t.tipe == TipeTransaksi.setor ? '+' : '-'}${formatter.format(t.nominal)}',
                                    style: TextStyle(
                                        color: t.tipe ==
                                                TipeTransaksi.setor
                                            ? const Color(0xFF2EC4A0)
                                            : const Color(0xFFFF6B6B),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            )),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Confetti widget
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFF2EC4A0),
                Color(0xFFFF8C42),
                Color(0xFFF4C542),
                Color(0xFF6C63FF),
                Color(0xFFFF6B6B),
              ],
            ),
          ),
        ],
      ),
    );
  }
}