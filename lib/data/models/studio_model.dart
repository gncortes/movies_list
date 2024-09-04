import '../../domain/entities/studio_entity.dart';

class StudioModel extends StudioEntity {
  StudioModel({
    required super.name,
    required super.winCount,
  });

  factory StudioModel.fromJson(Map<String, dynamic> json) {
    return StudioModel(
      name: json['name'],
      winCount: json['winCount'],
    );
  }
}
