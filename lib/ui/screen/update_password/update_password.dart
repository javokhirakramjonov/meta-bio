import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/ui/component/loading_view.dart';
import 'package:meta_bio/ui/screen/update_password/bloc/update_password_bloc.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKeyOldPassword = GlobalKey<FormState>();
  final _formKeyNewPassword = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdatePasswordBloc(GetIt.I.get(), GetIt.I.get()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          title: const Text('Update Password'),
        ),
        body: BlocConsumer<UpdatePasswordBloc, UpdatePasswordState>(
          listener: (context, state) {
            if (state.isOldPasswordValid && _pageController.page == 0) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }

            if (state.updatePasswordRequestState is RequestStateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password updated successfully'),
                ),
              );

              Navigator.pop(context);
            } else if (state.updatePasswordRequestState is RequestStateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to update password'),
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(children: [
              PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildOldPasswordPage(context, state),
                  _buildNewPasswordPage(context, state),
                ],
              ),
              state.updatePasswordRequestState is RequestStateLoading
                  ? loadingView(context)
                  : const SizedBox.shrink(),
            ]);
          },
        ),
      ),
    );
  }

  Widget _buildOldPasswordPage(
      BuildContext context, UpdatePasswordState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formKeyOldPassword,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _oldPasswordController,
              obscureText: !state.isOldPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Old Password',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(state.isOldPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    context.read<UpdatePasswordBloc>().add(
                        UpdatePasswordEvent.toggleOldPasswordVisibility(
                            !state.isOldPasswordVisible));
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Old Password cannot be empty';
                }

                context
                    .read<UpdatePasswordBloc>()
                    .add(const UpdatePasswordEvent.validateOldPassword());

                if (!state.isOldPasswordValid) {
                  return 'Incorrect old password';
                }

                return null;
              },
              onChanged: (value) {
                context
                    .read<UpdatePasswordBloc>()
                    .add(UpdatePasswordEvent.oldPasswordChanged(value));
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    _formKeyOldPassword.currentState!.validate();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Next'),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPasswordPage(
      BuildContext context, UpdatePasswordState state) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKeyNewPassword,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _newPasswordController,
              obscureText: !state.isNewPasswordVisible,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(state.isNewPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    context.read<UpdatePasswordBloc>().add(
                        UpdatePasswordEvent.toggleNewPasswordVisibility(
                            !state.isNewPasswordVisible));
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'New Password cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !state.isNewPasswordVisible,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                prefixIcon: Icon(Icons.lock),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm Password cannot be empty';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    if (_formKeyNewPassword.currentState!.validate()) {
                      context.read<UpdatePasswordBloc>().add(
                          UpdatePasswordEvent.newPasswordChanged(
                              _newPasswordController.text));
                      context
                          .read<UpdatePasswordBloc>()
                          .add(const UpdatePassword());
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Done'),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
