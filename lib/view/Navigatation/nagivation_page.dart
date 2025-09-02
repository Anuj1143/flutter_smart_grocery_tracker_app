import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery_tracker/bloc/navigation/navigation_bloc.dart';
import 'package:smart_grocery_tracker/bloc/navigation/navigation_event.dart';
import 'package:smart_grocery_tracker/bloc/navigation/navigation_state.dart';
import 'package:smart_grocery_tracker/core/theme/app_color.dart';
import 'package:smart_grocery_tracker/view/home/home_page.dart';

class NagivationPage extends StatelessWidget {
  final int? initialIndex;
  const NagivationPage({super.key, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NavigationBloc()..add(NavigationToTab(initialIndex ?? 0)),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: IndexedStack(children: [HomePage()]),

            bottomNavigationBar: NavigationBar(
              backgroundColor: AppColors.accent,
              indicatorColor: AppColors.primary.withAlpha(40),
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.list_alt_outlined),
                  selectedIcon: Icon(Icons.list),
                  label: 'Grocery List',
                ),

                NavigationDestination(
                  icon: Icon(Icons.add_outlined),
                  selectedIcon: Icon(Icons.add),
                  label: 'Add Items',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              selectedIndex: state.currentIndex,
              onDestinationSelected: (index) {
                context.read<NavigationBloc>().add(NavigationToTab(index));
              },
            ),
          );
        },
      ),
    );
  }
}
