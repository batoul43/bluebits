import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CachHelper {
  // إنشاء نسخة واحدة من التخزين الآمن
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // دالة لحفظ البيانات (مثل الـ Token)
  static Future<void> setValue(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      // إعدادات إضافية للأمان في أندرويد (اختياري)
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  // دالة لجلب البيانات
  static Future<String?> getValue(String key) async {
    return await _storage.read(
      key: key,
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  // دالة لحذف قيمة معينة (مثل تسجيل الخروج)
  static Future<void> removeValue(String key) async {
    await _storage.delete(key: key);
  }

  // دالة لمسح كل البيانات المخزنة
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
