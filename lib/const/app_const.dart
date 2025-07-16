 import 'package:pocket_fm_demo/service/hive_service.dart';

final hiveService = HiveService();

String formatCategoryName(String slug) {
  return slug
      .replaceAll('-', ' ')
      .replaceAllMapped(
        RegExp(r'\b\w'),
        (match) => match.group(0)!.toUpperCase(),
      )
      .replaceAll("Mens", "Men's")
      .replaceAll("Womens", "Women's");
}
