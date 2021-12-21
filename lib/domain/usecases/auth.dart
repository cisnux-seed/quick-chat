import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_chat/utils/failures.dart';

class Auth {
  Auth({required this.firebaseAuth, required this.googleAuth});

  final GoogleSignIn googleAuth;
  final FirebaseAuth firebaseAuth;

  Future<Either<Failure, String>> signIn(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const Right('success');
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        return const Left(
          AuthFailure('Your email not found\nPlease enter correct email'),
        );
      } else {
        return Left(
          AuthFailure(error.message!),
        );
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  Future<Either<Failure, String>> createAccount(
    String email,
    String password,
  ) async {
    final fetchSignInMethods =
        await firebaseAuth.fetchSignInMethodsForEmail(email);

    try {
      if (!fetchSignInMethods.contains('google.com') &&
          !fetchSignInMethods.contains('password')) {
        await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return const Right('success');
      } else {
        return const Left(AuthFailure('Your email is already registered'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message!));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  Future<Either<Failure, String>> signOut() async {
    try {
      final fetchSignInMethods = await firebaseAuth
          .fetchSignInMethodsForEmail(firebaseAuth.currentUser!.email!);
      if (fetchSignInMethods.contains('google.com')) {
        await googleAuth.signOut();
        await firebaseAuth.signOut();
        return const Right('success');
      } else {
        await firebaseAuth.signOut();
        return const Right('success');
      }
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message!));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  Future<Either<Failure, String>> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right('Your password has been successfully changed');
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        return const Left(
          AuthFailure('Your email not found\nPlease enter correct email'),
        );
      } else {
        return Left(
          AuthFailure(error.message!),
        );
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  Future<Either<Failure, String>> googleSignIn() async {
    try {
      final googleUser = await googleAuth.signIn();
      if (googleUser != null) {
        final fetchSignInMethods =
            await firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);

        if (!fetchSignInMethods.contains('password')) {
          final googleAuth = await googleUser.authentication;

          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await firebaseAuth.signInWithCredential(credential);
          return const Right('success');
        } else {
          return const Left(
            AuthFailure(
              'Your email is already registered\ntry to login or use another account',
            ),
          );
        }
      } else {
        return const Left(AuthFailure('cancel'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    } catch (e) {
      await googleAuth.signOut();
      return Left(AuthFailure(e.toString()));
    }
  }

  Either<Failure, User?> currentUser() {
    try {
      return Right(firebaseAuth.currentUser);
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
