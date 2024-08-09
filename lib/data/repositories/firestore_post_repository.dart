import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wall/domain/repositories/i_post_facade.dart';
import '../../domain/entities/post.dart';

class FirestorePostRepository implements IPostFacade {
  final FirebaseFirestore _firestore;

  FirestorePostRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Post>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Post(
          id: doc.id,
          userId: data['userId'],
          userName: data['userName'],
          userPhotoUrl: data['userPhotoUrl'],
          content: data['content'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  @override
  Future<void> addPost(Post post) async {
    await _firestore.collection('posts').add({
      'userId': post.userId,
      'userName': post.userName,
      'content': post.content,
      'timestamp': Timestamp.fromDate(post.timestamp),
    });
  }

  @override
  Stream<List<Post>> getUserPosts(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Post(
          id: doc.id,
          userId: data['userId'],
          userName: data['userName'],
          userPhotoUrl: data['userPhotoUrl'],
          content: data['content'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}
