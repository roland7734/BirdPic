import 'dart:io';
import 'package:bird_species_detector/wikipedia_utility.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';


class ResultPage extends StatelessWidget {
  final CroppedFile image;
  final String speciesName;



  const ResultPage({super.key, required this.image, required this.speciesName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detection Result'),
        ),
        body: Stack(
          children: [
            SafeArea(
            child: Column(
              children: [
                //Spacer(flex: 1),
                Flexible(flex: 100,
                    child: Container(
                        alignment: Alignment.center,
                        child: Image.file(File(image.path), fit: BoxFit.cover))),
                const Spacer(flex: 5),
                Text(
                  speciesName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 5),
                ElevatedButton(
                  onPressed: () {
                    // Open Wikipedia page for the detected species
                    WikipediaUtility.onWikipediaButtonClick(context, speciesName);
                  },
                  child: const Text('Learn More on Wikipedia'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Detect another species'),
                ),
                const Spacer(flex: 4),

              ],
            ),
          ),
    ],
    ),

    );
  }




}
