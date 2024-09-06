import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/post_model.dart';
import '../network/api_client.dart';

class PostProvider extends ChangeNotifier {
  List<PostModel> postList = [];
  bool _loading = false;
  PostModel? postModel;

  List<PostModel> get posts => postList;

  bool get loading => _loading;

  PostModel? get post => postModel;

  Future<void> getUserList() async {
    _loading = true;
    notifyListeners();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final storedPosts = prefs.getString('posts');
      if (storedPosts != null) {
        postList = (json.decode(storedPosts) as List)
            .map((data) => PostModel.fromJson(data))
            .toList();
      }
      postList = await ApiClient().getData();
      await prefs.setString('posts', json.encode(postList));
    } catch (e) {
      postList = [];
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> getPostDetail(int id) async {
    _loading = true;
    notifyListeners();
    try {
      postModel = await ApiClient().getDetail(id);
    } catch (e) {
      if (kDebugMode) {
        postModel = null;
      }
    }
    _loading = false;
    notifyListeners();
  }

  void isSeenPost(int postId) {
    postList.firstWhere((post) => post.id == postId).isRead = true;
    notifyListeners();
  }
}
