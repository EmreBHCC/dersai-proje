class CourseModel {
  const CourseModel({
    this.id,
    required this.userId,
    required this.dersAdi,
    this.dersHocasi,
    this.kredi,
    this.haftalikSaat,
    this.createdAt,
  });

  final String? id;
  final String userId;
  final String dersAdi;
  final String? dersHocasi;
  final int? kredi;
  final int? haftalikSaat;
  final DateTime? createdAt;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id']?.toString(),
      userId: json['user_id'] as String,
      dersAdi: json['ders_adi'] as String,
      dersHocasi: json['ders_hocasi'] as String?,
      kredi: json['kredi'] as int?,
      haftalikSaat: json['haftalik_saat'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'ders_adi': dersAdi,
      if (dersHocasi != null && dersHocasi!.isNotEmpty)
        'ders_hocasi': dersHocasi,
      if (kredi != null) 'kredi': kredi,
      if (haftalikSaat != null) 'haftalik_saat': haftalikSaat,
    };
  }
}