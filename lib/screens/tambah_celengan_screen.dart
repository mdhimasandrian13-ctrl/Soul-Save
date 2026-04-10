import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/celengan_model.dart';
import '../providers/savings_provider.dart';
import 'home_screen.dart';

class TambahCelenganScreen extends StatefulWidget {
  final Celengan? celengan;
  const TambahCelenganScreen({super.key, this.celengan});

  @override
  State<TambahCelenganScreen> createState() => _TambahCelenganScreenState();
}

class _TambahCelenganScreenState extends State<TambahCelenganScreen> {
  final _namaCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  String _selectedEmoji = '🐷';

  final List<String> _emojis = [
    '🐷','✈️','💻','📱','🏠','🎓','💍','🛡️','🎮','🚗',
    '👗','📚','🍕','⚽','🎸','🌴','💊','🎁','💰','⭐',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.celengan != null) {
      _namaCtrl.text = widget.celengan!.nama;
      _targetCtrl.text = widget.celengan!.target.toStringAsFixed(0);
      _selectedEmoji = widget.celengan!.emoji;
    }
  }

  void _simpan() {
    if (_namaCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama celengan tidak boleh kosong!')));
      return;
    }

    final celengan = Celengan(
      id: widget.celengan?.id,
      nama: _namaCtrl.text.trim(),
      emoji: _selectedEmoji,
      target: double.tryParse(_targetCtrl.text.replaceAll('.', '')) ?? 0,
      saldo: widget.celengan?.saldo ?? 0,
      createdAt: widget.celengan?.createdAt ?? DateTime.now(),
    );

    final provider = context.read<SavingsProvider>();
    if (widget.celengan == null) {
      provider.tambahCelengan(celengan);
    } else {
      provider.editCelengan(celengan);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SavingsProvider>().isDarkMode;
    final bgColor = isDark ? kBgDark : const Color(0xFFF5F5F0);
    final cardColor = isDark ? kCardDark : Colors.white;
    final textColor = isDark ? Colors.white : kNavy;
    final subTextColor = isDark ? Colors.white60 : Colors.grey[600]!;
    final isEdit = widget.celengan != null;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(isEdit ? 'Edit Celengan' : 'Celengan Baru',
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
            Text('Pilih Ikon',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: subTextColor)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _emojis.map((e) {
                final selected = e == _selectedEmoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = e),
                  child: Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: selected ? kGold.withOpacity(0.15) : cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? kGold : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(child: Text(e, style: const TextStyle(fontSize: 24))),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Nama Celengan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: subTextColor)),
            const SizedBox(height: 10),
            TextField(
              controller: _namaCtrl,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Contoh: Liburan Bali',
                hintStyle: TextStyle(color: subTextColor),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            Text('Target Nominal (opsional)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: subTextColor)),
            const SizedBox(height: 10),
            TextField(
              controller: _targetCtrl,
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Contoh: 5000000',
                hintStyle: TextStyle(color: subTextColor),
                prefixText: 'Rp ',
                prefixStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGold,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(isEdit ? 'Simpan Perubahan' : 'Buat Celengan',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}