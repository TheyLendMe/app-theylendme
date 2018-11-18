import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class PickImage{
  static Future<File> getImageFromCamera() async{
    return await _changeAndSave(await ImagePicker.pickImage(source: ImageSource.camera));
  }

  static Future<File> getImageFromGallery() async{
    return await _changeAndSave(await ImagePicker.pickImage(source: ImageSource.gallery));
  }

  static Future<File> _changeAndSave(File file)async {
    String path = (await getApplicationDocumentsDirectory()).path;
    String ext = extension(file.absolute.path);
    DateFormat dateFormat = new DateFormat("yMMMMdHms");
    return await FlutterImageCompress.compressAndGetFile(
          file.absolute.path, '$path/'+"last"+dateFormat.format(DateTime.now())+ext,
          quality: 80,
          minWidth: 800,
      );
  }
  }