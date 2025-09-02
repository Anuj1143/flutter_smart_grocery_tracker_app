
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery_tracker/bloc/navigation/navigation_event.dart';
import 'package:smart_grocery_tracker/bloc/navigation/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(0)) {
    on<NavigationToTab>((event, emit) {
      emit(NavigationState(event.index));
    });
  }
}
