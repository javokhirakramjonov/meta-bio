import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/ui/component/loading_view.dart';
import 'package:meta_bio/ui/screen/profile/bloc/profile_bloc.dart';
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(GetIt.I.get(), GetIt.I.get())
        ..add(const ProfileEvent.started()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          setState(() {
            firstNameController.text = state.profile?.firstName ?? "";
            lastNameController.text = state.profile?.lastName ?? "";
          });
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileCard(context, state.profile?.avatar),
                    const SizedBox(height: 16),
                    _buildChangePasswordButton(context),
                  ],
                ),
              ),
              state.isLoading ? loadingView(context) : const SizedBox.shrink()
            ]),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String? avatar) {
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
              _buildProfileImage(context, avatar),
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

  Widget _buildProfileImage(BuildContext context, String? avatar) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 64,
            backgroundImage: avatar == null
                ? const AssetImage('assets/images/avatar.png')
                : FileImage(File(avatar)),
          ),
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
                // TODO: Implement photo change functionality
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
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            context.read<ProfileBloc>().add(
                  const ProfileEvent.updateProfile(),
                );
          }
        },
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            context.read<ProfileBloc>().add(
                  ProfileEvent.firstNameChanged(value),
                );
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
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            context.read<ProfileBloc>().add(
                  const ProfileEvent.updateProfile(),
                );
          }
        },
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            context.read<ProfileBloc>().add(
                  ProfileEvent.lastNameChanged(value),
                );
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
}
