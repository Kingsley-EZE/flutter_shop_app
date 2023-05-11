import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


class ImageHelper{

  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  }) : _imagePicker = imagePicker ?? ImagePicker(), _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery, int imageQuality = 100,}) async{
    return await _imagePicker.pickImage(source: source, imageQuality: imageQuality,);
  }

  // Future<CroppedFile?> cropImage({required XFile file, CropStyle cropStyle = CropStyle.circle}) async{
  //   return await _imageCropper.cropImage(sourcePath: file.path, cropStyle: cropStyle,);
  // }

  Future<File?> cropImage({required File file, CropStyle cropStyle = CropStyle.circle}) async{
    CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath: file.path, cropStyle: cropStyle,);
    if(croppedImage == null) return null;
    return File(croppedImage.path);
  }

}