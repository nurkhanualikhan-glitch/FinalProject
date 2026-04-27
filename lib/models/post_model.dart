import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String userId;
  final String username;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final List<String> likedBy;

  const PostModel({
    required this.postId,
    required this.userId,
    required this.username,
    required this.content,
    required this.createdAt,
    required this.likesCount,
    required this.likedBy,
  });

  factory PostModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return PostModel(
      postId: data['postId'] ?? doc.id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? 'User',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likesCount: data['likesCount'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likesCount': likesCount,
      'likedBy': likedBy,
    };
  }
}
