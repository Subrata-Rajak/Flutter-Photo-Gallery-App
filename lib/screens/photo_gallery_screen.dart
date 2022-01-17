import 'package:flutter/material.dart';
import 'package:phot_gallery_app/keys.dart';
import 'package:phot_gallery_app/services/network_helper.dart';

class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({Key? key}) : super(key: key);

  @override
  _PhotoGalleryScreenState createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  Future<List<String>>? images;

  Future<List<String>> getImagesFromPixaby() async {
    List<String> pixabyImages = [];
    String url =
        "https://pixabay.com/api/?key=$apiKey&image_type=photo&per_page=50&category=nature&page=1";

    NetworkHelper networkHelper = NetworkHelper(url: url);
    Map<String, dynamic> data = await networkHelper.getData();

    for (var entry in data["hits"]) {
      pixabyImages.add(entry["largeImageURL"]);
    }
    return pixabyImages;
  }

  @override
  void initState() {
    images = getImagesFromPixaby();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder<List<String>>(
            future: images,
            builder: (BuildContext context, AsyncSnapshot snapShot) {
              switch (snapShot.connectionState) {
                case ConnectionState.none:
                  return const Center(
                    child: Text("Error"),
                  );
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  return GridView.builder(
                    itemCount: snapShot.data?.length ?? 0,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 6.0,
                    ),
                    itemBuilder: (context, index) {
                      return Image.network(
                        snapShot.data[index],
                        fit: BoxFit.cover,
                      );
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
