import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WikipediaUtility {
  static String formatSpeciesName(String name) {
    String formattedName = name.toLowerCase().replaceAll(' ', '_');
    return formattedName;
  }

  static void launchURL(BuildContext context, String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else
    {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Could not open the Wikipedia page.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }

      );
    }
  }

  static void onWikipediaButtonClick(BuildContext context, String speciesName) {
    String formattedName = WikipediaUtility.formatSpeciesName(speciesName);
    String url = 'https://en.wikipedia.org/wiki/$formattedName';

    WikipediaUtility.launchURL(context, url);
  }
}