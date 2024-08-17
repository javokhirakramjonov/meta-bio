import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/ui/component/loading_view.dart';
import 'package:meta_bio/ui/screen/profile/bloc/profile_bloc.dart';
import 'package:meta_bio/ui/screen/splash/splash.dart';
import 'package:meta_bio/ui/screen/update_password/update_password.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: "");
  final TextEditingController lastNameController =
      TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(GetIt.I.get(), GetIt.I.get())
        ..add(const ProfileEvent.started()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          _updateTextControllers(state);
          _handleProfileUpdateState(context, state);
          _handleLogout(context, state);
          _handleAvatarUpdateState(context, state);
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFF171717),
            appBar: AppBar(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 0,
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Stack(children: [
              RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<ProfileBloc>()
                      .add(const ProfileEvent.loadProfile());
                },
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildProfileCard(context, state),
                        const SizedBox(height: 16),
                        _buildChangePasswordButton(context),
                        const SizedBox(height: 16),
                        _buildLogOutButton(context),
                      ],
                    ),
                  ),
                ),
              ),
              state.isLoading ? loadingView(context) : const SizedBox.shrink()
            ]),
          );
        },
      ),
    );
  }

  void _updateTextControllers(ProfileState state) {
    firstNameController.text = state.profile?.firstName ?? "";
    lastNameController.text = state.profile?.lastName ?? "";
  }

  void _handleProfileUpdateState(BuildContext context, ProfileState state) {
    final updateProfileRequestState = state.updateProfileRequestState;

    if (updateProfileRequestState is RequestStateSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } else if (updateProfileRequestState is RequestStateError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(updateProfileRequestState.errorMessage),
        ),
      );
    }
  }

  void _handleLogout(BuildContext context, ProfileState state) {
    if (state.shouldLogOut) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    }
  }

  void _handleAvatarUpdateState(BuildContext context, ProfileState state) {
    final updateAvatarRequestState = state.updateAvatarRequestState;

    if (updateAvatarRequestState is RequestStateSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Avatar updated successfully'),
        ),
      );
    } else if (updateAvatarRequestState is RequestStateError<String>) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(updateAvatarRequestState.errorMessage),
        ),
      );
    }
  }

  Widget _buildProfileCard(BuildContext context, ProfileState state) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF0D0D0D),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProfileImage(context, state),
              const SizedBox(height: 56),
              _buildFirstNameField(context),
              const SizedBox(height: 16),
              _buildLastNameField(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, ProfileState state) {
    var avatar = state.profile?.avatar;

    return Center(
      child: Stack(
        children: [
          Stack(children: [
            ClipOval(
              child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: avatar == null
                              ? const AssetImage('assets/images/avatar.png')
                              : FileImage(File(avatar))),
                    ),
                  )),
            ),
            SizedBox(
              width: 140,
              height: 140,
              child: state.updateAvatarRequestState is RequestStateLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            )
          ]),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              child: const CircleAvatar(
                radius: 20,
                child: Icon(
                  Icons.add_a_photo,
                  size: 20,
                ),
              ),
              onTap: () {
                context
                    .read<ProfileBloc>()
                    .add(const ProfileEvent.pickAvatar());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: firstNameController,
        decoration: InputDecoration(
          labelText: 'First Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          suffixIcon: const Icon(Icons.edit),
        ),
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'First name cannot be empty or blank';
          }
          return null;
        },
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            context.read<ProfileBloc>().add(
                  ProfileEvent.firstNameChanged(value),
                );
          }
        },
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            context.read<ProfileBloc>().add(const ProfileEvent.updateProfile());
          }
        },
      ),
    );
  }

  Widget _buildLastNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: lastNameController,
        decoration: InputDecoration(
          labelText: 'Last Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          suffixIcon: const Icon(Icons.edit),
        ),
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Last name cannot be empty or blank';
          }
          return null;
        },
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            context.read<ProfileBloc>().add(
                  ProfileEvent.lastNameChanged(value),
                );
          }
        },
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            context.read<ProfileBloc>().add(const ProfileEvent.updateProfile());
          }
        },
      ),
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UpdatePasswordScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                "Change password",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogOutButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          foregroundColor: Theme.of(context).colorScheme.error),
      onPressed: () {
        context.read<ProfileBloc>().add(const ProfileEvent.logout());
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Log Out",
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.error),
              ),
            ),
            Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
