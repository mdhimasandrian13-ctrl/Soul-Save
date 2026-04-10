import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/savings_provider.dart';
import '../models/celengan_model.dart';
import 'detail_screen.dart';
import 'tambah_celengan_screen.dart';
import 'home_screen.dart';

class SavingsListScreen extends StatelessWidget {
  const SavingsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SavingsProvider>();
    final isDark = provider.isDarkMode;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final textColor = isDark ? Colors.white : kNavy;
    final subTextColor = isDark ? Colors.white60 : Colors.grey[500]!;
    final cardColor = isDark ? kCardDark : Colors.white;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Semua Celengan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 4),
            Text('${provider.celenganList.length} celengan aktif',
                style: TextStyle(color: subTextColor)),
            const SizedBox(height: 20),
            if (provider.celenganList.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/monefy_icon.png', height: 80),
                      const SizedBox(height: 16),
                      Text('Belum ada celengan',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 8),
                      Text('Tap tombol + untuk mulai menabung!',
                          style: TextStyle(color: subTextColor)),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const TambahCelenganScreen())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGold,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                      kGold,
                      const Color(0xFF2E5FA3),
                      const Color(0xFF8B6914),
                      const Color(0xFF1A4A8A),
                      const Color(0xFFB8860B),
                    ];
                    final color = colors[c.id! % colors.length];

                    return GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => DetailScreen(celengan: c))),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                                blurRadius: 8, offset: const Offset(0, 3))
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56, height: 56,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(child: Text(c.emoji, style: const TextStyle(fontSize: 28))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.nama,
                                      style: TextStyle(fontWeight: FontWeight.bold,
                                          fontSize: 15, color: textColor)),
                                  const SizedBox(height: 2),
                                  Text(formatter.format(c.saldo),
                                      style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                                  if (c.target > 0) ...[
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: c.persentase,
                                        backgroundColor: color.withOpacity(0.15),
                                        valueColor: AlwaysStoppedAnimation<Color>(color),
                                        minHeight: 5,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.chevron_right,
                                color: isDark ? Colors.white30 : Colors.grey[300]),
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