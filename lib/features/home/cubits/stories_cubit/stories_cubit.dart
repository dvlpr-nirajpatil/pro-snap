import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prosnap/core/models/story.dart';
import 'package:prosnap/core/network/api_exception.dart';
import 'package:prosnap/features/story/repository/story_repository.dart';

part 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final StoryRepository repository = StoryRepository();
  StoriesCubit() : super(StoriesInitial());
  List<Story> stories = [];

  // PAGINATION
  int currentPage = 1;
  bool hasnext = true;
  bool loadingNext = false;

  getInitialStories() async {
    emit(GetStoriesLoadingState());
    try {
      final response = await repository.getStories();
      final List rawStories = response['data']['stories'];
      stories = rawStories.map((e) => Story.fromJson(e)).toList();
      currentPage = response['data']['pagination']['page'];
      hasnext = response['data']['pagination']['hasNext'];

      emit(GetStoriesSuccessState());
    } catch (e) {
      if (e is AppException) {
        emit(GetStoriesErrorState(error: e.message));
      } else {
        emit(GetStoriesErrorState(error: e.toString()));
      }
    }
  }

  getNextStories() async {
    if (loadingNext || hasnext == false) return;

    loadingNext = true;

    try {
      final response = await repository.getStories(page: currentPage + 1);
      final List rawStories = response['data']['stories'];
      stories.addAll(rawStories.map((e) => Story.fromJson(e)).toList());
      currentPage = response['data']['pagination']['page'];
      hasnext = response['data']['pagination']['hasNext'];

      emit(GetStoriesSuccessState());
    } catch (e) {
      if (e is AppException) {
        emit(GetStoriesErrorState(error: e.message));
      } else {
        emit(GetStoriesErrorState(error: e.toString()));
      }
    } finally {
      loadingNext = false;
    }
  }
}
