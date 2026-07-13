class TryOnJobModel {
  const TryOnJobModel({
    required this.id,
    required this.status,
    this.resultUrl,
    this.errorMessage = '',
  });

  final String id;
  final String status;
  final String? resultUrl;
  final String errorMessage;

  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';

  factory TryOnJobModel.fromJson(Map<String, Object?> json) {
    return TryOnJobModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      resultUrl: json['result_url']?.toString(),
      errorMessage: json['error_message']?.toString() ?? '',
    );
  }
}
