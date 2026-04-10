import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/savings_provider.dart';
import '../models/celengan_model.dart';
import 'savings_list_screen.dart';
import 'detail_screen.dart';
import 'tambah_celengan_screen.dart';
import 'pengingat_screen.dart';
import 'statistik_screen.dart';

const kNavy = Color(0xFF0D1B3E);
const kNavyLight = Color(0xFF1A2F5E);
const kGold = Color(0xFFC9A84C);
const kGoldLight = Color(0xFFF5E6C0);
const kBgLight = Color(0xFFF5F5F0);
const kBgDark = Color(0xFF0A0F1E);
const kCardDark = Color(0xFF141C30);
const kCardDark2 = Color(0xFF1C2640);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _BerandaTab(),
    SavingsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SavingsProvider>().isDarkMode;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: isDark ? kCardDark : Colors.white,
        indicatorColor: kGoldLight,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: kGold),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            selectedIcon: Icon(Icons.savings, color: kGold),
            label: 'Celengan',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kGold,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const TambahCelenganScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BerandaTab extends StatelessWidget {
  const _BerandaTab();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SavingsProvider>().isDarkMode;
    final provider = context.watch<SavingsProvider>();
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 11 ? 'Selamat Pagi'
        : hour < 15 ? 'Selamat Siang'
        : hour < 18 ? 'Selamat Sore' : 'Selamat Malam';

    final motivasiList = [
      '💪 Sedikit demi sedikit, lama-lama menjadi bukit!',
      '🌟 Setiap rupiah yang kamu tabung adalah langkah menuju impianmu!',
      '🎯 Konsisten adalah kunci. Kamu bisa!',
      '🚀 Mulai dari yang kecil, impian besar pasti tercapai!',
      '🌈 Nabung hari ini, bahagia di masa depan!',
      '⭐ Kamu lebih dekat ke tujuanmu dari kemarin!',
      '🏆 Disiplin menabung adalah investasi terbaik!',
      '🌸 Setiap usaha sekecil apapun itu berarti!',
    ];
    final motivasi = motivasiList[now.day % motivasiList.length];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$greeting 👋',
                        style: TextStyle(fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600])),
                    RichText(
  text: TextSpan(
    children: [
      TextSpan(
        text: 'Mone',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : kNavy,
          fontFamily: 'Poppins',
        ),
      ),
      TextSpan(
        text: 'fy',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: kGold,
          fontFamily: 'Poppins',
        ),
      ),
    ],
  ),
),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const PengingatScreen())),
                      icon: const Icon(Icons.notifications_outlined, color: kGold),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const StatistikScreen())),
                      icon: const Icon(Icons.bar_chart_rounded, color: kGold),
                    ),
                    IconButton(
                      onPressed: () => context.read<SavingsProvider>().toggleDarkMode(),
                      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: kGold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Motivasi harian
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? kNavy.withOpacity(0.4) : kGoldLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kGold.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Text('✨', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(motivasi,
                      style: TextStyle(fontSize: 13,
                          color: isDark ? kGold : kNavy,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
                  BoxShadow(
                    color: kNavy.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Tabunganmu',
                      style: TextStyle(color: Colors.white60, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(formatter.format(provider.totalSaldo),
                      style: const TextStyle(
                          color: kGold, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${provider.celenganList.length} celengan aktif',
                      style: const TextStyle(color: Colors.white60, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Celengan List
            if (provider.celenganList.isEmpty)
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text('Belum ada celengan',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : kNavy)),
                    const SizedBox(height: 8),
                    Text('Tap tombol + untuk membuat celengan pertamamu!',
                        style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                        textAlign: TextAlign.center),
                  ],
                ),
              )
            else ...[
              Text('Celenganku',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kNavy)),
              const SizedBox(height: 16),
              ...provider.celenganList.map((c) => _CelenganCard(celengan: c)).toList(),
            ],
          ],
        ),
      ),
    );
  }
}

class _CelenganCard extends StatelessWidget {
  final Celengan celengan;
  const _CelenganCard({required this.celengan});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SavingsProvider>().isDarkMode;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final colors = [
      kGold,
      const Color(0xFF2E5FA3),
      const Color(0xFF8B6914),
      const Color(0xFF1A4A8A),
      const Color(0xFFB8860B),
    ];
    final color = colors[celengan.id! % colors.length];

    String? countdownText;
    if (celengan.targetTanggal != null && !celengan.sudahTercapai) {
      final selisih = celengan.targetTanggal!.difference(DateTime.now()).inDays;
      if (selisih > 0) {
        countdownText = '📅 $selisih hari lagi';
      } else if (selisih == 0) {
        countdownText = '📅 Hari ini target berakhir!';
      } else {
        countdownText = '⚠️ Target terlewat ${selisih.abs()} hari';
      }
    }

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => DetailScreen(celengan: celengan))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? kCardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(celengan.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(celengan.nama,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                              color: isDark ? Colors.white : kNavy)),
                      Text(formatter.format(celengan.saldo),
                          style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14)),
                    ],
                  ),
                ),
                if (celengan.sudahTercapai)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: kGoldLight, borderRadius: BorderRadius.circular(20)),
                    child: const Text('🎉 Tercapai!',
                        style: TextStyle(fontSize: 11, color: kNavy, fontWeight: FontWeight.bold)),
                  )
                else
                  Text('${(celengan.persentase * 100).toStringAsFixed(0)}%',
                      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            if (celengan.target > 0) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: celengan.persentase,
                  backgroundColor: color.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 7,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Target: ${formatter.format(celengan.target)}',
                      style: TextStyle(fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[500])),
                  if (countdownText != null)
                    Text(countdownText,
                        style: TextStyle(fontSize: 11,
                            color: isDark ? Colors.grey[400] : Colors.grey[500],
                            fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}