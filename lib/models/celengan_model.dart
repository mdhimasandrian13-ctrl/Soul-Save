class Celengan {
  final int? id;
  final String nama;
  final String emoji;
  final double target;
  final double saldo;
  final DateTime? targetTanggal;
  final DateTime createdAt;

  Celengan({
    this.id,
    required this.nama,
    required this.emoji,
    required this.target,
    required this.saldo,
    this.targetTanggal,
    required this.createdAt,
  });

  double get persentase => target > 0 ? (saldo / target).clamp(0.0, 1.0) : 0.0;
  bool get sudahTercapai => saldo >= target && target > 0;

  Map<String, dynamic> toMap() => {
    'id': id,
    'nama': nama,
    'emoji': emoji,
    'target': target,
    'saldo': saldo,
    'targetTanggal': targetTanggal?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory Celengan.fromMap(Map<String, dynamic> map) => Celengan(
    id: map['id'],
    nama: map['nama'],
    emoji: map['emoji'],
    target: map['target'],
    saldo: map['saldo'],
    targetTanggal: map['targetTanggal'] != null
        ? DateTime.parse(map['targetTanggal'])
        : null,
    createdAt: DateTime.parse(map['createdAt']),
  );

  Celengan copyWith({
    int? id,
    String? nama,
    String? emoji,
    double? target,
    double? saldo,
    DateTime? targetTanggal,
    DateTime? createdAt,
  }) =>
      Celengan(
        id: id ?? this.id,
        nama: nama ?? this.nama,
        emoji: emoji ?? this.emoji,
        target: target ?? this.target,
        saldo: saldo ?? this.saldo,
        targetTanggal: targetTanggal ?? this.targetTanggal,
        createdAt: createdAt ?? this.createdAt,
      );
}