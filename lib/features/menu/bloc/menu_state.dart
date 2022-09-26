part of 'menu_bloc.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuLoading extends MenuState {}

class MenusLoaded extends MenuState {
  final List<Menu> menus;

  const MenusLoaded({required this.menus});

  @override
  List<Object> get props => [menus];
}
