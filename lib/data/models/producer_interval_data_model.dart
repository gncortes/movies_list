import '../../domain/entities/producer_interval_data_entity.dart';
import 'producer_interval_model.dart';

class ProducerIntervalDataModel extends ProducerIntervalDataEntity {
  ProducerIntervalDataModel({
    required super.min,
    required super.max,
  });

  ProducerIntervalDataModel.fromJson(Map<String, dynamic> json)
      : super(
          min: (json['min'] as List)
              .map((item) => ProducerIntervalModel.fromJson(item))
              .toList(),
          max: (json['max'] as List)
              .map((item) => ProducerIntervalModel.fromJson(item))
              .toList(),
        );
}
