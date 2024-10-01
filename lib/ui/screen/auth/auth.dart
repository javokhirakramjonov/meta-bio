import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/ui/component/loading_view.dart';
import 'package:meta_bio/ui/component/snackbar.dart';
import 'package:meta_bio/ui/screen/auth/bloc/auth_bloc.dart';
import 'package:meta_bio/ui/screen/dashboard/dashboard.dart';
import 'package:meta_bio/ui/theme/my_theme.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(GetIt.I.get(), context),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            _handleLoginRequestState(context, state);
          },
          builder: (context, state) {
            return Stack(
              children: [
                _buildBackgroundContainer(),
                _buildBackground(context),
                _buildContent(context, state),
                _handleLoadingState(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleLoginRequestState(BuildContext context, AuthState state) {
    final loginRequestState = state.loginRequestState;

    if (loginRequestState is RequestStateSuccess) {
      showSuccessSnackBar(context, 'Successfully logged in');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }
  }

  Widget _buildBackgroundContainer() {
    return Container(
      color: const Color(0xFF171717),
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var diameter = screenWidth * 2;

    return Positioned(
      top: -screenWidth * 2 / 3,
      left: -screenWidth / 2,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, secondary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AuthState state) {
    return Column(
      children: [
        const SizedBox(height: 100),
        _buildTitle(),
        const SizedBox(height: 36),
        _buildLoginCard(context, state),
      ],
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Welcome to\nMeta Bio',
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginCard(BuildContext context, AuthState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: const Color(0xFF0D0D0D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            _buildLoginTitle(),
            const SizedBox(height: 24),
            _buildPhoneNumberField(context),
            const SizedBox(height: 20),
            _buildPasswordField(context, state),
            const SizedBox(height: 36),
            _buildLoginButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginTitle() {
    return const Text(
      'Login',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPhoneNumberField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: (value) {
          context
              .read<AuthBloc>()
              .add(AuthEvent.phoneNumberChanged(newPhoneNumber: value));
        },
        decoration: const InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          prefixIcon: Icon(Icons.phone),
        ),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context, AuthState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: (value) {
          context
              .read<AuthBloc>()
              .add(AuthEvent.passwordChanged(newPassword: value));
        },
        obscureText: !state.isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(state.isPasswordVisible
                ? Icons.visibility_off
                : Icons.visibility),
            onPressed: () {
              context.read<AuthBloc>().add(AuthEvent.toggledPasswordVisibility(
                  isPasswordVisible: !state.isPasswordVisible));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FilledButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          onPressed: () {
            context.read<AuthBloc>().add(const AuthEvent.loginClicked());
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Text('Login'),
          ),
        ),
      ),
    );
  }

  Widget _handleLoadingState(BuildContext context, AuthState state) {
    return state.loginRequestState is RequestStateLoading
        ? loadingView(context)
        : const SizedBox.shrink();
  }
}
