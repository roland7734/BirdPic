# BirdPic

## Overview

This Flutter application allows users to take a picture of a bird, crop it, and then identify the species using an EfficientNetB0 model that has been fine-tuned on a dataset of 525 bird species. Users can read more about each species on Wikipedia and have the option to save their history and manage their favorite pictures.

## Features

- **Capture Image**: Users can take a picture of a bird using the device's camera.
- **Image Cropping**: After capturing the image, users can crop the picture to focus on the bird.
- **Species Identification**: The app utilizes an EfficientNetB0 model to identify the bird species from the cropped image.
- **Wikipedia Integration**: Users can read more about the identified species by clicking a button that redirects them to the relevant Wikipedia page.
- **History Management**: The app saves the history of all captured and identified bird images on the device.
- **Favorites**: Users can add identified bird images to their favorites and delete them if desired.

## Technology Stack

- **Flutter**: The UI framework used to build the application.
- **Dart**: The programming language used for Flutter development.
- **EfficientNetB0**: A pre-trained convolutional neural network model used for species identification.
- **Image Cropping**: A package for cropping images within the app.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio IDE

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/roland7734/BirdPic.git
   cd bird-identification-app
   
2. Install dependencies:
	```bash
	flutter pub get

3. Run the application:
	```bash
	flutter run

## Usage

1. **Take a Picture**: Select a photo from your phone's gallery or take a new picture of a bird.
2. **Crop the Image**: Use the cropping tool to focus on the bird in the image.
3. **Identify Species**: After cropping, the AI will analyze the image and identify the species.
4. **Learn More**: Click the "Learn More" button to access the Wikipedia page for the identified species.
5. **Manage History and Favorites**:
   - View the history of captured images.
   - Add images to favorites.
   - Delete images from the history or favorites.

## Future Improvements

- Expand the dataset to include more bird species.
- Implement a user authentication system to sync favorites across devices.
- Add community features to allow users to share their findings.
