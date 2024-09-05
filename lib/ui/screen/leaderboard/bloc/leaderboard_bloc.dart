import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/leader.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/leaderboard_repository.dart';
import 'package:meta_bio/util/request_state_error_handler_bloc.dart';

part 'leaderboard_bloc.freezed.dart';
part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc
    extends RequestStateHandlerBloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepository _leaderboardRepository;

  LeaderboardBloc(this._leaderboardRepository, context)
      : super(const LeaderboardState.state(), context) {
    on<LoadLeaderBoard>(_onLoadLeaderBoard);
  }

  void _onLoadLeaderBoard(
      LoadLeaderBoard event, Emitter<LeaderboardState> emit) async {
    emit(state.copyWith(leaderboardRequestState: const RequestStateLoading()));

    final requestState = await _leaderboardRepository.getLeaderboard();

    super.handleRequestState(requestState);

    emit(state.copyWith(leaderboardRequestState: requestState));
  }
}
