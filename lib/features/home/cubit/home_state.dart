part of 'home_cubit.dart';

abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomePageScoreLoading extends HomeState {

  HomePageScoreLoading();
  @override
  List<Object> get props => [];
}

class HomePageLoaded extends HomeState{
  final List<Result> results;
  final String lvl;
  final int numOfQues;
  final List points;

  HomePageLoaded(this.results, this.lvl, this.numOfQues, this.points);
  @override
  List<Object> get props => [results,lvl,numOfQues];
}