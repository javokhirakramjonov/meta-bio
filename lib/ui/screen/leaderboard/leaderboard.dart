import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/domain/leader.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/domain/user.dart';
import 'package:meta_bio/ui/component/loading_view.dart';
import 'package:meta_bio/ui/screen/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:meta_bio/ui/screen/leaderboard/component/leaderboard_item.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: BlocProvider(
        create: (context) => LeaderboardBloc(GetIt.I.get(), context)
          ..add(const LeaderboardEvent.loadLeaderBoard()),
        child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            final leaderboardRequestState = state.leaderboardRequestState;

            return Stack(
              children: [
                Column(
                  children: [
                    _buildHeader(context, state),
                    Expanded(
                        child: _buildLeaderboardList(
                            context, leaderboardRequestState))
                  ],
                ),
                if (leaderboardRequestState is RequestStateLoading)
                  loadingView(context)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, LeaderboardState state) {
    final leaderboardRequestState = state.leaderboardRequestState;

    final List<User> top3 =
        leaderboardRequestState is RequestStateSuccess<List<Leader>>
            ? leaderboardRequestState.data.take(3).map((e) => e.user).toList()
            : [];

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.only(top: 39),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Leaderboard',
                  style: TextStyle(
                    color: Color(0xFF0D0D0D),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildTop3Leaders(context, top3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTop3Leaders(BuildContext context, List<User> leaders) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: _buildLeader(context, leaders.elementAtOrNull(2), 3)),
        Expanded(child: _buildLeader(context, leaders.elementAtOrNull(0), 1)),
        Expanded(child: _buildLeader(context, leaders.elementAtOrNull(1), 2)),
      ],
    );
  }

  Widget _buildLeader(BuildContext context, User? leader, int position) {
    final _leader = leader;

    return Column(
      children: [
        if (_leader != null)
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(_leader.avatar),
          ),
        const SizedBox(height: 14),
        if (_leader != null)
          Text(
            _leader.firstName,
            style: const TextStyle(
              color: Color(0xFF0D0D0D),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        const SizedBox(height: 6),
        CustomPaint(
          painter: Podium(position),
          size: const Size(double.infinity, 16),
        ),
        Container(
          width: double.infinity,
          height: position == 1
              ? 120
              : position == 2
                  ? 100
                  : 80,
          color: position == 1
              ? Theme.of(context).colorScheme.primary
              : const Color(0xFF128850),
          child: _leader != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _leader.score.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Points',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        )
      ],
    );
  }

  Widget _buildLeaderboardList(BuildContext context,
      RequestState<List<Leader>> leaderboardRequestState) {
    if (leaderboardRequestState is RequestStateSuccess<List<Leader>>) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
      );
    }

    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read<LeaderboardBloc>().add(
                const LeaderboardEvent.loadLeaderBoard(),
              );
        },
        child: const Text('Reload'),
      ),
    );
  }
}

class Podium extends CustomPainter {
  final int position;

  Podium(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF38D38B)
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(position != 2 ? (size.width * 0.2) : 0, 0);
    path.lineTo(position != 3 ? (size.width * 0.8) : size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
