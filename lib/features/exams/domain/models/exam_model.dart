class ExamModel {
  const ExamModel({
    this.id,
    required this.userId,
    required this.dersId,
    required this.sinavAdi,
    required this.tarihSaat,
    this.sureDakika,
    this.konum,
    this.aciklama,
    this.hatirlatmaDakika,
    this.createdAt,
  });

  final String? id;
  final String userId;
  final String dersId;
  final String sinavAdi;
  final DateTime tarihSaat;
  final int? sureDakika;
  final String? konum;
  final String? aciklama;
  final int? hatirlatmaDakika;
  final DateTime? createdAt;

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      dersId: json['ders_id'] as String,
      sinavAdi: json['sinav_adi'] as String,
      tarihSaat: DateTime.parse(json['tarih_saat'] as String),
      sureDakika: json['sure_dakika'] as int?,
      konum: json['konum'] as String?,
      aciklama: json['aciklama'] as String?,
      hatirlatmaDakika: json['hatirlatma_dakika'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'ders_id': dersId,
      'sinav_adi': sinavAdi,
      'tarih_saat': tarihSaat.toIso8601String(),
      if (sureDakika != null) 'sure_dakika': sureDakika,
      if (konum != null && konum!.isNotEmpty) 'konum': konum,
      if (aciklama != null && aciklama!.isNotEmpty) 'aciklama': aciklama,
      if (hatirlatmaDakika != null) 'hatirlatma_dakika': hatirlatmaDakika,
    };
  }
}