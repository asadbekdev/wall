part of 'post_bloc.dart';

abstract class PostEvent {}

class LoadPosts extends PostEvent {}

class AddPost extends PostEvent {
  final PostModel post;
  AddPost(this.post);
}

class FilterUserPosts extends PostEvent {
  final String userId;
  FilterUserPosts(this.userId);
}