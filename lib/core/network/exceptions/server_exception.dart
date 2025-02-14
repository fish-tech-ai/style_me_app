class ServerException implements Exception {
  final int? statusCode;
  final String? message;

  ServerException(this.message, [this.statusCode]);

  @override
  String toString() {
    return message ?? "Message not provided";
  }
}
