import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cubits/posts/post_cubit.dart';
import '../models/post_model.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      lowerBound: 0.85,
      upperBound: 1,
      value: 1,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> likePost() async {
    await animationController.reverse();
    await animationController.forward();

    if (!mounted) return;

    await context.read<PostCubit>().toggleLike(widget.post);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final liked = widget.post.likedBy.contains(currentUser?.uid);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.username,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM yyyy, HH:mm').format(widget.post.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Text(widget.post.content),
            const SizedBox(height: 12),
            Row(
              children: [
                ScaleTransition(
                  scale: animationController,
                  child: IconButton(
                    onPressed: likePost,
                    icon: Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      color: liked ? Colors.red : null,
                    ),
                  ),
                ),
                Text('${widget.post.likesCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
