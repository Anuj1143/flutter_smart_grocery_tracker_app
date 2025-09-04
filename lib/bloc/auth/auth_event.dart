import 'package:equatable/equatable.dart';
import 'package:smart_grocery_tracker/models/user_models.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStateChanged extends AuthEvent {
  final UserModels? user;
  const AuthStateChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String role;

  const RegisterRequested({
    required this.email,
    required this.fullName,
    required this.password,
    required this.role,
  });

  @override
  List<Object> get props => [email, fullName, password, role];
}

class LoginRequest extends AuthEvent {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class ForgetPasswordRequested extends AuthEvent {
  final String email;

  const ForgetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class UpdateProfileRequested extends AuthEvent {
  final String? fullName;
  final String? photoUrl;

  const UpdateProfileRequested({this.fullName, this.photoUrl});

  @override
  List<Object?> get props => [fullName, photoUrl];
}

class AddFamilyMemberRequested extends AuthEvent {
  final FamilyMember? familyMember;

  const AddFamilyMemberRequested({required this.familyMember});

  @override
  List<Object?> get props => [familyMember];
}

class UpdateFamilyMemberRequested extends AuthEvent {
  final String memberId;
  final String? name;
  final String? relation;
  final String? photoUrl;

  const UpdateFamilyMemberRequested({
    required this.memberId,
    this.name,
    this.relation,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [memberId, name, relation, photoUrl];
}

class RemoveFamilyMemberRequested extends AuthEvent {
  final String memberId;

  const RemoveFamilyMemberRequested({required this.memberId});

  @override
  List<Object> get props => [memberId];
}

class ToggleFamilyMemberStatusRequested extends AuthEvent {
  final String memberId;

  const ToggleFamilyMemberStatusRequested({required this.memberId});

  @override
  List<Object> get props => [memberId];
}

class ClearAuthError extends AuthEvent {
  const ClearAuthError();
}

class RefreshUserData extends AuthEvent {
  const RefreshUserData();
}
