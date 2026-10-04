import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/http_providers.dart';
import '../../data/services/note_generation_service.dart';
import '../../domain/models/generated_note.dart';
import '../../domain/models/note_generation_request.dart';

final noteGenerationServiceProvider = Provider<NoteGenerationService>((ref) {
  return NoteGenerationService(ref.watch(httpClientProvider));
});

class NoteGenerationController
    extends AutoDisposeAsyncNotifier<GeneratedNote?> {
  @override
  Future<GeneratedNote?> build() async => null;

  Future<void> generate(NoteGenerationRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(noteGenerationServiceProvider).generate(request),
    );
  }
}

final noteGenerationControllerProvider =
    AutoDisposeAsyncNotifierProvider<NoteGenerationController, GeneratedNote?>(
  NoteGenerationController.new,
);
