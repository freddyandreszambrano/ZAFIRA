import '../../domain/try_on_job_model.dart';

abstract class ITryOn {
  Future<TryOnJobModel> createJob(int productId);

  Future<TryOnJobModel> getJob(String jobId);
}
