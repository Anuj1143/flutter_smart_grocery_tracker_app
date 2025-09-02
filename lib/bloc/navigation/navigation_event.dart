abstract class NavigationEvent {}

class NavigationToTab extends NavigationEvent {
  final int index;
  NavigationToTab(this.index);
}
