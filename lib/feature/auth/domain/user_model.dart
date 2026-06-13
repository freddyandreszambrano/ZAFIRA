import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    @JsonKey(name: 'full_name') @Default('') String fullName,
    @JsonKey(name: 'token_notification') @Default('') String tokenNotification,
    @Default(0) int id,
    @Default('') String dni,
    @Default('') String branch,
    @JsonKey(name: 'branch_id') @Default(0) int branchId,
    @Default('') String mobile,
    @JsonKey(name: 'first_name') @Default('') String firstName,
    @JsonKey(name: 'last_name') @Default('') String lastName,
    @Default('') String email,
    @Default(false) bool state,
    @Default('') String image,
    @JsonKey(name: 'can_view_client_data')
    @Default(false)
    bool canViewClientData,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  String get fullInitialName => '${firstName[0]}${lastName[0]}'.toUpperCase();
}
