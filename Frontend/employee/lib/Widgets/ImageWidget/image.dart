import 'package:flutter/material.dart';

class ImageListScreen extends StatefulWidget {
  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  List<String> _imagePaths = [
    'assets/Profile_images/profile1.jpg',
    'assets/Profile_images/profile2.jpg',
    'assets/Profile_images/profile3.jpg',
    'assets/Profile_images/profile4.jpg',
  ];

  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image List'),
      ),
      body: GridView.builder(
        itemCount: _imagePaths.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedImagePath = _imagePaths[index];
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: AssetImage(_imagePaths[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Do something with the selected image path
          print(_selectedImagePath);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}