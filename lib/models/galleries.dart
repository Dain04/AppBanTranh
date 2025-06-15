class Galleries {
  final String idgallery;
  final String namegallery;
  final String location;
  final String date_start;
  final String date_end;
  final String imagePath;
  final String description;

  Galleries({
    required this.idgallery,
    required this.namegallery,
    required this.location,
    required this.date_start,
    required this.date_end,
    required this.imagePath,
    required this.description,
  });
}

final List<Galleries> homegalleries = [
  Galleries(
    idgallery: '1',
    namegallery: 'Art Gallery 1',
    location: 'Hanoi, Vietnam',
    date_start: '2023-10-01',
    date_end: '2023-10-31',
    imagePath: 'assets/images/gallery3.jpg',
    description:
        'An exhibition showcasing contemporary art from local artists.',
  ),
  Galleries(
    idgallery: '2',
    namegallery: 'Art Gallery 2',
    location: 'Ho Chi Minh City, Vietnam',
    date_start: '2023-11-01',
    date_end: '2023-11-30',
    imagePath: 'assets/images/gallery3.jpg',
    description: 'A collection of modern art pieces from renowned artists.',
  ),
];
