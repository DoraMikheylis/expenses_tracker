// login exceptions

class InvalidCredentialsAuthException implements Exception {}

class EmptyCredentialsAuthException implements Exception {}

class SocialMediaAuthException implements Exception {}

// register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
