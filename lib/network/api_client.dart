import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/post_model.dart';

class ApiClient {
  static const String url = "https://jsonplaceholder.typicode.com/posts";

  Future<List<PostModel>> getData() async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((e) => PostModel.fromJson(e)).toList();
    } else {
      throw Exception("NO Data");
    }
  }
  Future<PostModel> getDetail(int id) async {
    final res = await http.get(Uri.parse("${url}/${id}"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return PostModel.fromJson(data);
    } else {
      throw Exception("NO Data");
    }
  }
}
