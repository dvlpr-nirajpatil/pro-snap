import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prosnap/core/models/post.dart';
import 'package:prosnap/core/network/api_exception.dart';
import 'package:prosnap/features/home/repository/home_repository.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final HomeRepository repository = HomeRepository();

  List<Post> posts = [];
  PostsCubit() : super(PostsInitial());

  // PAGINATIONS
  int currentPage = 1;
  bool hasNext = true;
  bool loadingNextPage = false;

  getInitialPosts() async {
    emit(GetPostsLoadingState());
    try {
      final response = await repository.getFeed();

      final List rawPosts = response['data']['posts'];
      posts = rawPosts.map((e) => Post.fromJson(e)).toList();

      currentPage = response['data']['pagination']['page'];
      hasNext = response['data']['pagination']['hasNext'];

      emit(GetPostsSuccessState());
    } catch (e) {
      if (e is AppException) {
        emit(GetPostsErrorState(error: e.message));
      } else {
        emit(GetPostsErrorState(error: e.toString()));
      }
    }
  }

  getNextPosts() async {
    if (loadingNextPage || hasNext == false) return;
    loadingNextPage = true;

    try {
      final response = await repository.getFeed(page: currentPage + 1);

      final List rawPosts = response['data']['posts'];
      posts.addAll(rawPosts.map((e) => Post.fromJson(e)).toList());

      currentPage = response['data']['pagination']['page'];
      hasNext = response['data']['pagination']['hasNext'];

      emit(GetPostsSuccessState());
    } catch (e) {
      if (e is AppException) {
        emit(GetPostsErrorState(error: e.message));
      } else {
        emit(GetPostsErrorState(error: e.toString()));
      }
    } finally {
      loadingNextPage = false;
    }
  }
}
