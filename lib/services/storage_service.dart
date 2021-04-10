import 'dart:io';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class StorageService {
  static Future<List<String>> getAllDownloadURLs() async {
    List<String> urls = [];
    ListResult list = await Amplify.Storage.list();
    for(StorageItem item in list.items) {
      GetUrlResult url = await Amplify.Storage.getUrl(key: item.key);
      urls.add(url.url);
    }
    return urls;
  }

  static Future<UploadFileResult> uploadFile({
    String key,
    File local,
    S3UploadFileOptions options,
  }) {
    return Amplify.Storage.uploadFile(
      key: key,
      local: local,
      options: options,
    );
  }

  static Future<void> deleteAll() async {
    ListResult list = await Amplify.Storage.list();
    for(StorageItem item in list.items) {
      await Amplify.Storage.remove(
        key: item.key,
      );
    }
  }
}
