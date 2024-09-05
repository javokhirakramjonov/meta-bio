part of 'leaderboard_bloc.dart';

@freezed
class LeaderboardState with _$LeaderboardState {
  const factory LeaderboardState.state({
    @Default(RequestStateInitial())
    RequestState<List<Leader>> leaderboardRequestState,
  }) = _Initial;
}
