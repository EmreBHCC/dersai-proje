import 'dart:convert';

class NoteGenerationPrompt {
  const NoteGenerationPrompt._();

  static const Map<String, dynamic> noteSchema = {
    'type': 'object',
    'properties': {
      'title': {
        'type': 'string',
        'description': 'Notun kısa ve açıklayıcı başlığı.',
      },
      'summary': {
        'type': 'string',
        'description': 'Notun iki üç cümlelik genel özeti.',
      },
      'sections': {
        'type': 'array',
        'description': 'Konulara göre düzenlenmiş bölümler.',
        'items': {
          'type': 'object',
          'properties': {
            'heading': {'type': 'string'},
            'explanation': {
              'type': 'string',
              'description': 'Konunun detaylı açıklaması.',
            },
            'examples': {
              'type': 'array',
              'description': 'Konuyu pekiştiren somut örnekler.',
              'items': {'type': 'string'},
            },
          },
          'required': ['heading', 'explanation', 'examples'],
        },
      },
      'key_points': {
        'type': 'array',
        'description': 'Akılda tutulması gereken kısa maddeler.',
        'items': {'type': 'string'},
      },
    },
    'required': ['title', 'summary', 'sections', 'key_points'],
  };

  static final String system =
      'Sen öğrencilere yardım eden bir ders notu asistanısın. Sana, bir ders '
      'notu fotoğrafından optik karakter tanıma (OCR) ile çıkarılmış metin '
      'verilir. Bu metin yazım hataları veya eksik karakterler içerebilir. '
      'İçeriği oku, konularına göre düzenle, her konuyu anlaşılır şekilde '
      'detaylandır ve somut örneklerle pekiştir. Metinde olmayan bilgiyi '
      'uydurma; yalnızca metindeki konuyu açıkla ve genişlet. Formülleri '
      'sade metin olarak yaz. Tüm çıktıyı Türkçe üret. Hiçbir araç çağırma. '
      'Yanıtın yalnızca aşağıdaki JSON şemasına uyan tek bir JSON nesnesi '
      'olsun, öncesinde veya sonrasında hiçbir açıklama yazma.\n\n'
      '${jsonEncode(noteSchema)}';

  static String userMessage(String ocrText) {
    return 'Bu ders notundan düzenli bir not oluştur. Aşağıdaki metin, not '
        'görselinden OCR ile çıkarılmıştır:\n\n$ocrText';
  }
}
