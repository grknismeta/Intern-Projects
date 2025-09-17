import 'dart:developer';

import 'package:repository_pattern/services/api_services/api_repository.dart';

class FirebaseService implements ApiRepository {
  @override
  Future<String> getData() async {
    await Future.delayed(const Duration(seconds: 1));
    return '123';
  }

  @override
  Future<void> setData(String data) async {
    await Future.delayed(const Duration(seconds: 1));
    log(data);
  }

  @override
  Future<void> updateData(String data, String key) async {
    await Future.delayed(const Duration(seconds: 1));
    log('$key isimli veri güncellendi: $data');
  }
}
