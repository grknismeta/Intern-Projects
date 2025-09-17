abstract class ApiRepository {
  Future<String> getData();
  Future<void> setData(String data);
  Future<void> updateData(String data, String key);
}
