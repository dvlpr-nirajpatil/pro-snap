part of 'posts_cubit.dart';

sealed class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

final class PostsInitial extends PostsState {}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// GET POSTS STATES
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class GetPostsStates extends PostsState {}

class GetPostsLoadingState extends GetPostsStates {}

class GetPostsSuccessState extends GetPostsStates {
  final DateTime _dateTime = DateTime.now();

  @override
  // TODO: implement props
  List<Object> get props => [_dateTime];
}

class GetPostsErrorState extends GetPostsStates {
  final String error;

  GetPostsErrorState({required this.error});
}
