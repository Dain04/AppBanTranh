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
    nameartlive: 'T-Hun',
    date_start: '2023-10-01',
    time_start: '19h',
    time_end: '21h',
    imagePath: 'assets/images/gallery3.jpg',
    description: 'Như là 1 thể của lá',
  ),
  ArtworkLive(
    idartlive: '2',
    nameartlive: 'Art Gallery 2',
    date_start: '2023-11-01',
    time_start: '19h',
    time_end: '21h',
    imagePath: 'assets/images/gallery3.jpg',
    description: 'A collection of modern art pieces from renowned artists.',
  ),
];
