import 'package:equatable/equatable.dart';
import 'package:smart_grocery_tracker/models/user_models.dart';

class AuthState extends Equatable {
  final UserModels? userModels;
  final bool isLoading;
  final String? error;
  const AuthState({this.userModels, this.isLoading = false, this.error});
  AuthState copyWith({UserModels? userModels, bool? isLoading, String? error}) {
    return AuthState(
      userModels: userModels ?? this.userModels,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [userModels, isLoading, error];
}
