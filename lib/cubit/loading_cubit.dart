import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingCubit extends Cubit<int> {
  bool isOnline = true;
  LoadingCubit() : super(0);

  void handleGoOnlineOffline() async {
    emit(2);
    isOnline = !isOnline;
    await Future.delayed(const Duration(seconds: 5));
    isOnline ? emit(0) : emit(1);
  }
}
