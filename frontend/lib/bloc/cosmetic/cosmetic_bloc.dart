import 'package:flutter_bloc/flutter_bloc.dart';
import '/services/cosmetic_service.dart';
import '/dto/cosmetic_model.dart';
import 'cosmetic_event.dart';  // 이벤트 import
import 'cosmetic_state.dart';  // 상태 import

class CosmeticBloc extends Bloc<CosmeticEvent, CosmeticState> {
  CosmeticBloc() : super(CosmeticInitial()) {
    on<FetchCosmetics>(_onFetchCosmetics);
    on<DeleteCosmetic>(_onDeleteCosmetic);
    on<ChangeSortCosmetics>(_onChangeSortCosmetics);
  }

  Future<void> _onFetchCosmetics(FetchCosmetics event, Emitter<CosmeticState> emit) async {
    try {
      //final cosmetics = await CosmeticService.getAllCosmetics();

      //fake data
      final cosmetics = List<Cosmetic>.generate(10, (index) => Cosmetic(
        id: index,
        name: 'Cosmetic $index',
        expirationDate: DateTime.now().add(Duration(days: index)),
        createdDate: DateTime.now(),
        purchasedDate: DateTime.now().subtract(Duration(days: index)),
        category: Category.values[index % Category.values.length],
        status: index % 2 == 0 ? Status.unopened : Status.opened,
        userId: 1,
      ));

      emit(CosmeticLoaded(cosmetics));
    } catch (e) {
      emit(CosmeticError(e.toString()));
    }
  }

  Future<void> _onDeleteCosmetic(DeleteCosmetic event, Emitter<CosmeticState> emit) async {
    try {
      await CosmeticService.deleteCosmetic(event.id);
      final cosmetics = await CosmeticService.getAllCosmetics();
      emit(CosmeticLoaded(cosmetics));
    } catch (e) {
      emit(CosmeticError(e.toString()));
    }
  }

  Future<void> _onChangeSortCosmetics(ChangeSortCosmetics event, Emitter<CosmeticState> emit) async {
    try {
      if (state is! CosmeticLoaded) {
        return;
      }

      var currentState = state as CosmeticLoaded;
      if (event.sort == '이름순') {
        currentState.cosmetics.sort((a, b) =>
            a.name.compareTo(b.name));
      } else {
        currentState.cosmetics.sort((a, b) =>
            b.expirationDate!.compareTo(a.expirationDate!));
      }
      emit(CosmeticLoaded(currentState.cosmetics));
    } catch (e) {
      emit(CosmeticError(e.toString()));
    }
  }
}