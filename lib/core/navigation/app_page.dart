/// The application is designed to use a path as an identifier. Do not use parameters in paths. Instead, use extra.
enum AppPage {
  authPage("/", shouldShowBottomNavBar: false),
  homePage("/home", bottomNavIndex: 0),
  checkroom("/checkroom", bottomNavIndex: 1),
  wardrobe("/wardrobe", bottomNavIndex: 2),
  settings("/settings", bottomNavIndex: 3),
  changePasswordPage("/changePassword"),
  privacyPolicy("/privacyPolicy"),
  clothingAdd("/clothingAdd", shouldShowBottomNavBar: false),
  termsAndConditions("/termsAndConditions", shouldShowBottomNavBar: false),
  editClothingPage("/editClothingPage"),
  userPhotoAdd("/userPhotoAdd", shouldShowBottomNavBar: false),
  editUserPhotoPage("/editUserPhotoPage"),
  homeGridList("/homeGridList"),
  homeOutfitDetails("/homeItemDetails");

  final String path;
  final bool shouldShowBottomNavBar;
  final int? bottomNavIndex;

  const AppPage(
    this.path, {
    this.shouldShowBottomNavBar = true,
    this.bottomNavIndex,
  });

  factory AppPage.getFrom({required String path}) {
    return AppPage.values
        .firstWhere((appPage) => appPage.path.startsWith(path));
  }
}
