import 'dart:io';
import 'package:bird_species_detector/history_type.dart';
import 'package:bird_species_detector/image_details_screen.dart';
import 'package:bird_species_detector/image_entry_utility.dart';
import 'package:flutter/material.dart';
import 'image_entry.dart';

class HistoryPage extends StatefulWidget {
  final ItemCategory category;

  const HistoryPage({super.key, required this.category});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<ImageEntry> history = ImageEntryUtility.imageHistory;
  String text = '';


  @override
  Widget build(BuildContext context) {
    List<ImageEntry> filteredHistory;
    history = ImageEntryUtility.imageHistory;

    switch (widget.category) {
      case ItemCategory.history:
        filteredHistory = history.where((item) => !item.isDeleted).toList();
        text = 'After you take pictures, they\'ll appear here.';
        break;
      case ItemCategory.favorites:
        filteredHistory = history
            .where((item) => !item.isDeleted && item.isFavorite)
            .toList();
        text = 'You have no favorite pictures.';
        break;
      case ItemCategory.trash:
        filteredHistory = history.where((item) => item.isDeleted).toList();
        text = 'The trash is empty.';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: switch (widget.category) {
          ItemCategory.history => const Text('History'),
          ItemCategory.favorites => const Text('Favorites'),
          ItemCategory.trash => const Text('Trash'),
        },
      ),
      body: filteredHistory.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: filteredHistory.length,
              itemBuilder: (context, index) {
                final item = filteredHistory[index];
                return GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImageDetailScreen(
                            items: filteredHistory,
                            initialIndex: index,
                            category: widget.category),
                      ),
                    );
                    setState(() {});
                  },
                  child: Stack(fit: StackFit.expand, children: [
                    item.imagePath.isNotEmpty
                        ? Image.file(File(item.imagePath), fit: BoxFit.cover)
                        : const Placeholder()
                  ]


                      ),
                );
              },
            )
          : Center(
        child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image_outlined,
                    size: 100.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'No Pictures',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    ),
    );
  }
}