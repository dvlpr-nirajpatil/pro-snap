part of 'stories_cubit.dart';

sealed class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object> get props => [];
}

final class StoriesInitial extends StoriesState {}

class GetStoriesState extends StoriesState {}

class GetStoriesLoadingState extends GetStoriesState {}

class GetStoriesSuccessState extends GetStoriesState {
  final DateTime _dateTime = DateTime.now();

  @override
  // TODO: implement props
  List<Object> get props => [_dateTime];
}

class GetStoriesErrorState extends GetStoriesState {
  final String error;

  GetStoriesErrorState({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
