import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meta_bio/domain/leader.dart';

class LeaderboardItem extends StatelessWidget {
  final Leader leader;

  const LeaderboardItem({super.key, required this.leader});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Text(leader.rank.toString(),
                style: const TextStyle(color: Color(0xFFC5CCDB))),
          ),
          const SizedBox(width: 16),
          avatar(context),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${leader.user.firstName} ${leader.user.lastName}',
                  style: const TextStyle(
                      color: Color(0xFFC6D0D9), fontWeight: FontWeight.w500)),
              RichText(
                text: TextSpan(children: [
                  const TextSpan(
                    text: 'Score: ',
                    style: TextStyle(
                        color: Color(0xFFC5CCDB), fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: leader.user.score.toString(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500),
                  )
                ]),
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget avatar(BuildContext context) {
    final rank = leader.rank;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
            image: DecorationImage(
              image: leader.user.avatar != ""
                  ? NetworkImage(leader.user.avatar)
                  : const AssetImage('assets/images/avatar.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (0 < rank && rank < 4)
          Positioned(
            bottom: -15,
            right: -15,
            child: SvgPicture.asset(
              rank == 1
                  ? 'assets/icons/gold.svg'
                  : rank == 2
                      ? 'assets/icons/silver.svg'
                      : 'assets/icons/bronze.svg',
              height: 40,
              width: 40,
            ),
          ),
      ],
    );
  }
}
