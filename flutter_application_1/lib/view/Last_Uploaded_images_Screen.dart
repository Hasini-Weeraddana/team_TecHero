import 'package:flutter/material.dart';

class LastUploadedImagesScreen extends StatelessWidget {
  final List<dynamic> images;

  LastUploadedImagesScreen({required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: RichText(
            text: const TextSpan(
              text: "Previously Uploaded Images",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 172, 183, 244),
              ),
            ),
          ),
        ),
        leading: IconButton(
          color: const Color.fromARGB(255, 159, 168, 218),
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 26, 35, 126),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          var image = images[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'http://10.0.2.2/admin/${image['image_path']}'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Uploaded At: ${image['uploaded_at']}'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
