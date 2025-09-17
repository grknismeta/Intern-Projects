import 'package:repository_pattern/services/api_services/api_repository.dart';

class MysqlService implements ApiRepository {
  @override
  Future<String> getData() {
    return Future.value('555');
  }

  @override
  Future<void> setData(String data) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> updateData(String data, String key) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
