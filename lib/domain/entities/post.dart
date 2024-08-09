import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userPhotoUrl;
  final String content;
  final DateTime timestamp;

  const Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhotoUrl,
    required this.content,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, userId, userName, content, timestamp];
}
