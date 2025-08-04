class Genres {
  final String name;
  final String imagePath;

  Genres({required this.name, required this.imagePath});
}

final List<Genres> homeGalleries = [
  Genres(name: 'Hoa', imagePath: 'assets/images/flowerstyle.jpg'),
  Genres(name: 'Cổ điển', imagePath: 'assets/images/classisctyle.jpg'),
  Genres(name: 'Hiện đại', imagePath: 'assets/images/modernstyle.jpg'),
  Genres(name: 'Bối cảnh', imagePath: 'assets/images/scene.jpg'),
  Genres(name: 'Chân dung', imagePath: 'assets/images/portrait.jpg'),
];
