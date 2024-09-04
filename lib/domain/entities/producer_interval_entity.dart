class ProducerIntervalEntity {
  final String producer;
  final int interval;
  final int previousWin;
  final int followingWin;

  ProducerIntervalEntity({
    required this.producer,
    required this.interval,
    required this.previousWin,
    required this.followingWin,
  });
}
