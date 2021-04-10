import 'dart:io';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class StoragePage extends StatefulWidget {
  @override
  _StoragePageState createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  Future<List<String>> _urls;

  @override
  void initState() {
    super.initState();
    _updateImages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDeleteButton(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _updateImages(),
            child: _buildGallery(),
          ),
        ),
        _buildUploadButton(),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return TextButton(
      child: Text('Delete all images', style: TextStyle(color: Colors.red),),
      onPressed: _deleteAllImages,
    );
  }

  Widget _buildGallery() {
    return FutureBuilder(
      future: _urls,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          List<String> urls = snapshot.data;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150.0,
            ),
            itemCount: urls.length,
            itemBuilder: (context, index) {
              String url = urls[index];
              return GridTile(
                child: Image.network(
                  url,
                  fit: BoxFit.fill,
                ),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildUploadButton() {
    return ElevatedButton(
      child: Text('Upload Image'),
      onPressed: _uploadImage,
    );
  }

  Future<void> _updateImages() async {
    try {
      setState(() {
        _urls = StorageService.getAllDownloadURLs();
      });
    } on StorageException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
  }

  _uploadImage() async {
    PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
    if(file != null) {
      File image = File(file.path);
      String filename = image.path.split('/').last;
      Map<String, String> metadata = {
        'name': filename,
      };
      S3UploadFileOptions options = S3UploadFileOptions(
        accessLevel: StorageAccessLevel.guest,
        metadata: metadata,
      );
      try {
        await StorageService.uploadFile(
          key: DateTime.now().toString() + filename,
          local: image,
          options: options,
        );
        _updateImages();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Successfully uploaded image'),
        ));
      } on StorageException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
        ));
      }
    }
  }

  _deleteAllImages() async {
    try {
      await StorageService.deleteAll();
      _updateImages();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully deleted images'),
      ));
    } on StorageException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
  }
}
