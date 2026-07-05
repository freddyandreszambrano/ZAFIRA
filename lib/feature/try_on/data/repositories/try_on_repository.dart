import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/try_on_job_model.dart';
import '../interfaces/try_on_interface.dart';
import '../services/try_on_service.dart';

final tryOnRepositoryProvider = Provider<ITryOn>((ref) {
  final remoteDataSource = ref.watch(tryOnServiceProvider);
  return TryOnRepository(remoteDataSource: remoteDataSource);
});

class TryOnRepository implements ITryOn {
  TryOnRepository({required this.remoteDataSource});

  final TryOnService remoteDataSource;

  @override
  Future<TryOnJobModel> createJob(int productId) async =>
      await remoteDataSource.createJob(productId);

  @override
  Future<TryOnJobModel> getJob(String jobId) async =>
      await remoteDataSource.getJob(jobId);
}
