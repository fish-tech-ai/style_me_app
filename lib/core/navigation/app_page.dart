/// The application is designed to use a path as an identifier. Do not use parameters in paths. Instead, use extra.
enum AppPage {
  authPage("/", shouldShowBottomNavBar: false),
  homePage("/home"),
  settings("/settings"),
  wardrobe("/wardrobe"),
  checkroom("/checkroom"),
  changePasswordPage("/changePassword"),
  privacyPolicy("/privacyPolicy"),
  clothingAdd("/clothingAdd"),
  termsAndConditions("/termsAndConditions"),
  editClothingPage("/editClothingPage"),
  userPhotoAdd("/userPhotoAdd"),
  editUserPhotoPage("/editUserPhotoPage");


  final String path;
  final bool shouldShowBottomNavBar;

  const AppPage(this.path, {this.shouldShowBottomNavBar = true});
}
