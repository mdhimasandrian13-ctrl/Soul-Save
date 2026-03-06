import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/savings_provider.dart';
import '../models/celengan_model.dart';
import 'detail_screen.dart';
import 'tambah_celengan_screen.dart';

class SavingsListScreen extends StatelessWidget {
  const SavingsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SavingsProvider>();
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Semua Celengan',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 4),
            Text('${provider.celenganList.length} celengan aktif',
                style: TextStyle(color: Colors.grey[500])),
            const SizedBox(height: 20),
            if (provider.celenganList.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🐷', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      const Text('Belum ada celengan',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Tap tombol + untuk mulai menabung!',
                          style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const TambahCelenganScreen())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2EC4A0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Buat Celengan Pertama'),
                      )
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.celenganList.length,
                  itemBuilder: (context, index) {
                    final c = provider.celenganList[index];
                    final colors = [
                      const Color(0xFF2EC4A0),
                      const Color(0xFFFF8C42),
                      const Color(0xFFF4C542),
                      const Color(0xFF6C63FF),
                      const Color(0xFFFF6B6B),
                    ];
                    final color = colors[c.id! % colors.length];

                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DetailScreen(celengan: c))),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3))
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                  child: Text(c.emoji,
                                      style:
                                          const TextStyle(fontSize: 28))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.nama,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  const SizedBox(height: 2),
                                  Text(formatter.format(c.saldo),
                                      style: TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.w600)),
                                  if (c.target > 0) ...[
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: c.persentase,
                                        backgroundColor:
                                            color.withOpacity(0.15),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                color),
                                        minHeight: 5,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.chevron_right,
                                color: Colors.grey[300]),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}