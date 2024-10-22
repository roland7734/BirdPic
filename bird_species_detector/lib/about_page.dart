import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('About Page'),
      ),
      body: SingleChildScrollView( // Enable scrolling for the content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bird Species Image Detection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Discover and learn about bird species with just a photo!',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Features:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Instant Detection'),
                subtitle: Text(
                    'Capture or upload a photo to identify bird species instantly.'),
              ),
              const ListTile(
                leading: Icon(Icons.explore),
                title: Text('Explore Bird Database'),
                subtitle: Text(
                    'Browse through a comprehensive list of bird species with images and details.'),
              ),
              const ListTile(
                leading: Icon(Icons.school),
                title: Text('Learn and Educate'),
                subtitle: Text(
                    'Access detailed information and fun facts about each species.'),
              ),
              const ListTile(
                leading: Icon(Icons.share),
                title: Text('Share Your Discoveries'),
                subtitle: Text('Share identified species with friends and family.'),
              ),
              const SizedBox(height: 16),
              const Text(
                'About Us:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Our app aims to connect people with nature by making bird-watching easy and accessible. Our powerful AI technology recognizes bird species from images, helping enthusiasts and beginners alike to learn more about the avian world.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
