import 'dart:async';
import 'dart:math';

import 'package:demo2/ui/post_detail_page.dart';
import 'package:demo2/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/post_provider.dart';
import '../utils/strings.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final Map<int, Timer?> time = {};
  final Map<int, int> remTime = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<PostProvider>(context, listen: false).getUserList();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    time.forEach((key, timer) => timer?.cancel());
    super.dispose();
  }

  void _startTimer(int postId, int initialTime) {
    remTime[postId] = initialTime;
    time[postId]?.cancel();
    time[postId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (remTime[postId]! > 0) {
          remTime[postId] = remTime[postId]! - 1;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _pauseTimer(int postId) {
    time[postId]?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColorYellow,
          title: const Text(
            Strings.posts,
            style: TextStyle(
              fontSize: 24,
              color: AppColors.primaryColorBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
          // centerTitle: true,
        ),
        body: Consumer<PostProvider>(
          builder: (context, value, child) {
            if (value.loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  itemBuilder: (context, index) {
                    var data = value.postList[index];
                    final timerDuration =
                        remTime[data.id!] ?? (10 + Random().nextInt(16));
                    remTime.putIfAbsent(data.id!, () => timerDuration);
                    return ListTile(
                      tileColor:
                          data.isRead ? AppColors.white : AppColors.lightYellow,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: AppColors.lightYellow2, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onTap: () {
                        Provider.of<PostProvider>(context, listen: false)
                            .isSeenPost(data.id!);
                        _pauseTimer(data.id!);
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostDetailPage(id: data.id!),
                                ))
                            .then((_) =>
                                _startTimer(data.id!, remTime[data.id!] ?? 10));
                      },
                      title: Text(
                        data.title.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        data.body.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          if (time[data.id!]?.isActive ?? false) {
                            _pauseTimer(data.id!);
                          } else {
                            _startTimer(data.id!, timerDuration);
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.timer_outlined),
                            const SizedBox(height: 2),
                            Text('${remTime[data.id!]}s'),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 15,
                    );
                  },
                  itemCount: value.postList.length);
            }
          },
        ),
      ),
    );
  }
}
