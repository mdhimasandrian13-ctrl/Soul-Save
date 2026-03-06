enum TipeTransaksi { setor, tarik }

class Transaksi {
  final int? id;
  final int celenganId;
  final TipeTransaksi tipe;
  final double nominal;
  final String? catatan;
  final DateTime tanggal;

  Transaksi({
    this.id,
    required this.celenganId,
    required this.tipe,
    required this.nominal,
    this.catatan,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'celenganId': celenganId,
    'tipe': tipe.name,
    'nominal': nominal,
    'catatan': catatan,
    'tanggal': tanggal.toIso8601String(),
  };

  factory Transaksi.fromMap(Map<String, dynamic> map) => Transaksi(
    id: map['id'],
    celenganId: map['celenganId'],
    tipe: TipeTransaksi.values.byName(map['tipe']),
    nominal: map['nominal'],
    catatan: map['catatan'],
    tanggal: DateTime.parse(map['tanggal']),
  );
}