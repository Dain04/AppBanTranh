class Blog {
  final String idblog;
  final String nameblog;
  final String description;
  final String content;
  final String timeupload;
  final String imagePath;

  Blog({
    required this.idblog,
    required this.nameblog,
    required this.content,
    required this.description,
    required this.timeupload,
    required this.imagePath,
  });
}

final List<Blog> homeblog = [
  Blog(
    idblog: '1',
    nameblog: 'Blood Falls',
    timeupload: '2023-10-01',
    imagePath: 'assets/images/blog1.jpg',
    description:
        'Tác phẩm nghệ thuật được tạo ra với nhiều tranh cãi vào những năm 80.',
    content: //phần đọc thêm khi vào chi tiết
        'This gallery features a diverse range of artworks, including paintings, sculptures, and installations. The exhibition aims to highlight the creativity and talent of local artists in Hanoi. Visitors can expect to see a variety of styles and mediums, making it a must-visit for art enthusiasts.',
  ),
  Blog(
    idblog: '2',
    nameblog: 'Art Gallery 2',
    timeupload: '2023-10-01',
    imagePath: 'assets/images/gallery3.jpg',
    description:
        'An exhibition showcasing contemporary art from local artists.',
    content:
        'This gallery features a diverse range of artworks, including paintings, sculptures, and installations. The exhibition aims to highlight the creativity and talent of local artists in Hanoi. Visitors can expect to see a variety of styles and mediums, making it a must-visit for art enthusiasts.',
  ),
];
