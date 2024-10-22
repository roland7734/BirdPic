import 'dart:convert';
import 'dart:io';
import 'package:bird_species_detector/ai_model_utility.dart';
import 'package:bird_species_detector/history_page.dart';
import 'package:bird_species_detector/history_type.dart';
import 'package:bird_species_detector/image_entry.dart';
import 'package:bird_species_detector/image_entry_utility.dart';
import 'package:bird_species_detector/result_page.dart';
import 'package:bird_species_detector/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? _image;
  bool _isProcessing = false;
  String? _detectedSpecies;
  final ImagePicker _picker = ImagePicker();
  List<ImageEntry> _history = ImageEntryUtility.imageHistory;
  BirdClassifier? birdClassifier;

  @override
  void initState() {
    super.initState();
    if(_history.isEmpty)
      {
        ImageEntryUtility.loadHistory();
        _history = ImageEntryUtility.imageHistory;
      }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    birdClassifier = Provider.of<BirdClassifier>(context, listen: false);
  }

  Future<void> _pickImage(bool pickGalleryImage) async {
    if (pickGalleryImage == true) {
      _image = await _picker.pickImage(source: ImageSource.gallery);
    } else {
      _image = await _picker.pickImage(source: ImageSource.camera);
    }
    if (_image != null) {
      final croppedImage = await cropImages(_image!);
      if (!mounted) return;

      await _processImage(croppedImage);
      ImageEntryUtility.addNewToHistory(File(croppedImage.path), _detectedSpecies ?? 'Unknown');

      if (!mounted) return;
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => ResultPage(
                    image: croppedImage,
                    speciesName: _detectedSpecies ?? 'Not identified',
                  ))));
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processImage(croppedImage) async {
    setState(() {
      _isProcessing = true;
    });


    if(birdClassifier != null){
      _detectedSpecies = await birdClassifier?.classifyImage(croppedImage);
    }

  }

  Future<CroppedFile> cropImages(XFile image) async {
    final croppedFile = await ImageCropper()
        .cropImage(sourcePath: image.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.ratio16x9,
    ], uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.deepPurple,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
        title: 'Crop Image',
      ),
    ]);

    return croppedFile!;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('BirdPic'),
      ),
      body: Center(
          child: !_isProcessing
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      ElevatedButton.icon(
                        onPressed: () {
                          _pickImage(false);
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take a Picture'),
                      ),
                      const SizedBox(height: 20),
                      Image.asset('assets/images/home_bird.png'),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          _pickImage(true);
                        },
                        icon:
                            const Icon(Icons.photo_size_select_actual_outlined),
                        label: const Text('Choose from Gallery'),
                      )
                    ])
                  : const CircularProgressIndicator()

      ),
      drawer: Drawer(
        backgroundColor: Colors.lightBlueAccent,
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors
                    .lightBlueAccent, // Set a background color for the header
              ),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60, // Adjust the radius as needed
                      backgroundImage: AssetImage(
                          'assets/images/bird1.jpg'), // Your bird image
                    ),
                    SizedBox(
                        height:
                            10), // Add some space between the image and the text
                    Text(
                      'BirdPic - Bird Image Identification',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage(category: ItemCategory.history)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border_rounded),
              title: const Text("Favorites"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage(category: ItemCategory.favorites)),
                );
              }
            ),
            ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text("Trash"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryPage(category: ItemCategory.trash)),
                  );
                }
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _history.clear();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String updatedHistoryString = json.encode(_history);
          await prefs.setString('history', updatedHistoryString);
          ImageEntryUtility.imageHistory.clear();
          ImageEntryUtility.saveHistory();
        },
        elevation: 10,
        tooltip: 'delete history',
        child: const Icon(Icons.playlist_remove_outlined),
      ),
    );
  }
}
