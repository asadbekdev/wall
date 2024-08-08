part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignInWithGoogle extends AuthEvent {}

class SignOut extends AuthEvent {}
