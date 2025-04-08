class ImageItem {
  final String id;
  final String title;
  final String imageUrl;
  final bool isLocalFile;

  ImageItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.isLocalFile = false,
  });
}