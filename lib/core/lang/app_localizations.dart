import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'lang/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'StyleMe'**
  String get appName;

  /// No description provided for @loginPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello, your mirror just got smarter.'**
  String get loginPageTitle;

  /// No description provided for @loginPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginPageSubTitle;

  /// No description provided for @registerPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get registerPageSubTitle;

  /// No description provided for @authPageGoogleButtonText.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authPageGoogleButtonText;

  /// No description provided for @authPageInfo1.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our '**
  String get authPageInfo1;

  /// No description provided for @authPageInfo2Clickable.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get authPageInfo2Clickable;

  /// No description provided for @authPageInfo3.
  ///
  /// In en, this message translates to:
  /// **'. Find out how we handle your information in our '**
  String get authPageInfo3;

  /// No description provided for @authPageInfo4Clickable.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get authPageInfo4Clickable;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @verifyNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Verify new password'**
  String get verifyNewPassword;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get nameLabel;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @verifyPassword.
  ///
  /// In en, this message translates to:
  /// **'Verify password'**
  String get verifyPassword;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get emailInvalid;

  /// No description provided for @passwordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty.'**
  String get passwordEmpty;

  /// No description provided for @passwordWeakLength.
  ///
  /// In en, this message translates to:
  /// **'The password must have at least 6 characters.'**
  String get passwordWeakLength;

  /// No description provided for @passwordWeak.
  ///
  /// In en, this message translates to:
  /// **'At least one uppercase, lowercase and number required.'**
  String get passwordWeak;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @textFieldEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty.'**
  String get textFieldEmpty;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordMismatch;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred. please, try again later'**
  String get unknownError;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get connectionError;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get loginFailed;

  /// No description provided for @passwordWrong.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get passwordWrong;

  /// No description provided for @authEmailSentTitle.
  ///
  /// In en, this message translates to:
  /// **'We sent you an email!'**
  String get authEmailSentTitle;

  /// No description provided for @authEmailSentText.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email and then log in to start playing with your outfits'**
  String get authEmailSentText;

  /// No description provided for @authResetEmailSentText.
  ///
  /// In en, this message translates to:
  /// **'Reset your password and then log in to start playing with your outfits'**
  String get authResetEmailSentText;

  /// No description provided for @authWarningEmailSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email!'**
  String get authWarningEmailSentTitle;

  /// No description provided for @authWarningEmailSentText.
  ///
  /// In en, this message translates to:
  /// **'It looks like you didn\'t confirm your email. Confirm your email and then try to log in again.'**
  String get authWarningEmailSentText;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login page'**
  String get backToLogin;

  /// No description provided for @resendEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get any email? Check your spam or'**
  String get resendEmailLabel;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get resendEmail;

  /// No description provided for @confirmationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email has been confirmed! You can now log in.'**
  String get confirmationSuccess;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// No description provided for @tokenExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Link has expired, please try again'**
  String get tokenExpiredMessage;

  /// No description provided for @authForgotPasswordUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found, please enter a valid email'**
  String get authForgotPasswordUserNotFound;

  /// No description provided for @passwordHasBeenChanged.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed'**
  String get passwordHasBeenChanged;

  /// No description provided for @passwordHasBeenReset.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed, please log in with your new password.'**
  String get passwordHasBeenReset;

  /// No description provided for @oldPasswordNotCorrect.
  ///
  /// In en, this message translates to:
  /// **'The old password is incorrect.'**
  String get oldPasswordNotCorrect;

  /// No description provided for @usuallyOtherLoginMethod.
  ///
  /// In en, this message translates to:
  /// **'Usually you log on in a different way.'**
  String get usuallyOtherLoginMethod;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @checkroom.
  ///
  /// In en, this message translates to:
  /// **'Try-on'**
  String get checkroom;

  /// No description provided for @wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe'**
  String get wardrobe;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @loggedInAs.
  ///
  /// In en, this message translates to:
  /// **'You are logged in as:'**
  String get loggedInAs;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystemDefault;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePolish.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get languagePolish;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report bug'**
  String get reportBug;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account settings:'**
  String get accountSettings;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @followSystemTheme.
  ///
  /// In en, this message translates to:
  /// **'Follow system theme'**
  String get followSystemTheme;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get themeLight;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'Your account will be deleted and you will lose all your data. This operation cannot be undone. Enter your password to confirm the operation.'**
  String get deleteAccountWarning;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @whatsWrong.
  ///
  /// In en, this message translates to:
  /// **'What’s wrong?'**
  String get whatsWrong;

  /// No description provided for @describeProblem.
  ///
  /// In en, this message translates to:
  /// **'Describe what the problem is...'**
  String get describeProblem;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @youAreLoggedAs.
  ///
  /// In en, this message translates to:
  /// **'You are logged in as:'**
  String get youAreLoggedAs;

  /// No description provided for @onboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get onboarding;

  /// No description provided for @virtualClosetAndFittingRoom.
  ///
  /// In en, this message translates to:
  /// **'Virtual Wardrobe & Try-on'**
  String get virtualClosetAndFittingRoom;

  /// No description provided for @historyAndFavoriteOutfits.
  ///
  /// In en, this message translates to:
  /// **'History & Favorite Outfits'**
  String get historyAndFavoriteOutfits;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @otherIssues.
  ///
  /// In en, this message translates to:
  /// **'Other Issues'**
  String get otherIssues;

  /// No description provided for @reportSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for submitting your report.'**
  String get reportSuccessMessage;

  /// No description provided for @defaultText.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultText;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @positionUpper.
  ///
  /// In en, this message translates to:
  /// **'Upper'**
  String get positionUpper;

  /// No description provided for @positionBottom.
  ///
  /// In en, this message translates to:
  /// **'Bottom'**
  String get positionBottom;

  /// No description provided for @positionFull.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get positionFull;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get category;

  /// No description provided for @clothingCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get clothingCategoryAll;

  /// No description provided for @clothingCategoryBlazer.
  ///
  /// In en, this message translates to:
  /// **'Blazer'**
  String get clothingCategoryBlazer;

  /// No description provided for @clothingCategoryBlouse.
  ///
  /// In en, this message translates to:
  /// **'Blouse'**
  String get clothingCategoryBlouse;

  /// No description provided for @clothingCategoryBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get clothingCategoryBody;

  /// No description provided for @clothingCategoryDress.
  ///
  /// In en, this message translates to:
  /// **'Dress'**
  String get clothingCategoryDress;

  /// No description provided for @clothingCategoryHat.
  ///
  /// In en, this message translates to:
  /// **'Hat'**
  String get clothingCategoryHat;

  /// No description provided for @clothingCategoryHoodie.
  ///
  /// In en, this message translates to:
  /// **'Hoodie'**
  String get clothingCategoryHoodie;

  /// No description provided for @clothingCategoryLongsleeve.
  ///
  /// In en, this message translates to:
  /// **'Longsleeve'**
  String get clothingCategoryLongsleeve;

  /// No description provided for @clothingCategoryOutwear.
  ///
  /// In en, this message translates to:
  /// **'Outwear'**
  String get clothingCategoryOutwear;

  /// No description provided for @clothingCategoryPants.
  ///
  /// In en, this message translates to:
  /// **'Pants'**
  String get clothingCategoryPants;

  /// No description provided for @clothingCategoryPolo.
  ///
  /// In en, this message translates to:
  /// **'Polo'**
  String get clothingCategoryPolo;

  /// No description provided for @clothingCategoryShirt.
  ///
  /// In en, this message translates to:
  /// **'Shirt'**
  String get clothingCategoryShirt;

  /// No description provided for @clothingCategoryShoes.
  ///
  /// In en, this message translates to:
  /// **'Shoes'**
  String get clothingCategoryShoes;

  /// No description provided for @clothingCategoryShorts.
  ///
  /// In en, this message translates to:
  /// **'Shorts'**
  String get clothingCategoryShorts;

  /// No description provided for @clothingCategorySkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get clothingCategorySkip;

  /// No description provided for @clothingCategorySkirt.
  ///
  /// In en, this message translates to:
  /// **'Skirt'**
  String get clothingCategorySkirt;

  /// No description provided for @clothingCategoryTshirt.
  ///
  /// In en, this message translates to:
  /// **'T-shirt'**
  String get clothingCategoryTshirt;

  /// No description provided for @clothingCategoryTop.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get clothingCategoryTop;

  /// No description provided for @clothingCategoryUndershirt.
  ///
  /// In en, this message translates to:
  /// **'Undershirt'**
  String get clothingCategoryUndershirt;

  /// No description provided for @nothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here.'**
  String get nothingHere;

  /// No description provided for @addPhotosEncouragement.
  ///
  /// In en, this message translates to:
  /// **'Click the “+” button and add photos to fill this screen'**
  String get addPhotosEncouragement;

  /// No description provided for @nothingFound.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get nothingFound;

  /// No description provided for @nothingFoundSubText.
  ///
  /// In en, this message translates to:
  /// **'Try changing filters or click the “+” button and add photos.'**
  String get nothingFoundSubText;

  /// No description provided for @floatingAddClothingButtonText.
  ///
  /// In en, this message translates to:
  /// **'Add a picture of your clothes'**
  String get floatingAddClothingButtonText;

  /// No description provided for @floatingAddUserPhotoButtonText.
  ///
  /// In en, this message translates to:
  /// **'Add your photo'**
  String get floatingAddUserPhotoButtonText;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @noImageInClipboard.
  ///
  /// In en, this message translates to:
  /// **'Image not found in clipboard'**
  String get noImageInClipboard;

  /// No description provided for @pasteFromClipboard.
  ///
  /// In en, this message translates to:
  /// **'Paste from clipboard'**
  String get pasteFromClipboard;

  /// No description provided for @errorDialogNSFWTitle.
  ///
  /// In en, this message translates to:
  /// **'This picture can\'t be used'**
  String get errorDialogNSFWTitle;

  /// No description provided for @errorDialogNSFWDesc.
  ///
  /// In en, this message translates to:
  /// **'It looks like the image contains inappropriate content. Please choose another photo and try again.'**
  String get errorDialogNSFWDesc;

  /// No description provided for @errorDialogCantProcessTitle.
  ///
  /// In en, this message translates to:
  /// **'Something has gone wrong.'**
  String get errorDialogCantProcessTitle;

  /// No description provided for @errorDialogCantProcessDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure your clothing is fully in the photo. Not sure how to take a photo? open the help in the top right corner of the screen'**
  String get errorDialogCantProcessDesc;

  /// No description provided for @errorDialogNotAClothingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your clothes are not in the picture!'**
  String get errorDialogNotAClothingTitle;

  /// No description provided for @errorDialogNotAClothingDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure your clothing is fully visible in the frame and try again.'**
  String get errorDialogNotAClothingDesc;

  /// No description provided for @errorDialogNotAPersonTitle.
  ///
  /// In en, this message translates to:
  /// **'Looks like you\'re not in the picture'**
  String get errorDialogNotAPersonTitle;

  /// No description provided for @errorDialogNotAPersonDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure your figure is fully visible in the frame and try again.'**
  String get errorDialogNotAPersonDesc;

  /// No description provided for @recommendedLabel.
  ///
  /// In en, this message translates to:
  /// **'(Recommended)'**
  String get recommendedLabel;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @yourPhotos.
  ///
  /// In en, this message translates to:
  /// **'Your Photos'**
  String get yourPhotos;

  /// No description provided for @yourClothes.
  ///
  /// In en, this message translates to:
  /// **'Your Clothes'**
  String get yourClothes;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get save;

  /// No description provided for @deleteClothing.
  ///
  /// In en, this message translates to:
  /// **'Delete clothing'**
  String get deleteClothing;

  /// No description provided for @deletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete photo'**
  String get deletePhoto;

  /// No description provided for @clothingName.
  ///
  /// In en, this message translates to:
  /// **'Clothing name'**
  String get clothingName;

  /// No description provided for @photoName.
  ///
  /// In en, this message translates to:
  /// **'Photo name'**
  String get photoName;

  /// No description provided for @userPhotoAddPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Add photo of you'**
  String get userPhotoAddPageTitle;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get setAsDefault;

  /// No description provided for @missingPostureAndClothing.
  ///
  /// In en, this message translates to:
  /// **'It looks like you don\'t have photos of yourself and photos of your clothes. Add missing photos to access this page:'**
  String get missingPostureAndClothing;

  /// No description provided for @missingPosture.
  ///
  /// In en, this message translates to:
  /// **'Looks like you don\'t have photos of yourself. Add missing photos to access this page:'**
  String get missingPosture;

  /// No description provided for @missingClothing.
  ///
  /// In en, this message translates to:
  /// **'Looks like you don\'t have photos of your clothes. Add missing photos to access this page:'**
  String get missingClothing;

  /// No description provided for @tryOn.
  ///
  /// In en, this message translates to:
  /// **'Try it on!'**
  String get tryOn;

  /// No description provided for @makeAnother.
  ///
  /// In en, this message translates to:
  /// **'Make another'**
  String get makeAnother;

  /// No description provided for @checkroomPostGeneratedNote.
  ///
  /// In en, this message translates to:
  /// **'You can see all your tried-on outfits on the home page.'**
  String get checkroomPostGeneratedNote;

  /// No description provided for @homeHeaderGreetings.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}.'**
  String homeHeaderGreetings(Object name);

  /// No description provided for @homeHeaderSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Your mirror just got smarter.'**
  String get homeHeaderSubTitle;

  /// No description provided for @homeHeaderSeeHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'See how it works'**
  String get homeHeaderSeeHowItWorks;

  /// No description provided for @homeEmptyPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here.'**
  String get homeEmptyPageTitle;

  /// No description provided for @homeEmptyPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first outfits to fill this screen.'**
  String get homeEmptyPageSubTitle;

  /// No description provided for @homeSectionRecentOutfits.
  ///
  /// In en, this message translates to:
  /// **'Recent outfits:'**
  String get homeSectionRecentOutfits;

  /// No description provided for @homeSectionFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites:'**
  String get homeSectionFavorites;

  /// No description provided for @homeSectionSeeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get homeSectionSeeMore;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @galTypeAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'We don\'t have permission to access the gallery.'**
  String get galTypeAccessDenied;

  /// No description provided for @galTypeNotEnoughSpace.
  ///
  /// In en, this message translates to:
  /// **'There is not enough storage space available.'**
  String get galTypeNotEnoughSpace;

  /// No description provided for @galTypeNotSupportedFormat.
  ///
  /// In en, this message translates to:
  /// **'The selected file format is not supported.'**
  String get galTypeNotSupportedFormat;

  /// No description provided for @galTypeUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get galTypeUnexpected;

  /// No description provided for @downloadImageSuccess.
  ///
  /// In en, this message translates to:
  /// **'The photo was downloaded successfully.'**
  String get downloadImageSuccess;

  /// No description provided for @downloadingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloadingInProgress;

  /// No description provided for @downloadNoPermissionsButtonText.
  ///
  /// In en, this message translates to:
  /// **'Manage permissions'**
  String get downloadNoPermissionsButtonText;

  /// No description provided for @photoFetcherNoCameraPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No camera permissions.'**
  String get photoFetcherNoCameraPermissionsTitle;

  /// No description provided for @photoFetcherNoCameraPermissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open app settings > permissions and allow camera use.'**
  String get photoFetcherNoCameraPermissionsSubtitle;

  /// No description provided for @photoFetcherNoCameraPermissionsGoToSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to settings'**
  String get photoFetcherNoCameraPermissionsGoToSettings;

  /// No description provided for @onboardingStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}, let’s begin!'**
  String onboardingStep1Title(String name);

  /// No description provided for @onboardingStep1SubTitle.
  ///
  /// In en, this message translates to:
  /// **'Click this button to see what you can add!'**
  String get onboardingStep1SubTitle;

  /// No description provided for @onboardingStep1SubTitle2.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start by adding a picture of some clothes.'**
  String get onboardingStep1SubTitle2;

  /// No description provided for @onboardingStep2Text1.
  ///
  /// In en, this message translates to:
  /// **'You can add a photo of clothing by taking it yourself...'**
  String get onboardingStep2Text1;

  /// No description provided for @onboardingStep2Text2.
  ///
  /// In en, this message translates to:
  /// **'or by selecting from the gallery...'**
  String get onboardingStep2Text2;

  /// No description provided for @onboardingStep2Text3.
  ///
  /// In en, this message translates to:
  /// **'or by pasting from the clipboard if the photo is there.'**
  String get onboardingStep2Text3;

  /// No description provided for @onboardingStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Well done {name}!'**
  String onboardingStep3Title(String name);

  /// No description provided for @onboardingStep3SubTitle.
  ///
  /// In en, this message translates to:
  /// **'Now it\'s time to add your photo, remember to include your whole figure in the picture.'**
  String get onboardingStep3SubTitle;

  /// No description provided for @onboardingStep4Title.
  ///
  /// In en, this message translates to:
  /// **'All set!'**
  String get onboardingStep4Title;

  /// No description provided for @onboardingStep4SubTitle.
  ///
  /// In en, this message translates to:
  /// **'Now let\'s see how it will look on you (tap to continue).'**
  String get onboardingStep4SubTitle;

  /// No description provided for @onboardingStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You look great!'**
  String get onboardingStep5Title;

  /// No description provided for @onboardingStep5SubTitle.
  ///
  /// In en, this message translates to:
  /// **'As you add more of your photos you will be able to swipe to the left to see your outfit in different photos. Discover the rest for yourself and most importantly.... have fun!'**
  String get onboardingStep5SubTitle;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip tutorial'**
  String get onboardingSkip;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Tap to continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Tap to finish tutorial'**
  String get onboardingFinish;

  /// No description provided for @onboardingExitDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get onboardingExitDialogTitle;

  /// No description provided for @onboardingExitDialogSubTitle.
  ///
  /// In en, this message translates to:
  /// **'This action will end the tutorial. You can always start it from the beginning on the home page'**
  String get onboardingExitDialogSubTitle;

  /// No description provided for @onboardingExitDialogEndText.
  ///
  /// In en, this message translates to:
  /// **'End tutorial'**
  String get onboardingExitDialogEndText;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
