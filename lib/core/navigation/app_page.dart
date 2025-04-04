/// The application is designed to use a path as an identifier. Do not use parameters in paths. Instead, use extra.
enum AppPage {
  authPage("/", shouldShowBottomNavBar: false),
  homePage("/home"),
  settings("/settings"),
  wardrobe("/wardrobe"),
  checkroom("/checkroom"),
  changePasswordPage("/changePassword"),
  privacyPolicy("/privacyPolicy"),
  clothingAdd("/clothingAdd", shouldShowBottomNavBar: false),
  termsAndConditions("/termsAndConditions"),
  editClothingPage("/editClothingPage"),
  userPhotoAdd("/userPhotoAdd", shouldShowBottomNavBar: false),
  editUserPhotoPage("/editUserPhotoPage");

  final String path;
  final bool shouldShowBottomNavBar;

  const AppPage(this.path, {this.shouldShowBottomNavBar = true});

  factory AppPage.getFrom({required String path}) {
    return AppPage.values
        .firstWhere((appPage) => appPage.path.startsWith(path));
  }
}
