import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hakathon_app/api/post_api.dart';
import 'package:hakathon_app/logic/models/post_model.dart';
import 'package:hakathon_app/logic/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hakathon_app/router/app_router.dart';

import '../../api/app_exception.dart';
import '../../utils/helper.dart';

class PostProvider extends ChangeNotifier {
  List<PostModel> posts = [];
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void getAllPost({required String token}) async {
    try {
      final response =
          await PostApi.getAllPost(offset: 0, limit: 10, token: token);
      if (response.statusCode == 200) {
        List<dynamic> usersList = response.data["data"]["posts"];

        for (var element in usersList) {
          posts.add(PostModel.fromJson(element));
        }
        posts = posts.reversed.toList();
        notifyListeners();
      }
      // setLoading(false);
    } on DioError catch (e) {
      // setLoading(false);
      final errorMessage = DioExceptions.fromDioError(e);
      UtilsConfig.showSnackBarMessage(message: errorMessage, status: false);
    }
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
    // required File file,
  }) async {
    // String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      // "image": await MultipartFile.fromFile(
      //   file.path,
      //   filename: paths!.first.name,
      // ),
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
  }

  editPost({
    required String token,
    required String id,
    required String text,
    // required File file,
  }) async {
    final Response response = await PostApi.editPost(
      id: id,
      text: text,
      token: token,
    );
    if (response.statusCode == 200) {
      int index = posts.indexWhere((element) => element.sId == id);
      posts[index] = PostModel.fromJson(response.data["data"]);
      notifyListeners();
      UtilsConfig.showSnackBarMessage(
        message: "add successfully",
        status: true,
      );
      AppRouter.back();
    }
  }

  void refreshPosts({required String token}) async {
    try {
      final response =
          await PostApi.getAllPost(offset: 0, limit: 10, token: token);
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
    final Response response = await PostApi.sharePost(
      email: email,
      id: id,
      permission: permission,
      token: token,
    );
    if (response.statusCode == 200) {
      print(response.data);
    }
  }

  String? fileName;
  List<PlatformFile>? paths;
  bool validFile = false;
  late File file;
  void pickFile() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg']) as FilePickerResult;
      if (result != null) {
        fileName = result.files.first.name;
        paths = result.files;
        file = File(result.files.first.path!);
        if (paths!.first.size > 2097152) {
          validFile = false;
        } else {
          validFile = true;
        }
      }

      notifyListeners();
    } on Error catch (e) {
      UtilsConfig.showSnackBarMessage(message: e.toString(), status: false);
    }
  }
}