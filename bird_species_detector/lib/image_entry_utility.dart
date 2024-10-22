import 'dart:convert';
import 'dart:io';
import 'package:bird_species_detector/image_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';



class ImageEntryUtility {
  static List<ImageEntry> imageHistory = [];

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  static String formatSize(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes bytes';
    } else if (sizeInBytes < 1024 * 1024) {
      final sizeInKB = sizeInBytes / 1024;
      return '${sizeInKB.toStringAsFixed(2)} KB';
    } else {
      final sizeInMB = sizeInBytes / (1024 * 1024);
      return '${sizeInMB.toStringAsFixed(2)} MB';
    }
  }


  static Future<void> getImageInformation(ImageEntry item)
  async {
    final image = File(item.imagePath);
    final imageBytes = await image.readAsBytes();

    final decodedImage = img.decodeImage(imageBytes);

    if (decodedImage != null) {
      item.width = decodedImage.width;
      item.height = decodedImage.height;
    }

    item.sizeInBytes = image.lengthSync();

  }

  /// Load the image history from persistent storage
  static Future<void> loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? historyString = prefs.getString('history');

    if (historyString != null) {
      List<dynamic> jsonList = json.decode(historyString);
      imageHistory = jsonList
          .map((item) => ImageEntry.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
  }

  /// Save the image history to persistent storage
  static Future<void> saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String historyString =
        json.encode(imageHistory.map((entry) => entry.toJson()).toList());
    await prefs.setString('history', historyString);
  }

  /// Add a new entry to the image history and save it
  static Future<void> addNewToHistory(
      File image, String detectedSpecies) async {
    try {
      // Get the application's document directory
      Directory appDocDir = await getApplicationDocumentsDirectory();

      // Create a directory to store images if it doesn't exist
      String imagesDirectoryPath = '${appDocDir.path}/images';
      Directory imagesDirectory = Directory(imagesDirectoryPath);
      if (!await imagesDirectory.exists()) {
        await imagesDirectory.create(recursive: true);
      }

      // Define the new path for the image
      String imagePath =
          '${imagesDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      // File newImage = await image.copy(imagePath);
      await image.copy(imagePath);

      // Create a new ImageEntry object
      ImageEntry newEntry = ImageEntry(imagePath, detectedSpecies);
      await getImageInformation(newEntry);

      // Add the new entry to the history list
      imageHistory.add(newEntry);

      // Save the updated history to persistent storage
      await saveHistory();

      print('Image saved to: $imagePath');
    } catch (e) {
      print('Error saving image and description: $e');
    }
  }

  static Future<void> changeFavoriteStatus(String imagePath) async {
    var item = imageHistory
        .where(
          (item) => item.imagePath == imagePath,
        )
        .toList()
        .firstOrNull;
    if (item != null) {
      item.isFavorite = !item.isFavorite;
      await saveHistory();
    }
  }

  static Future<void> changeDeleteStatus(String imagePath) async {
    var item = imageHistory
        .where(
          (item) => item.imagePath == imagePath,
        )
        .toList()
        .firstOrNull;
    if (item != null) {
      item.isDeleted = !item.isDeleted;
      await saveHistory();
    }
  }

  static Future<void> deletePermanently(ImageEntry image) async {
      imageHistory.remove(image);
      await saveHistory();

  }
}
