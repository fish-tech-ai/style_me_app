import 'package:drift/drift.dart';

class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get token => text()();
  TextColumn get refreshToken => text()();
  BoolColumn get isFromGoogleSignIn => boolean()();
}