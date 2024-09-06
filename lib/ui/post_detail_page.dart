import 'package:demo2/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/post_provider.dart';
import '../utils/strings.dart';

class PostDetailPage extends StatefulWidget {
  final int id;

  const PostDetailPage({super.key, required this.id});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        Provider.of<PostProvider>(context, listen: false)
            .getPostDetail(widget.id);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColorYellow,
          title: const Text(
            Strings.postDetail,
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
            } else if (value.postModel != null) {
              return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        value.postModel!.title.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        value.postModel!.body.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ));
            }
            else {
              return const Center(
                child: Text("NO DATA"),
              );
            }
          },
        ),
      ),
    );
  }
}
