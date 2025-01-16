enum EmailStateEnum {
  registeredAndConfirmed(200),
  notConfirmed(401),
  notFound(404);

  final int code;

  const EmailStateEnum(this.code);
}
