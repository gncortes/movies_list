import '../../domain/entities/producer_interval_entity.dart';

class ProducerIntervalModel extends ProducerIntervalEntity {
  ProducerIntervalModel({
    required super.producer,
    required super.interval,
    required super.previousWin,
    required super.followingWin,
  });

  ProducerIntervalModel.fromJson(Map<String, dynamic> json)
      : super(
          producer: json['producer'],
          interval: json['interval'],
          previousWin: json['previousWin'],
          followingWin: json['followingWin'],
        );
}
