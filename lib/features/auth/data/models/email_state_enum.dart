enum EmailStateEnum {
  registeredAndConfirmed(200),
  notConfirmed(401),
  loggedWithGoogle(405),
  notFound(404);

  final int code;

  const EmailStateEnum(this.code);
}
