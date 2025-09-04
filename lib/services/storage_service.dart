import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();
  static const _keyFirstTime = 'isFirstTime';
  static Future<void> init() async {
    await GetStorage.init();
  }

  static bool isFirstTime() {
    return _box.read(_keyFirstTime) ?? true;
  }

  static Future<void> setFirstTime(bool value) async {
    await _box.write(_keyFirstTime, value);
  }
}
