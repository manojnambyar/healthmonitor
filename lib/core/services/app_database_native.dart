import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

QueryExecutor openConnection() {
  final appDir = getApplicationSupportDirectory();
  return LazyDatabase(() async {
    final dir = await appDir;
    await dir.create(recursive: true);
    final file = File(p.join(dir.path, 'glucosesync.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}