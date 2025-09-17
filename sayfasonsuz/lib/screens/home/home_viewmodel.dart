import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sayfasonsuz/models/data_model.dart';

class HomeViewModel extends ChangeNotifier {  
  final scrollController = ScrollController();
  final _dio = Dio(); 

  final String _url = "https://dummyjson.com/posts";

  DataModel? dataModel;

  int _skip = 0;
  bool loading = false;
  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> fetchData() async {
    final args = {"limit": 10, "skip": _skip};

    setLoading(true);
    final Response res = await _dio.request(_url, queryParameters: args);
    await Future.delayed(const Duration(seconds: 2));
    setLoading(false);

    if (res.statusCode != 200) {
      return Future.error("Hata: ${res.statusMessage}");
    }

    _skip += 10;

    final DataModel data = DataModel.fromJson(res.data);

    if (dataModel == null) {
      dataModel = data;
    } else {
      dataModel!.posts.addAll(data.posts);
    }

    notifyListeners();
  }

  void listenScrollBottom() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        final bool top = scrollController.position.pixels == 0;
        if (!top && !loading) fetchData();
      }
    });
  }
}
