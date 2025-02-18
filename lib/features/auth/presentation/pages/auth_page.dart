import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/core/utils/show_enum.dart';
import 'package:style_me/core/views/animators/animated_transistor.dart';
import 'package:style_me/core/views/buttons/app_back_button.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';
import 'package:style_me/features/auth/presentation/components/auth_email_confirmation.dart';
import 'package:style_me/features/auth/presentation/components/auth_form.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';
import 'package:style_me/features/auth/presentation/state/auth_view_model.dart';
import 'package:style_me/features/auth/presentation/ui_models/auth_page_mode_enum.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  late final AuthViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(authViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initFormValidators(context.localizations);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthStateHolder state = ref.watch(authViewModelProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.ensureEmailVisible();
    });
    return PopScope(
      canPop: state.mode == AuthPageModeEnum.emailOnly,
      onPopInvokedWithResult: (_, __) {
        viewModel.changePageMode(AuthPageModeEnum.emailOnly);
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/auth_page_background.png"),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.only(
                left: GlobalUiConst.paddingNormal,
                right: GlobalUiConst.paddingNormal,
                top: 24),
            color: context.colorScheme.primaryContainer,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height:
                          state.mode == AuthPageModeEnum.emailOnly ? 72 : 24),
                  AppBackButton(onTap: () {
                    viewModel.changePageMode(AuthPageModeEnum.emailOnly);
                  }).orEmpty(state.mode == AuthPageModeEnum.emailOnly),
                  SizedBox(height: GlobalUiConst.paddingNormal),
                  Text(
                    context.localizations.loginPageTitle,
                    style: TextStyle(
                        color: context.colorScheme.onSurface,
                        fontSize: 36,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: GlobalUiConst.paddingLarge),
                  AnimatedTransistor(
                    firstChild: _buildAuthContent(context, state),
                    secondChild: _buildPaddedContainer(
                      key: ValueKey(2),
                      child: AuthEmailConfirmation(
                        asResetPassword:
                            state.showConfirmationPageForPasswordReset,
                        asWarning: state.showConfirmationPageAsWarning,
                        onBackToLoginClicked: () {
                          viewModel.changePageMode(AuthPageModeEnum.emailOnly);
                        },
                        onResendClicked: () {
                          viewModel.resendEmail();
                        },
                      ),
                    ),
                    show: state.mode == AuthPageModeEnum.confirmation
                        ? Show.second
                        : Show.first,
                  ),
                  SizedBox(height: GlobalUiConst.paddingNormal),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaddedContainer({required Widget child, required Key key}) {
    return Container(
      key: key,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: GlobalUiConst.paddingNormal,
          vertical: GlobalUiConst.paddingLarge),
      decoration: BoxDecoration(
          color: context.customColors.backgroundA85,
          borderRadius: GlobalUiConst.borderRadiusExtraLarge),
      child: child,
    );
  }

  Widget _buildAuthContent(BuildContext context, AuthStateHolder state) {
    return _buildPaddedContainer(
      key: ValueKey(1),
      child: Column(
        spacing: 18,
        children: [
          Text(
            state.mode == AuthPageModeEnum.registration
                ? context.localizations.registerPageSubTitle
                : context.localizations.loginPageSubTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          AuthForm(viewModel: viewModel, state: state),
          AppOutlinedButton(
            text: context.localizations.authPageGoogleButtonText,
            leadingIcon: SvgPicture.asset("assets/google_logo.svg"),
            spacing: 10,
            style: OutlinedButton.styleFrom(
                backgroundColor: Color(0xFF131314),
                side: BorderSide(
                    color: context.theme.colorScheme.onSurface, width: 1),
                foregroundColor: context.theme.colorScheme.onSurface),
            onClick: () {
              viewModel
                  .signInWithGoogle(() => context.go(AppPage.homePage.path));
            },
          ),
          _buildTermsAndPrivacyInfoText(context)
        ],
      ),
    );
  }

  Widget _buildTermsAndPrivacyInfoText(BuildContext context) {
    final clickableTextStyle = TextStyle(color: context.colorScheme.primary);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: GlobalUiConst.paddingNormal),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: context.colorScheme.onSecondary),
          children: [
            TextSpan(text: context.localizations.authPageInfo1),
            TextSpan(
                text: context.localizations.authPageInfo2Clickable,
                style: clickableTextStyle),
            TextSpan(text: context.localizations.authPageInfo3),
            TextSpan(
                text: context.localizations.authPageInfo4Clickable,
                style: clickableTextStyle),
          ],
        ),
      ),
    );
  }
}
