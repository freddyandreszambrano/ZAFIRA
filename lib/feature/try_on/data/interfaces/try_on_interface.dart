import '../../domain/try_on_job_model.dart';

abstract class ITryOn {
  Future<TryOnJobModel> createJob(List<int> productIds);

  Future<TryOnJobModel> getJob(String jobId);
}
