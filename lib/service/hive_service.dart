// Flutter imports:

// Package imports:
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String coreBox = 'coreBox';

  Future<void> initialize() async {
    await Hive.openBox(coreBox);
  }

  Future<void> addValue({
    required String key,
    dynamic value,
  }) async {
    final box = Hive.box(coreBox);
    await box.put(key, value);
  }

  Future<dynamic> getValue({
    required String key,
    dynamic defaultValue,
  }) async {
    final box = Hive.box(coreBox);
    return box.get(key, defaultValue: defaultValue);
  }

  Future<void> removeValue(String key) async {
    final box = Hive.box(coreBox);
    await box.delete(key);
  }

  Future<void> clearBox() async {
    final box = Hive.box(coreBox);
    await box.clear();
  }
}
