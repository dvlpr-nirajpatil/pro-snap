import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prosnap/core/network/api_exception.dart';
import 'package:prosnap/core/router/routes.dart';
import 'package:prosnap/features/create_post/repository/create_post_repository.dart';
import 'package:prosnap/features/location_picker/models/location_address.dart';

class CreatePostController extends GetxController {
  final ImagePicker imagePicker = ImagePicker();
  final CreatePostRepository repository = CreatePostRepository();

  RxBool sharingPost = false.obs;

  RxList<String> imageUrl = <String>[].obs;
  Rxn<LocationAddress> address = Rxn<LocationAddress>();

  pickImage() async {
    List<XFile> images = await imagePicker.pickMultiImage();

    for (XFile image in images) {
      if (imageUrl.length < 6) {
        imageUrl.add(image.path);
      }
    }
  }

  sharePost({caption}) async {
    sharingPost.value = true;
    try {
      final List urls = await repository.uploadImages(imageUrl);
      final media = urls.map((e) => {"url": e, "type": "image"}).toList();

      await repository.createPost(
        media: media,
        location: address.value?.formatAddresss,
        caption: caption,
      );

      Get.offAllNamed(Routes.homeScreen);
    } catch (e) {
      handelError(e);
    } finally {
      sharingPost.value = false;
    }
  }
}
