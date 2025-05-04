import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/checkroom/domain/get_updated_selected_clothes_use_case.dart';

void main() {
  late GetUpdatedSelectedClothesUseCase useCase;

  final top = Clothing('top1', 'Top', 'url', ClothingCategoryEnum.ALL,
      ClothingPositionEnum.UPPER);
  final bottom = Clothing('bottom1', 'Bottom', 'url', ClothingCategoryEnum.ALL,
      ClothingPositionEnum.BOTTOM);
  final fullBody = Clothing('full1', 'Full Body', 'url',
      ClothingCategoryEnum.ALL, ClothingPositionEnum.FULL_BODY);

  setUp(() {
    useCase = GetUpdatedSelectedClothesUseCase();
  });

  test('Deselects already selected clothing', () {
    final selected = top.copyWith(isSelected: true);
    final result = useCase([selected], selected);

    expect(result, isEmpty);
  });

  test('Selects full body clothing, clearing existing selections', () {
    final result = useCase([top, bottom], fullBody.copyWith(isSelected: false));

    expect(result.length, 1);
    expect(result.first.id, fullBody.id);
  });

  test('Selects top clothing when none selected yet', () {
    final result = useCase([], top.copyWith(isSelected: false));

    expect(result.length, 1);
    expect(result.first.id, top.id);
  });

  test('Replaces existing full body clothing when selecting top', () {
    final result = useCase([fullBody], top.copyWith(isSelected: false));

    expect(result.length, 1);
    expect(result.first.id, top.id);
  });

  test('Replaces existing clothing with same position (top)', () {
    final anotherTop = Clothing('top2', 'Another Top', 'url',
        ClothingCategoryEnum.ALL, ClothingPositionEnum.UPPER);
    final result = useCase([top], anotherTop.copyWith(isSelected: false));

    expect(result.length, 1);
    expect(result.first.id, anotherTop.id);
  });

  test('Replaces existing clothing with same position (bottom)', () {
    final anotherBottom = Clothing('bottom2', 'Another Bottom', 'url',
        ClothingCategoryEnum.ALL, ClothingPositionEnum.BOTTOM);
    final result = useCase([bottom], anotherBottom.copyWith(isSelected: false));

    expect(result.length, 1);
    expect(result.first.id, anotherBottom.id);
  });

  test('Adds bottom when top is already selected', () {
    final result = useCase([top], bottom.copyWith(isSelected: false));

    expect(result.length, 2);
    expect(result.map((e) => e.id), containsAll([top.id, bottom.id]));
  });

  test('Adds top when bottom is already selected', () {
    final result = useCase([bottom], top.copyWith(isSelected: false));

    expect(result.length, 2);
    expect(result.map((e) => e.id), containsAll([top.id, bottom.id]));
  });
}
