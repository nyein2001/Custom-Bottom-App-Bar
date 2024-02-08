import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppMenuEvent {}

class GoOnlineEvent extends AppMenuEvent {}

class GoOfflineEvent extends AppMenuEvent {}

class AppMenuCubit extends Cubit<int> {
  AppMenuCubit() : super(0);

  void changeSelectedMenu(int state) => emit(state);
}
