import 'package:flutter/material.dart';

class PengingatScreen extends StatelessWidget {
  const PengingatScreen({super.key});

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔔', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 20),
              Text('Fitur Segera Hadir!',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
              const SizedBox(height: 12),
              Text(
                'Fitur pengingat menabung sedang dalam pengembangan dan akan segera tersedia.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}