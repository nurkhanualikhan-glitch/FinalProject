import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/post_model.dart';

sealed class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostModel> posts;

  PostLoaded(this.posts);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  void loadPosts() {
    emit(PostLoading());

    _subscription?.cancel();

    _subscription = _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final posts = snapshot.docs.map(PostModel.fromDoc).toList();
        emit(PostLoaded(posts));
      },
      onError: (error) {
        emit(PostError(error.toString()));
      },
    );
  }

  Future<void> createPost(String content) async {
    final user = _auth.currentUser;

    if (user == null || content.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    final username = prefs.getString('username') ??
        user.displayName ??
        user.email?.split('@').first ??
        'User';

    final doc = _firestore.collection('posts').doc();

    final post = PostModel(
      postId: doc.id,
      userId: user.uid,
      username: username,
      content: content.trim(),
      createdAt: DateTime.now(),
      likesCount: 0,
      likedBy: const [],
    );

    await doc.set(post.toMap());
  }

  Future<void> toggleLike(PostModel post) async {
    final user = _auth.currentUser;

    if (user == null) return;

    final alreadyLiked = post.likedBy.contains(user.uid);

    await _firestore.collection('posts').doc(post.postId).update({
      'likedBy': alreadyLiked
          ? FieldValue.arrayRemove([user.uid])
          : FieldValue.arrayUnion([user.uid]),
      'likesCount': FieldValue.increment(alreadyLiked ? -1 : 1),
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
