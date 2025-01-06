import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';
import 'package:style_me/features/auth/presentation/state/auth_view_model.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthStateHolder state = ref.watch(authViewModelProvider);
    final AuthViewModel viewModel = ref.read(authViewModelProvider.notifier);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/auth_page_background.png"),
          ),
        ),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: context.colorScheme.primaryContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text(
                context.localizations.loginPageTitle,
                style: TextStyle(fontSize: 36),
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                decoration: BoxDecoration(
                    color: context.customColors.backgroundA85,
                    borderRadius: BorderRadius.circular(12)),
                child: _buildAuthContent(context, viewModel, state),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthContent(
      BuildContext context, AuthViewModel viewModel, AuthStateHolder state) {
    return Column(
      spacing: 18,
      children: [
        Text(context.localizations.loginPageSubTitle),
        _buildAuthForm(context, viewModel, state),
        ElevatedButton(
            onPressed: () {},
            child: Row(
              children: [
                Text(context.localizations.continueText)
              ],
            ))
      ],
    );
  }

  Widget _buildAuthForm(
      BuildContext context, AuthViewModel viewModel, AuthStateHolder state) {
    return Column();
  }
}
