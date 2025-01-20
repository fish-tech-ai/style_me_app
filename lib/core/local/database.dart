import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:style_me/core/local/database_logger.dart';
import 'package:style_me/core/local/tables/user.dart';

part 'database.g.dart';

@DriftDatabase(tables: [User])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'style_me_database',
    ).interceptWith(DatabaseLogger());
  }

  Future<UserData?> getUser() {
    return managers.user.getSingleOrNull();
  }

  Future setUser(UserCompanion user) {
    managers.user.delete();
    return managers.user.create((Function _) => user);
  }
}
