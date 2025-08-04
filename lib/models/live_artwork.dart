class ArtworkLive {
  final String idartlive;
  final String nameartlive;
  final String date_start;
  final String time_start;
  final String time_end;
  final String imagePath;
  final String description;

  ArtworkLive({
    required this.idartlive,
    required this.nameartlive,
    required this.date_start,
    required this.time_start,
    required this.time_end,
    required this.imagePath,
    required this.description,
  });
}

final List<ArtworkLive> artworklive = [
  ArtworkLive(
    idartlive: '1',
    nameartlive: 'Hơi thở của Lá',
    date_start: '2025-09-15',
    time_start: '18:00',
    time_end: '20:00',
    imagePath: 'assets/images/gallery3.jpg',
    description:
        'Buổi biểu diễn tranh sống động, nơi tác phẩm được hoàn thiện ngay trước mắt khán giả, thể hiện vòng đời của một chiếc lá chuyển mình qua các mùa.',
  ),
  ArtworkLive(
    idartlive: '2',
    nameartlive: 'Ánh Sáng và Cảm Xúc',
    date_start: '2025-10-05',
    time_start: '19:00',
    time_end: '21:30',
    imagePath: 'assets/images/liv1.jpg',
    description:
        'Triển lãm tương tác kết hợp ánh sáng và hội họa trực tiếp, khám phá cảm xúc con người thông qua từng nét cọ sống động.',
  ),
];
