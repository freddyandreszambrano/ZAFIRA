import '../../../../core/enum/response_status.dart';
import '../../../../core/flavors/flavors_config.dart';
import '../../domain/user_model.dart';

class AuthState {
  AuthState({
    required this.status,
    required this.profileState,
    required this.version,
    required this.user,
    required this.isTokenExist,
    required this.isUpdateAvailable,
    this.errorMessage,
    this.failedLoginAttempts = 0,
  });

  factory AuthState.initial() => AuthState(
    status: ResponseStatus.initial,
    profileState: ResponseStatus.initial,
    version: Flavor.projectVersion,
    user: null,
    isTokenExist: false,
    isUpdateAvailable: false,
    errorMessage: null,
    failedLoginAttempts: 0,
  );

  final ResponseStatus status;
  final ResponseStatus profileState;
  final String? version;
  final UserModel? user;
  final bool? isTokenExist;
  final bool? isUpdateAvailable;
  final String? errorMessage;
  final int failedLoginAttempts;

  AuthState copyWith({
    ResponseStatus? status,
    ResponseStatus? profileState,
    String? version,
    UserModel? user,
    bool? isTokenExist,
    bool? isUpdateAvailable,
    String? errorMessage,
    int? failedLoginAttempts,
    bool clearErrorMessage = false,
  }) => AuthState(
    status: status ?? this.status,
    profileState: profileState ?? this.profileState,
    version: version ?? this.version,
    user: user ?? this.user,
    isTokenExist: isTokenExist ?? this.isTokenExist,
    isUpdateAvailable: isUpdateAvailable ?? this.isUpdateAvailable,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
  );

  AuthState reset() => AuthState.initial();

  Map<String, String?> toJsonPdf() {
    return {
      "user_name": user?.fullName,
      "branch_name": user!.branch.isEmpty ? "MILAGRO" : user?.branch,
    };
  }
}
