import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/domain/leader.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/ui/component/loading_view.dart';
import 'package:meta_bio/ui/screen/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:meta_bio/ui/screen/leaderboard/component/leaderboard_item.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Leaderboard',
              style: TextStyle(
                color: Color(0xFF0D0D0D),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              )),
        ),
        body: BlocProvider(
            create: (context) => LeaderboardBloc(GetIt.I.get(), context)
              ..add(const LeaderboardEvent.loadLeaderBoard()),
            child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
                builder: (context, state) {
              final leaderboardRequestState = state.leaderboardRequestState;

              return leaderboardRequestState
                      is RequestStateSuccess<List<Leader>>
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D0D0D),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<LeaderboardBloc>()
                              .add(const LeaderboardEvent.loadLeaderBoard());
                        },
                        child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: leaderboardRequestState.data.length,
                            itemBuilder: (context, index) {
                              return LeaderboardItem(
                                leader: leaderboardRequestState.data[index],
                              );
                            }),
                      ),
                    )
                  : loadingView(context);
            })));
  }
}
