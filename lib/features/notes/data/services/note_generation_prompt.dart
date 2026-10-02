import '../../../detection/domain/models/detected_object.dart';

class NoteGenerationPrompt {
  const NoteGenerationPrompt._();

  static const String toolName = 'create_note';

  static const String system =
      'Sen öğrencilere yardım eden bir ders notu asistanısın. Sana bir ders '
      'notu görseli ve bu görselde bir nesne tespit modeliyle bulunmuş '
      'bölgeler verilir. Bölgeler "text" (yazı), "math" (formül) ve "image" '
      '(şekil veya çizim) sınıflarından oluşur. Görseldeki içeriği oku, '
      'konularına göre düzenle, her konuyu anlaşılır şekilde detaylandır ve '
      'somut örneklerle pekiştir. Görselde olmayan bilgiyi uydurma; yalnızca '
      'görseldeki konuyu açıkla ve genişlet. Formülleri sade metin olarak '
      'yaz. Tüm çıktıyı Türkçe üret ve sonucu yalnızca $toolName aracı '
      'üzerinden döndür.';

  static const Map<String, dynamic> toolDefinition = {
    'name': toolName,
    'description': 'Taranan ders notundan düzenli ve detaylı bir not oluşturur.',
    'input_schema': {
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
    },
  };

  static String userMessage({
    required List<DetectedObject> detections,
    required int imageWidth,
    required int imageHeight,
  }) {
    final regions = detections.map((detection) {
      final box = detection.boundingBox;
      final left = (box.left / imageWidth * 100).round();
      final top = (box.top / imageHeight * 100).round();
      final right = (box.right / imageWidth * 100).round();
      final bottom = (box.bottom / imageHeight * 100).round();
      final confidence = (detection.confidence * 100).round();
      return '- ${detection.className} (güven %$confidence): '
          'sol %$left, üst %$top, sağ %$right, alt %$bottom';
    }).join('\n');

    final regionSection = detections.isEmpty
        ? 'Model herhangi bir bölge tespit etmedi, görseli bütünüyle değerlendir.'
        : 'Tespit edilen bölgeler (görsele göre yüzde konumları):\n$regions';

    return 'Bu ders notu görselinden düzenli bir not oluştur.\n\n$regionSection';
  }
}
