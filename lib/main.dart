import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vxuhuzsnvovumuoidkta.supabase.co',
    anonKey: 'sb_publishable_bHYsskCSqgboW7-9P4z5EQ_KBzLLmAu',
  );

  runApp(
    const ProviderScope(
      child: DersaiApp(),
    ),
  );
}