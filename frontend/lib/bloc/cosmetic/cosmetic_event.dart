
abstract class CosmeticEvent {}

class FetchCosmetics extends CosmeticEvent {}

class ChangeSortCosmetics extends CosmeticEvent {
  final String sort;
  ChangeSortCosmetics(this.sort);
}

class DeleteCosmetic extends CosmeticEvent {
  final String id;
  DeleteCosmetic(this.id);
}
