import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSignInWithEmail extends AuthEvent {
  final String email;
  final String password;
  const AuthEventSignInWithEmail({required this.email, required this.password});
}

class AuthEventSignInWithGoogle extends AuthEvent {}

class AuthEventSignOut extends AuthEvent {
  const AuthEventSignOut();
}

// class AuthEventSendEmailVerification extends AuthEvent {
//   const AuthEventSendEmailVerification();
// }

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEventRegister({required this.email, required this.password});
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventShouldSignIn extends AuthEvent {
  const AuthEventShouldSignIn();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}
