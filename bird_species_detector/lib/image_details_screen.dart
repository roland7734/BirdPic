import 'dart:io';
import 'package:bird_species_detector/history_type.dart';
import 'package:bird_species_detector/image_entry.dart';
import 'package:bird_species_detector/image_entry_utility.dart';
import 'package:bird_species_detector/wikipedia_utility.dart';
import 'package:flutter/material.dart';
import 'package:bird_species_detector/constants.dart';


class ImageDetailScreen extends StatefulWidget {
  final List<ImageEntry> items;
  final int initialIndex;
  final ItemCategory category;
  const ImageDetailScreen(
      {super.key,
      required this.items,
      required this.initialIndex,
      required this.category});

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late List<ImageEntry> _items;

  bool _showButtons = true;

  bool _isInfoVisible = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;


  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
    _pageController = PageController(initialPage: widget.initialIndex);
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), // Start position (off-screen)
      end: const Offset(0, 0), // End position (on-screen)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<bool?> _showDeleteDialog(int index)
  {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text(deleteDialogTitles[index]),
        content: Text(deleteDialogContents[index]),
        actions: <Widget>[
          TextButton(onPressed: () {
            Navigator.pop(context, false);
          },
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ), child: const Text(cancelButton),),

          TextButton(onPressed: () {
            Navigator.pop(context, true);
          },
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge
               ,
            ), child: Text(deleteDialogYesButtons[index]),)
        ],
      );
    },
    );
  }



  void _deleteCurrentImage(int currentIndex) {
    setState(() {
      _items.removeAt(currentIndex);

      if (_items.isEmpty) {
        Navigator.of(context).pop();
      } else {
        if (currentIndex >= _items.length) {
          currentIndex = _items.length - 1;
        }
        _pageController.jumpToPage(currentIndex);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const double panelHeight = 100.0;
    final double targetYAlignment = -1.0 + ((screenHeight / 2) / screenHeight) - (panelHeight / screenHeight);

    return Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showButtons = !_showButtons;
                          if(_isInfoVisible == true)
                            {
                              _isInfoVisible == false;
                              _showButtons = true;
                            }
                        });
                      },

                      child: Container(
                        margin: const EdgeInsets.only(top: 50.0, bottom: 100.0),
                        alignment: Alignment.center,
                        child: AnimatedAlign(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  alignment: _isInfoVisible ? Alignment(0.0, targetYAlignment) : Alignment.center,

                                  child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  item.imagePath.isNotEmpty
                    ? Image.file(File(item.imagePath),
                    fit: BoxFit.contain)
                    : const Placeholder(),
                    ],
                    ),
                    ),
                    ),
                             ),





                    if(_isInfoVisible)

                AnimatedAlign(
                duration: const Duration(milliseconds: 5000),
                curve: Curves.easeInOut,
                alignment: _isInfoVisible ? const Alignment(0.0, 0.0) : const Alignment(0, -1000.0),

                child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                height: screenHeight / 2,
                decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),

                  Text(
                'Date: ${ImageEntryUtility.formatDate(item.date)}',
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold ),
                ),
                const SizedBox(height: 8.0),
                  Text(item.imagePath),
                  const SizedBox(height: 32.0),
                const Text(
                'Image Information',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                'Resolution: ${item.width!=null || item.height!=null ? '${item.width} x ${item.height}' : 'Unknown'}',
                style: const TextStyle(fontSize: 14.0),
                ),
                const SizedBox(height: 4.0),
                Text(
                'Dimension: ${item.sizeInBytes!=null ? ImageEntryUtility.formatSize(item.sizeInBytes!) : 'Unknown'}',
                style: const TextStyle(fontSize: 14.0),
                ),
                ],

                ),
                ),
                ),


                ]
                ),
                ),

                    if (_showButtons)
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            if(item.detectedSpecies != 'Unknown')
                            InkWell(
                              onTap: () {
                                WikipediaUtility.onWikipediaButtonClick(context, item.detectedSpecies);
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: item.detectedSpecies,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.lightBlue,
                                    decorationThickness: 2,
                                  ),
                                ),
                              ),
                            ),
                            if(item.detectedSpecies == 'Unknown')
                              Text(
                                item.detectedSpecies,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: switch (widget.category) {
                                ItemCategory.history => [
                                    IconButton(
                                      icon: Icon(
                                        item.isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: item.isFavorite
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      onPressed: () async {
                                        // Handle "Favorite" button press
                                        await ImageEntryUtility
                                            .changeFavoriteStatus(item.imagePath);
      
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded,
                                          color: Colors.black),
                                      onPressed: () async {
                                        // Handle "Delete" button press
                                        bool? result = await _showDeleteDialog(0);
                                        if(result == true)
                                          {
                                            await ImageEntryUtility
                                                .changeDeleteStatus(item.imagePath);
                                            int currentPage =
                                            _pageController.page!.toInt();
                                            _deleteCurrentImage(currentPage);
                                          }

                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.info_outline,
                                          color: Colors.black),
                                      onPressed: () {
                                        // Handle "Info" button press
                                        _handleInfoButtonPress(item);
                                      },
                                    ),
                                  ],
                                ItemCategory.favorites => [
                                  IconButton(
                                    icon: Icon(item.isFavorite ? Icons.favorite : Icons.favorite_border, color:
                                    item.isFavorite ? Colors.red : Colors.black,
                                    ),
                                    onPressed: ()  async {
                                      // Handle "Favorite" button press

                                      await ImageEntryUtility.changeFavoriteStatus(item.imagePath);
                                      int currentPage = _pageController.page!.toInt();
                                      _deleteCurrentImage(currentPage);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.black),
                                    onPressed: () async {
                                      // Handle "Delete" button press
                                      bool? result = await _showDeleteDialog(0);

                                      if(result == true)
                                        {
                                          await ImageEntryUtility.changeDeleteStatus(item.imagePath);
                                          int currentPage = _pageController.page!.toInt();
                                          _deleteCurrentImage(currentPage);
                                        }
      

                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.info_outline, color: Colors.black),
                                    onPressed: () {
                                      // Handle "Info" button press
                                      _handleInfoButtonPress(item);

                                    },
                                  ),
                                ],
                                ItemCategory.trash => [
                                  IconButton(onPressed: () async {

                                    bool? result = await _showDeleteDialog(2);
                                    if(result == true)
                                      {
                                        await ImageEntryUtility.changeDeleteStatus(item.imagePath);
                                        int currentPage = _pageController.page!.toInt();
                                        _deleteCurrentImage(currentPage);
                                      }
      

      
                                  }, icon: const Icon(Icons.restore_from_trash_rounded)),
                                  IconButton(onPressed: () async {

                                    bool? result = await _showDeleteDialog(1);

                                    if(result == true)
                                      {
                                        await ImageEntryUtility.deletePermanently(item);
                                        int currentPage = _pageController.page!.toInt();
                                        _deleteCurrentImage(currentPage);
                                      }
      

                                  }, icon: const Icon(Icons.delete_forever_rounded))
                                ]
                              },
                            ),
                          ],
                        ),
                      ),


                 ],
                );
              },
            ),
          ],
        ),
    );
  }

  void _handleInfoButtonPress(ImageEntry item) {
    setState(() {
      _isInfoVisible = !_isInfoVisible;
      if (_isInfoVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

}
