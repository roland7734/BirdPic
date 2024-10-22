import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;


class BirdClassifier with ChangeNotifier {
  late Interpreter interpreter;
  late List<String> labels;
  late int inputSize = 150;


  Future<void> initialize() async{
    await _loadModel();
    await _loadLabels();
  }

  Future<void> _loadModel() async {
        final modelData = await rootBundle.load('assets/model/model_v1.tflite');
        final modelBytes = modelData.buffer.asUint8List();
        interpreter = Interpreter.fromBuffer(modelBytes);

  }

  Future<void> _loadLabels() async {
    final data = await rootBundle.loadString('assets/model/labels.txt');
    labels = data.split('\n');
    labels.removeLast();
  }

  Future<String> classifyImage(CroppedFile imageFile) async {

    var inputImage = await _preprocessImage(File(imageFile.path));

    var outputBuffer = List.filled(labels.length, 0.0).reshape([1, labels.length]);
    interpreter.run(inputImage, outputBuffer);

    return _getBirdSpecies(outputBuffer.cast());
  }

  Future<List<List<List<int>>>> _preprocessImage(File imageFile) async {
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());


    img.Image resizedImage = img.copyResize(image!, width: inputSize, height: inputSize);

    List<List<List<int>>> input = List.generate(
      inputSize,
          (i) => List.generate(
        inputSize,
            (j) {
          var pixel = resizedImage.getPixel(j, i);
          return [img.getRed(pixel), img.getGreen(pixel), img.getBlue(pixel)];
        },
      ),
    );

    return input;
  }


  String _getBirdSpecies(List<List<double>> outputBuffer) {
    int maxIndex = outputBuffer[0].indexWhere((score) => score == outputBuffer[0].reduce(max));
    return labels[maxIndex];
  }

}

