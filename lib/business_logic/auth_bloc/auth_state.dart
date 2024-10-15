import 'package:equatable/equatable.dart';
import 'package:expenses_tracker/business_logic/auth_services/auth_user.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateLoading extends AuthState {}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception});
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
  });
}

class AuthStateSignedIn extends AuthState {
  final AuthUser user;
  const AuthStateSignedIn({required this.user});
}

// class AuthStateNeedsVerification extends AuthState {
//   const AuthStateNeedsVerification({required super.isLoading});
// }

class AuthStateSignedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateSignedOut({required this.exception});

  @override
  List<Object?> get props => [exception];
}
