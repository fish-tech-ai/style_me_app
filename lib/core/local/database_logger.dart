import 'dart:async';
import 'package:drift/drift.dart';

class DatabaseLogger extends QueryInterceptor {
  Future<T> _run<T>(String operationType, String tableName, dynamic args,
      FutureOr<T> Function() operation) async {
    try {
      final result = await operation();
      print(_formatLog(
        operationType: operationType,
        tableName: tableName,
        args: args,
        success: true,
        result: result,
      ));
      return result;
    } on Object catch (e) {
      print(_formatLog(
        operationType: operationType,
        tableName: tableName,
        args: args,
        success: false,
        error: e,
      ));
      rethrow;
    }
  }

  String _formatLog({
    required String operationType,
    required String tableName,
    required dynamic args,
    required bool success,
    dynamic result,
    Object? error,
  }) {
    final purple = '\x1B[35m';
    final reset = '\x1B[0m';
    final status = success ? 'SUCCESS' : 'FAILED';
    final errorStr = error != null ? '\\nError: $error' : '';

    return '''$purple=================================> DATABASE OPERATION <=================================
Operation: $operationType
Table: $tableName
Args: $args
Status: $status $errorStr
========================================================================================$reset''';
  }

  String _extractTableName(String statement) {
    final regex = RegExp(
        r'\b(?:FROM|INTO|UPDATE|DELETE\s+FROM)\s+"?([a-zA-Z_][a-zA-Z0-9_]*)"?',
        caseSensitive: false);
    final match = regex.firstMatch(statement);
    return match?.group(1) ?? 'Unknown';
  }

  @override
  Future<int> runInsert(
      QueryExecutor executor, String statement, List<Object?> args) {
    final tableName = _extractTableName(statement);
    return _run(
        'INSERT', tableName, args, () => executor.runInsert(statement, args));
  }

  @override
  Future<int> runUpdate(
      QueryExecutor executor, String statement, List<Object?> args) {
    final tableName = _extractTableName(statement);
    return _run(
        'UPDATE', tableName, args, () => executor.runUpdate(statement, args));
  }

  @override
  Future<int> runDelete(
      QueryExecutor executor, String statement, List<Object?> args) {
    final tableName = _extractTableName(statement);
    return _run(
        'DELETE', tableName, args, () => executor.runDelete(statement, args));
  }

  @override
  Future<List<Map<String, Object?>>> runSelect(
      QueryExecutor executor, String statement, List<Object?> args) {
    final tableName = _extractTableName(statement);
    return _run(
        'SELECT', tableName, args, () => executor.runSelect(statement, args));
  }
}
