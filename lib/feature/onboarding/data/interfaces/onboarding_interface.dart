abstract class IOnboardingRepository {
  Future<void> submit(Map<String, String> answers);
}
