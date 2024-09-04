import 'producer_interval_entity.dart';

class ProducerIntervalDataEntity {
  final List<ProducerIntervalEntity> min;
  final List<ProducerIntervalEntity> max;

  ProducerIntervalDataEntity({
    required this.min,
    required this.max,
  });
}
