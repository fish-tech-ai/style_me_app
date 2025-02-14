enum AppPage {
  authPage("/"),
  homePage("/home"),
  changePasswordPage("/resetPassword");


  final String path;

  const AppPage(this.path);
}