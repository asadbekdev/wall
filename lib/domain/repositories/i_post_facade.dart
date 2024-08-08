import 'package:wall/domain/entities/post.dart';

abstract interface class IPostFacade {
  Stream<List<Post>> getPosts();
  Future<void> addPost(Post post);
  Stream<List<Post>> getUserPosts(String userId);
}
