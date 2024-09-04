import '../../domain/entities/year_entity.dart';

class YearModel extends YearEntity {
  YearModel({
    required super.year,
    required super.winnerCount,
  });

  factory YearModel.fromJson(Map<String, dynamic> json) {
    return YearModel(
      year: json['year'],
      winnerCount: json['winnerCount'],
    );
  }
}
