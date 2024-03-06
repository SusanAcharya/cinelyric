import 'package:carousel_slider/carousel_slider.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:flutter/material.dart';

import '../elements/appbar.dart';

class ForYouMusic extends StatelessWidget {
  final List<CarouselItem> carouselItems = [
    CarouselItem(
      imageUrl: 'assets/kendrick.jpeg',
      title: 'Song Title 1',
      description: 'Artist Name 1',
    ),
    CarouselItem(
      imageUrl: 'assets/drake.webp',
      title: 'Song Title 2',
      description: 'Artist Name 2',
    ),
    CarouselItem(
      imageUrl: 'assets/weeknd.jpeg',
      title: 'Song Title 1',
      description: 'Artist Name 1',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "For you:",
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                SizedBox(width: 8),
                Material(
                  child: Tooltip(
                    message:
                        "We took a little sneak peek on the music you bookmarked. And we thought these songs/artists might fit your taste.",
                    child: Icon(
                      Icons.help,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CarouselSlider.builder(
              itemCount: carouselItems.length,
              options: CarouselOptions(
                height: 600.0, // Adjust the height as needed
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              itemBuilder: (context, index, realIndex) {
                return _buildCarouselItem(carouselItems[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 2),
    );
  }

  Widget _buildCarouselItem(CarouselItem item) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              item.imageUrl,
              height: 300.0, // Adjust the height of the rounded image
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            item.description,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class CarouselItem {
  final String imageUrl;
  final String title;
  final String description;

  CarouselItem({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}
