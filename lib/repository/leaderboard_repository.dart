import 'package:dio/dio.dart';
import 'package:meta_bio/domain/leader.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/service/dio_provider.dart';

class LeaderboardRepository {
  late Dio _dio;

  LeaderboardRepository(DioProvider dioProvider) {
    _dio = dioProvider.dio;
  }

  Future<RequestState<List<Leader>>> getLeaderboard() async {
    try {
      final response = await _dio.get('/api/leaderboard');
      final leaders = (response.data['data'] as List)
          .map((e) => Leader.fromJson(e))
          .toList();

      return RequestState.success(leaders);
    } on DioException catch (e) {
      return RequestState.error(e.error.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }
}
