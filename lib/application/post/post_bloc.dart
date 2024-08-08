import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;

  PostBloc(this._postRepository) : super(PostInitial()) {
    on<LoadPosts>((event, emit) async {
      emit(PostLoading());
      await emit.forEach(
        _postRepository.getPosts(),
        onData: (List<PostModel> posts) => PostLoaded(posts),
        onError: (error, stackTrace) => PostError(error.toString()),
      );
    });

    on<AddPost>((event, emit) async {
      await _postRepository.addPost(event.post);
    });

    on<FilterUserPosts>((event, emit) async {
      emit(PostLoading());
      await emit.forEach(
        _postRepository.getUserPosts(event.userId),
        onData: (List<PostModel> posts) => PostLoaded(posts),
        onError: (error, stackTrace) => PostError(error.toString()),
      );
    });
  }
}
