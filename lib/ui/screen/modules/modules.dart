import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/domain/module.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/ui/screen/modules/bloc/modules_bloc.dart';
import 'package:meta_bio/ui/screen/modules/component/module_item.dart';
import 'package:meta_bio/ui/screen/modules/component/modules_shimmer_list.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ModulesBloc(GetIt.I.get(), context)
        ..add(const ModulesEvent.started()),
      child: BlocConsumer<ModulesBloc, ModulesState>(
        listener: (context, state) {
          //TODO: implement listener
        },
        builder: (context, state) {
          final modulesRequestState = state.modulesRequestState;

          return Scaffold(
            body: Column(
              children: [
                _buildHeader(context, state),
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<ModulesBloc>()
                        .add(const ModulesEvent.loadModules());
                  },
                  child:
                      modulesRequestState is RequestStateSuccess<List<Module>>
                          ? _buildModulesList(modulesRequestState)
                          : const ModulesShimmerList(),
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ModulesState state) {
    return Container(
      height: 115,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 39),
        child: _buildHeaderRow(state.profile),
      ),
    );
  }

  Widget _buildHeaderRow(Profile? profile) {
    final avatar = profile?.avatar;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 20),
        CircleAvatar(
          radius: 24,
          backgroundImage: avatar != null
              ? FileImage(File(avatar))
              : const AssetImage('assets/images/avatar.png'),
        ),
        const SizedBox(width: 12),
        _buildHeaderText(profile),
      ],
    );
  }

  Widget _buildHeaderText(Profile? profile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hello,',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          profile?.firstName ?? '',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildModulesList(
      RequestStateSuccess<List<Module>> modulesRequestState) {
    return ListView.builder(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount: modulesRequestState.data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ModuleItem(module: modulesRequestState.data[index]),
        );
      },
    );
  }
}
