import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/posts/post_cubit.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('feed'.tr()),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoading || state is PostInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PostError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return Center(
                child: Text('no_posts'.tr()),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 250 + index * 40),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: PostCard(post: post),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
