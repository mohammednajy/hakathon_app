import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hakathon_app/api/post_api.dart';
import 'package:hakathon_app/logic/localData/shared_pref.dart';
import 'package:hakathon_app/logic/models/post_model.dart';
import 'package:hakathon_app/logic/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hakathon_app/router/app_router.dart';
import 'package:hakathon_app/router/router_name.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/app_exception.dart';
import '../../utils/helper.dart';

class PostProvider extends ChangeNotifier {
  List<PostModel> posts = [];
  bool isLoading = false;
  List<PostModel> searchPosts = [];
  int count = 0;
  bool isLoadMoreRunning = false;
  bool hasNextPage = true;
  int offset = 10;
  int limit = 10;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  cancelImage() {
    image = null;
    notifyListeners();
  }

  loadMore({
    required final String token,
  }) async {
    try {
      isLoadMoreRunning = true;
      hasNextPage = true;
      notifyListeners();
      final response =
          await PostApi.getAllPost(offset: offset, limit: limit, token: token);
      if (response.statusCode == 200) {
        final List data = response.data["data"]["posts"];
        if (data.isNotEmpty) {
          List<PostModel> moreUsers =
              data.map((e) => PostModel.fromJson(e)).toList();
          posts.addAll(moreUsers);
          notifyListeners();
        } else {
          hasNextPage = false;
          Timer(
            const Duration(seconds: 1),
            () {
              hasNextPage = true;
              notifyListeners();
            },
          );

          notifyListeners();
        }
      }

      isLoadMoreRunning = false;
      offset = posts.length;
      notifyListeners();
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      UtilsConfig.showSnackBarMessage(message: errorMessage, status: false);
    }
  }

  searchPost({required String postName}) {
    searchPosts = posts
        .where((element) =>
            element.text.toUpperCase().startsWith(postName.toUpperCase()))
        .toList();

    notifyListeners();
  }

  Future<List<PostModel>> getAllPost({required String token}) async {
    // try {
    final response =
        await PostApi.getAllPost(offset: 0, limit: 10, token: token);
    if (response.statusCode == 200) {
      List<dynamic> usersList = response.data["data"]["posts"];
      print(response.data);
      count = response.data["data"]["count"];
      for (var element in usersList) {
        posts.add(PostModel.fromJson(element));
        notifyListeners();
      }
      posts = posts.reversed.toList();
      notifyListeners();
    }
    return posts;
    // } on DioError catch (e) {

    //   final errorMessage = DioExceptions.fromDioError(e);
    //   UtilsConfig.showSnackBarMessage(message: errorMessage, status: false);
    // }
  }

  deletePost({required String token, required String id}) async {
    setLoading(true);
    try {
      Response response = await PostApi.deletePost(
        token: token,
        id: id,
      );
      if (response.statusCode == 200) {
        int index = posts.indexWhere((element) => element.sId == id);
        posts.removeAt(index);
        // notifyListeners();
        UtilsConfig.showSnackBarMessage(
            message: response.data["message"], status: true);
        setLoading(false);
      }
    } on DioError catch (e) {
      setLoading(false);
      final errorMessage = DioExceptions.fromDioError(e);
      UtilsConfig.showSnackBarMessage(message: errorMessage, status: false);
    }
  }

  addPost({
    required String token,
    required String postText,
    required File? file,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "image": file == null
            ? ""
            : await MultipartFile.fromFile(
                file.path,
                filename: 'image.png',
              ),
        "text": postText,
      });

      final Response response = await PostApi.addPost(
        token: token,
        data: formData,
      );
      if (response.statusCode == 201) {
        refreshPosts(token: token);
        UtilsConfig.showSnackBarMessage(
          message: "add successfully",
          status: true,
        );
        AppRouter.back();
      }
      // cancelImage();
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      UtilsConfig.showSnackBarMessage(message: errorMessage, status: false);
    }
  }

  editPost({
    required String token,
    required String id,
    required String text,
    required File? file,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "image": file == null
            ? ""
            : await MultipartFile.fromFile(
                file.path,
                filename: 'image.png',
              ),
        "text": text,
      });

      final Response response = await PostApi.editPost(
        id: id,
        data: formData,
        token: token,
      );
      if (response.statusCode == 200) {
        int index = posts.indexWhere((element) => element.sId == id);
        posts[index] = PostModel.fromJson(response.data["data"]);
        notifyListeners();
        UtilsConfig.showSnackBarMessage(
          message: "edit successfully",
          status: true,
        );
        AppRouter.back();
      }
    } on DioError catch (e) {
      AppRouter.back();
      final errorMessage = DioExceptions.fromDioError(e);
      UtilsConfig.showSnackBarMessage(message: errorMessage, status: false);
    }
  }

  void refreshPosts({required String token}) async {
    try {
      count++;
      notifyListeners();
      final response =
          await PostApi.getAllPost(offset: 0, limit: count + 1, token: token);
      if (response.statusCode == 200) {
        List<dynamic> usersList = response.data["data"]["posts"];

        posts.insert(0, PostModel.fromJson(usersList.last));
        notifyListeners();
      }
      // setLoading(false);
    } on DioError catch (e) {
      // setLoading(false);
      final errorMessage = DioExceptions.fromDioError(e);
      UtilsConfig.showSnackBarMessage(message: errorMessage, status: false);
    }
  }

  sharePost({
    required String id,
    required String token,
    required String email,
    required String permission,
  }) async {
    try {
      final Response response = await PostApi.sharePost(
        email: email,
        id: id,
        permission: permission,
        token: token,
      );
      if (response.statusCode == 200) {
        UtilsConfig.showSnackBarMessage(
            message: response.data["message"], status: true);
        AppRouter.back();
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      UtilsConfig.showSnackBarMessage(message: errorMessage, status: false);
    }
  }

  logout() async {
    bool? value = await UtilsConfig.showAlertDialog();

    if (value == true) {
      SharedPrefController().clear();
      posts.clear();
      AppRouter.goAndRemove(ScreenName.loginScreen);
    }
  }

  File? image;

  Future pickImage() async {
    try {
      final imageUploaded =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (imageUploaded == null) return;
      File? ima = File(imageUploaded.path);
      image = ima;
      notifyListeners();
      // AppRouter.back();
    } on Exception catch (e) {
      AppRouter.back();

      UtilsConfig.showSnackBarMessage(message: e.toString(), status: false);
    }
  }

  // String? fileName;
  // List<PlatformFile>? paths;
  // bool validFile = false;
  // late File file;
  // void pickFile() async {
  //   try {
  //     FilePickerResult result = await FilePicker.platform.pickFiles(
  //         type: FileType.custom,
  //         allowedExtensions: ['png', 'jpg']) as FilePickerResult;
  //     if (result != null) {
  //       fileName = result.files.first.name;
  //       paths = result.files;
  //       file = File(result.files.first.path!);
  //       if (paths!.first.size > 2097152) {
  //         validFile = false;
  //       } else {
  //         validFile = true;
  //       }
  //     }

  //     notifyListeners();
  //   } on Error catch (e) {
  //     UtilsConfig.showSnackBarMessage(message: e.toString(), status: false);
  //   }
  // }
}
