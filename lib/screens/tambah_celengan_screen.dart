import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/celengan_model.dart';
import '../providers/savings_provider.dart';

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
          const SnackBar(
              content: Text('Nama celengan tidak boleh kosong!')));
      return;
    }

    final celengan = Celengan(
      id: widget.celengan?.id,
      nama: _namaCtrl.text.trim(),
      emoji: _selectedEmoji,
      target: double.tryParse(
              _targetCtrl.text.replaceAll('.', '')) ?? 0,
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
    final isEdit = widget.celengan != null;
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF6ED),
        elevation: 0,
        title: Text(isEdit ? 'Edit Celengan' : 'Celengan Baru',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Ikon',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _emojis.map((e) {
                final selected = e == _selectedEmoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = e),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF2EC4A0).withOpacity(0.15)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: selected
                              ? const Color(0xFF2EC4A0)
                              : Colors.transparent,
                          width: 2),
                    ),
                    child: Center(
                        child: Text(e,
                            style: const TextStyle(fontSize: 24))),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Nama Celengan',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            TextField(
              controller: _namaCtrl,
              decoration: InputDecoration(
                hintText: 'Contoh: Liburan Bali',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Target Nominal (opsional)',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            TextField(
              controller: _targetCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 5000000',
                prefixText: 'Rp ',
                filled: true,
                fillColor: Colors.white,
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
                  backgroundColor: const Color(0xFF2EC4A0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                    isEdit ? 'Simpan Perubahan' : 'Buat Celengan',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}