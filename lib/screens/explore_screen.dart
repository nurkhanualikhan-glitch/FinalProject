import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/api/api_cubit.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('explore'.tr()),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ApiCubit>().loadQuotes();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<ApiCubit, ApiState>(
        builder: (context, state) {
          if (state is ApiLoading || state is ApiInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ApiError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(state.message),
              ),
            );
          }

          if (state is ApiLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.quotes.length,
              itemBuilder: (context, index) {
                final quote = state.quotes[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.format_quote),
                    title: Text('"${quote.text}"'),
                    subtitle: Text(quote.author),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
