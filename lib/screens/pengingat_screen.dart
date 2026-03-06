import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notification_helper.dart';

class PengingatScreen extends StatefulWidget {
  const PengingatScreen({super.key});

  @override
  State<PengingatScreen> createState() => _PengingatScreenState();
}

class _PengingatScreenState extends State<PengingatScreen> {
  bool _pengingatAktif = false;
  TimeOfDay _waktuPengingat = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadPengaturan();
    NotificationHelper.requestPermission();
  }

  Future<void> _loadPengaturan() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pengingatAktif = prefs.getBool('pengingat_aktif') ?? false;
      final jam = prefs.getInt('pengingat_jam') ?? 8;
      final menit = prefs.getInt('pengingat_menit') ?? 0;
      _waktuPengingat = TimeOfDay(hour: jam, minute: menit);
    });
  }

  Future<void> _simpanPengaturan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pengingat_aktif', _pengingatAktif);
    await prefs.setInt('pengingat_jam', _waktuPengingat.hour);
    await prefs.setInt('pengingat_menit', _waktuPengingat.minute);
  }

  Future<void> _pilihWaktu() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _waktuPengingat,
    );
    if (picked != null) {
      setState(() => _waktuPengingat = picked);
      await _simpanPengaturan();
      if (_pengingatAktif) {
        await NotificationHelper.jadwalkanPengingat(
          id: 1,
          namaCelengan: 'semua celengan',
          jam: picked.hour,
          menit: picked.minute,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '🔔 Pengingat diatur pukul ${picked.format(context)}'),
              backgroundColor: const Color(0xFF2EC4A0),
            ),
          );
        }
      }
    }
  }

  Future<void> _togglePengingat(bool value) async {
    setState(() => _pengingatAktif = value);
    await _simpanPengaturan();
    if (value) {
      await NotificationHelper.jadwalkanPengingat(
        id: 1,
        namaCelengan: 'semua celengan',
        jam: _waktuPengingat.hour,
        menit: _waktuPengingat.minute,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔔 Pengingat menabung diaktifkan!'),
            backgroundColor: Color(0xFF2EC4A0),
          ),
        );
      }
    } else {
      await NotificationHelper.batalkanPengingat(1);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔕 Pengingat menabung dimatikan'),
            backgroundColor: Colors.grey,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A2E)
          : const Color(0xFFFDF6ED),
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF1A1A2E)
            : const Color(0xFFFDF6ED),
        elevation: 0,
        title: Text('🔔 Pengingat Menabung',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E)),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A3E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pengingat Harian',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1A1A2E))),
                          Text('Ingatkan saya untuk menabung',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[500])),
                        ],
                      ),
                      Switch(
                        value: _pengingatAktif,
                        onChanged: _togglePengingat,
                        activeColor: const Color(0xFF2EC4A0),
                      ),
                    ],
                  ),
                  if (_pengingatAktif) ...[
                    const Divider(height: 24),
                    GestureDetector(
                      onTap: _pilihWaktu,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2EC4A0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color:
                                  const Color(0xFF2EC4A0).withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Waktu Pengingat',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1A1A2E))),
                            Row(
                              children: [
                                Text(
                                  _waktuPengingat.format(context),
                                  style: const TextStyle(
                                      color: Color(0xFF2EC4A0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.access_time,
                                    color: Color(0xFF2EC4A0), size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2EC4A0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF2EC4A0).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pengingat akan muncul setiap hari pada waktu yang kamu pilih!',
                      style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF5EDFC4)
                              : const Color(0xFF1FA085)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}