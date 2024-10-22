class ImageEntry {
  String imagePath;
  String detectedSpecies;
  bool isFavorite;
  bool isDeleted;
  DateTime date;
  int? width;
  int? height;
  int? sizeInBytes;

  ImageEntry(
      this.imagePath,
      this.detectedSpecies, {
        this.isFavorite = false,
        this.isDeleted = false,
        DateTime? date, this.width, this.height, this.sizeInBytes}) : date = date ?? DateTime.now();




  // Convert an ImageEntry to a map (JSON representation)
  Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'detectedSpecies': detectedSpecies,
    'isFavorite': isFavorite,
    'isDeleted': isDeleted,
    'date': date.toIso8601String(),
    'width': width,
    'height': height,
    'size': sizeInBytes
  };

  // Convert a map (JSON representation) to an ImageEntry
  factory ImageEntry.fromJson(Map<String, dynamic> json) {
    return ImageEntry(
      json['imagePath'] as String,
      json['detectedSpecies'] as String,
      isFavorite: json['isFavorite'] as bool,
      isDeleted: json['isDeleted'] as bool,
      date: DateTime.parse(json['date'] as String),
      width: json['width'] as int?,
      height: json['height'] as int?,
      sizeInBytes: json['size'] as int?
    );
  }

  @override
  String toString() {
    return 'Path: $imagePath, detectedSpecies: $detectedSpecies, '
        'Favorite: $isFavorite, Deleted: $isDeleted, Date: ${date.toLocal()}'
        'Width: $width, Height: $height, size: $sizeInBytes';
  }
}