import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/open_door_repository.dart';
import '../../../../injection_container.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final _openDoorRepository = sl.get<OpenDoorRepository>();

  HomeCubit() : super(HomeInitial());

  Future<void> openDoor() async {
    emit(HomeLoading());

    try {
      await _openDoorRepository.openDoor();
      emit(HomeLoaded());
    } catch (e) {
      emit(HomeError(error: e.toString()));
    }
  }
}
