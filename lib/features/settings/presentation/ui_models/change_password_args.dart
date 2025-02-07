class ChangePasswordArgs {
  final String token;
  final bool isResettingPass;

  ChangePasswordArgs(
    this.token,
    this.isResettingPass,
  );
}
