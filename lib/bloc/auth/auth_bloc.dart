import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery_tracker/bloc/auth/auth_event.dart';
import 'package:smart_grocery_tracker/bloc/auth/auth_state.dart';
import 'package:smart_grocery_tracker/models/user_models.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(const AuthState()) {
    /// 🔹 Listen to FirebaseAuth changes
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        add(const AuthStateChanged(null));
      } else {
        try {
          final userDoc = await _firestore
              .collection("users")
              .doc(firebaseUser.uid)
              .get();
          if (userDoc.exists && userDoc.data() != null) {
            final userModel = UserModels.fromJson(userDoc.data()!);
            // Update last login time
            await _updateLastLoginTime(userModel.uid);
            add(AuthStateChanged(userModel));
          } else {
            add(const AuthStateChanged(null));
          }
        } catch (e) {
          print('Error fetching user data: $e');
          add(const AuthStateChanged(null));
        }
      }
    });

    /// 🔹 Auth State Changed
    on<AuthStateChanged>((event, emit) {
      emit(state.copyWith(userModels: event.user, error: null));
    });

    /// 🔹 Register
    on<RegisterRequested>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        final now = DateTime.now();
        final newUser = UserModels(
          uid: credential.user!.uid,
          email: event.email,
          fullName: event.fullName,
          role: event.role,
          familyMembers: [],
          photoUrl: null,
          createdAt: now,
          lastLoginAt: now,
        );

        await _firestore
            .collection("users")
            .doc(newUser.uid)
            .set(newUser.toJson());

        emit(state.copyWith(isLoading: false, userModels: newUser));
      } on FirebaseAuthException catch (e) {
        String errorMessage = _getAuthErrorMessage(e);
        emit(state.copyWith(isLoading: false, error: errorMessage));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: "Registration failed: ${e.toString()}",
          ),
        );
      }
    });

    /// 🔹 Login
    on<LoginRequest>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final credential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        final userDoc = await _firestore
            .collection("users")
            .doc(credential.user!.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final userModel = UserModels.fromJson(userDoc.data()!);
          // Update last login time
          final updatedUser = userModel.copyWith(lastLoginAt: DateTime.now());
          await _firestore.collection("users").doc(updatedUser.uid).update({
            'lastLoginAt': updatedUser.lastLoginAt.toIso8601String(),
          });

          emit(state.copyWith(isLoading: false, userModels: updatedUser));
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              error: "User profile not found. Please contact support.",
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = _getAuthErrorMessage(e);
        emit(state.copyWith(isLoading: false, error: errorMessage));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: "Login failed: ${e.toString()}",
          ),
        );
      }
    });

    /// 🔹 Logout
    on<LogoutRequested>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        await _auth.signOut();
        emit(const AuthState(userModels: null, isLoading: false));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: "Logout failed: ${e.toString()}",
          ),
        );
      }
    });

    /// 🔹 Forgot Password
    on<ForgetPasswordRequested>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        await _auth.sendPasswordResetEmail(email: event.email);
        emit(state.copyWith(isLoading: false, error: null));
        // You might want to add a success message state
      } on FirebaseAuthException catch (e) {
        String errorMessage = _getAuthErrorMessage(e);
        emit(state.copyWith(isLoading: false, error: errorMessage));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: "Failed to send reset email: ${e.toString()}",
          ),
        );
      }
    });

    /// 🔹 Update Profile
    on<UpdateProfileRequested>((event, emit) async {
      final currentUser = state.userModels;
      if (currentUser == null) {
        emit(state.copyWith(error: "No user logged in"));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final updatedUser = currentUser.copyWith(
          fullName: event.fullName ?? currentUser.fullName,
          photoUrl: event.photoUrl ?? currentUser.photoUrl,
        );

        await _firestore.collection("users").doc(updatedUser.uid).update({
          'fullName': updatedUser.fullName,
          'photoUrl': updatedUser.photoUrl,
        });

        emit(state.copyWith(isLoading: false, userModels: updatedUser));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: "Failed to update profile: ${e.toString()}",
          ),
        );
      }
    });

    /// 🔹 Add Family Member
    on<AddFamilyMemberRequested>((event, emit) async {
      final currentUser = state.userModels;
      if (currentUser == null || event.familyMember == null) {
        emit(state.copyWith(error: "Invalid request"));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));
      try {
        // Check if family member with same name already exists
        final existingMember = currentUser.familyMembers
            .where(
              (member) =>
                  member.name.toLowerCase() ==
                  event.familyMember!.name.toLowerCase(),
            )
            .isNotEmpty;

        if (existingMember) {
          emit(
            state.copyWith(
              isLoading: false,
              error: "Family member with this name already exists",
            ),
          );
          return;
        }

        final updatedFamily = List<FamilyMember>.from(currentUser.familyMembers)
          ..add(event.familyMember!);

        final updatedUser = currentUser.copyWith(familyMembers: updatedFamily);

        await _firestore.collection("users").doc(updatedUser.uid).update({
          'familyMembers': updatedUser.familyMembers
              .map((member) => member.toJson())
              .toList(),
        });

        emit(state.copyWith(isLoading: false, userModels: updatedUser));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: "Failed to add family member: ${e.toString()}",
          ),
        );
      }
    });

    /// 🔹 Update Family Member
    on<UpdateFamilyMemberRequested>((event, emit) async {
      final currentUser = state.userModels;
      if (currentUser == null) {
        emit(state.copyWith(error: "No user logged in"));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final updatedFamily = currentUser.familyMembers.map((member) {
          if (member.id == event.memberId) {
            return member.copyWith(
              name: event.name ?? member.name,
              relation: event.relation ?? member.relation,
              photoUrl: event.photoUrl ?? member.photoUrl,
            );
          }
          return member;
        }).toList();

        final updatedUser = currentUser.copyWith(familyMembers: updatedFamily);

        await _firestore.collection("users").doc(updatedUser.uid).update({
          'familyMembers': updatedUser.familyMembers
              .map((member) => member.toJson())
              .toList(),
        });

        emit(state.copyWith(isLoading: false, userModels: updatedUser));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: "Failed to update family member: ${e.toString()}",
          ),
        );
      }
    });

    /// 🔹 Remove Family Member
    on<RemoveFamilyMemberRequested>((event, emit) async {
      final currentUser = state.userModels;
      if (currentUser == null) {
        emit(state.copyWith(error: "No user logged in"));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final updatedFamily = currentUser.familyMembers
            .where((member) => member.id != event.memberId)
            .toList();

        final updatedUser = currentUser.copyWith(familyMembers: updatedFamily);

        await _firestore.collection("users").doc(updatedUser.uid).update({
          'familyMembers': updatedUser.familyMembers
              .map((member) => member.toJson())
              .toList(),
        });

        emit(state.copyWith(isLoading: false, userModels: updatedUser));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: "Failed to remove family member: ${e.toString()}",
          ),
        );
      }
    });

    /// 🔹 Toggle Family Member Status
    on<ToggleFamilyMemberStatusRequested>((event, emit) async {
      final currentUser = state.userModels;
      if (currentUser == null) return;

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final updatedFamily = currentUser.familyMembers.map((member) {
          if (member.id == event.memberId) {
            return member.copyWith(isActive: !member.isActive);
          }
          return member;
        }).toList();

        final updatedUser = currentUser.copyWith(familyMembers: updatedFamily);

        await _firestore.collection("users").doc(updatedUser.uid).update({
          'familyMembers': updatedUser.familyMembers
              .map((member) => member.toJson())
              .toList(),
        });

        emit(state.copyWith(isLoading: false, userModels: updatedUser));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: "Failed to update family member status: ${e.toString()}",
          ),
        );
      }
    });
  }

  // Helper method to update last login time
  Future<void> _updateLastLoginTime(String userId) async {
    try {
      await _firestore.collection("users").doc(userId).update({
        'lastLoginAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating last login time: $e');
    }
  }

  // Helper method to get user-friendly error messages
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed: ${e.message ?? 'Unknown error'}';
    }
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart_grocery_tracker/bloc/auth/auth_event.dart';
// import 'package:smart_grocery_tracker/bloc/auth/auth_state.dart';

// class AuthBloc extends Bloc<AuthState, AuthEvent> {
//   AuthBloc() : super(const AuthState()) {
//     on<AuthStateChanged>((event, emit) {
//       emit(state.copyWith(UserModels: event.user));
//     });

//     on<RegisterRequested>((event, emit) async {
//       emit(state.copyWith(isLoading: true));

//       try {
//         emit(state.copyWith(isLoading: false));
//       } catch (e) {
//         emit(state.copyWith(isLoading: false, error: e.toString()));
//       }
//     });
//     on<LoginRequest>((event, emit) async {
//       emit(state.copyWith(isLoadting: true));
//       try {
//         emit(state.copyWith(issLoading: false));
//       } catch (e) {
//         emit(state.copyWith(isLoading: false, error: e.toString()));
//       }
//     });
//     on<LogoutRequested>((event, emit) async {
//       emit(const AuthState(userModels: null));
//     });
//     on<ForgetPasswordRequested>((event, emit)async{
//       emit(const AuthState())
//     })
//   }
// }
