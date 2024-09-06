import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/post_model.dart';

class AppSession {
  static AppSession? _instance;
  SharedPreferences? _sharedPreferences;

  AppSession._() {
    _instance = this;
  }

  factory AppSession() => _instance ?? AppSession._();

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static const postsKey = 'posts';

  Future<void> savePosts(List<PostModel> posts) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String data =
        json.encode(posts.map((post) => post.toJson()).toList());
    sharedPreferences.setString(postsKey, data);
  }

  Future<List<PostModel>> loadPosts() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? data = sharedPreferences.getString(postsKey);
    if (data != null) {
      final List<dynamic> jsonData = json.decode(data);
      return jsonData.map((json) => PostModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
