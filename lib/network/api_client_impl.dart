import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'api_client.dart';

class ApiClientImpl extends ApiClient {
  ApiClientImpl(Dio dio) : super(dio);
  //
  // @override
  // Future<ApiResult<UserData>> login(
  //     {required int phone, required String password}) async {
  //   try {
  //     final url = AuthEndpoints.login;
  //     final response = await dio.post(
  //       url,
  //       data: FormData.fromMap({
  //         "phone": phone,
  //         "password": password,
  //       }),
  //     );
  //     // debugPrint(response.data.toString());
  //     final UserData userResponse = UserData.fromJson(response.data);
  //     return ApiResult.success(data: userResponse);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<UserData>> register(
  //     {required String password,
  //     required String name,
  //     required int phone}) async {
  //   try {
  //     final url = AuthEndpoints.sign_up;
  //     final response = await dio.post(
  //       url,
  //       data: FormData.fromMap(
  //         {
  //           "phone": phone,
  //           "name": name,
  //           "password": password,
  //         },
  //       ),
  //     );
  //     final UserData userResponse = UserData.fromJson(response.data);
  //     return ApiResult.success(data: userResponse);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<UserData>> getProfile() async {
  //   try {
  //     final url = AuthEndpoints.profile;
  //     final response = await dio.get(url);
  //     final UserData userResponse = UserData.fromJson(response.data);
  //     return ApiResult.success(data: userResponse);
  //   } on DioError catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<UserData>> resetPassword({required int phone}) async {
  //   try {
  //     final url = AuthEndpoints.reset_password;
  //
  //     final response = await dio.post(
  //       url,
  //       data: FormData.fromMap(
  //         {
  //           "phone": phone,
  //         },
  //       ),
  //     );
  //     final UserData userResponse = UserData.fromJson(response.data);
  //     return ApiResult.success(data: userResponse);
  //   } on DioError catch (e) {
  //     (e.response);
  //     return ApiResult.failure(
  //         error: NetworkExceptions.fromError(e.response!.data.data));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> reSendOtp({required int phone}) async {
  //   try {
  //     final url = AuthEndpoints.resend_otp;
  //
  //     await dio.post(
  //       url,
  //       data: FormData.fromMap(
  //         {
  //           "phone": phone,
  //         },
  //       ),
  //     );
  //     // debugPrint(response);
  //     return const ApiResult.success(data: true);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> verifyOtp(
  //     {required int phone, required int otp}) async {
  //   try {
  //     final url = AuthEndpoints.verify_otp;
  //     final response = await dio.post(
  //       url,
  //       data: FormData.fromMap(
  //         {
  //           "phone": phone,
  //           "otp": otp,
  //         },
  //       ),
  //     );
  //     debugPrint(response.toString());
  //     return const ApiResult.success(data: true);
  //   } on DioError catch (e) {
  //     debugPrint(e.response.toString());
  //     return ApiResult.failure(
  //       error: NetworkExceptions.fromError(e.response!.data),
  //     );
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> createNewPassword({
  //   required String newPassword,
  //   required String confirmPassword,
  // }) async {
  //   try {
  //     final url = AuthEndpoints.create_new_password;
  //
  //     final response = await dio.post(
  //       url,
  //       data: FormData.fromMap(
  //         {
  //           "new_password": newPassword,
  //           "confirm_password": confirmPassword,
  //         },
  //       ),
  //     );
  //     debugPrint(response.toString());
  //     return const ApiResult.success(data: true);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e));
  //   }
  // }
  //
  // Future<ApiResult<bool>> createPregnant({
  //   required String dob,
  //   required double height,
  //   required double weight,
  //   required String babyNamePreference,
  // }) async {
  //   try {
  //     final url = AuthEndpoints.pregnant_create;
  //
  //     final response = await dio.post(
  //       url,
  //       data: FormData.fromMap(
  //         {
  //           "dob": dob,
  //           "height": height,
  //           "weight": weight,
  //           'babyNamePreference': babyNamePreference
  //         },
  //       ),
  //     );
  //     debugPrint(response.toString());
  //     return const ApiResult.success(data: true);
  //   } on DioError catch (e) {
  //     debugPrint(e.response!.data.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e));
  //   }
  // }
  //
  // /// get specific forum
  // @override
  // Future<ApiResult<CommunityForum>> getForums() async {
  //   try {
  //     final url = CommunityForumEndPoints.mostLikedForums;
  //     final response = await dio.get(url);
  //     final CommunityForum userResponse =
  //         CommunityForum.fromJson(response.data);
  //     return ApiResult.success(data: userResponse);
  //   } on DioError catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> createForums({
  //   required String? body,
  //   String? title,
  //   List<String>? tags,
  //   List<XFile>? listOfImages,
  //   String? categoryId,
  //   String? groupId,
  // }) async {
  //   try {
  //     final url = CommunityForumEndPoints.createForum;
  //     List<dynamic> newList = [];
  //
  //     if (listOfImages!.isNotEmpty) {
  //       for (int i = 0; i < listOfImages.length; i++) {
  //         // ByteData byteData = await listOfImages[i].
  //         // List<int> ImageData = byteData.buffer.asUint8List();
  //         List<int> imageData = await listOfImages[i].readAsBytes();
  //         var multipart = MultipartFile.fromBytes(
  //           imageData,
  //           filename: listOfImages[i].path,
  //         );
  //         newList.add(multipart);
  //       }
  //     }
  //     // debugPrint(newList.toString());
  //     FormData data = FormData.fromMap({
  //       "body": body,
  //       "title": title,
  //       "category_id": categoryId,
  //       "tags[]": tags,
  //       "group_id": groupId,
  //       "question_photos[]": newList,
  //     });
  //     // debugPrint("here".toString());
  //     final response = await dio.post(
  //       url,
  //       data: data,
  //     );
  //     debugPrint(response.data.toString());
  //     return const ApiResult.success(data: true);
  //   } on DioError catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> answerOnForum({
  //   required String body,
  //   required String forumId,
  //   List<XFile>? listOfImages,
  // }) async {
  //   try {
  //     final url = CommunityForumEndPoints.answerToForum;
  //     final response = await dio.post(
  //       url,
  //       data: FormData.fromMap({
  //         "forum_id": forumId,
  //         "body": body,
  //         // "answer_photos[]": await MultipartFile.fromFile(
  //         //   listOfImages.path,
  //         //   filename: listOfImages.name,
  //         // ),
  //       }),
  //     );
  //     // debugPrint(response.data.toString());
  //     return const ApiResult.success(data: true);
  //   } on DioError catch (e) {
  //     // debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> replyToAnswer({
  //   required String body,
  //   required String answerId,
  //   List<XFile>? listOfImages,
  // }) async {
  //   try {
  //     final url = CommunityForumEndPoints.replyToAnswer;
  //     final response = await dio.post(
  //       url,
  //       data: FormData.fromMap({
  //         "answer_id": answerId,
  //         "body": body,
  //         // "reply_photos[]": await MultipartFile.fromFile(
  //         //   listOfImages.path,
  //         //   filename: listOfImages.name,
  //         // ),
  //       }),
  //     );
  //     debugPrint(response.data.toString());
  //     return const ApiResult.success(data: true);
  //   } on DioError catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<Groups>> getGroups() async {
  //   try {
  //     final url = GroupsEndPoints.getGroups;
  //     final response = await dio.get(
  //       url,
  //     );
  //     final Groups groupsResult = Groups.fromJson(response.data);
  //     debugPrint(response.data.toString());
  //     return ApiResult.success(data: groupsResult);
  //   } on DioError catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<GroupForums>> getGroupForums(String id) async {
  //   try {
  //     final url = GroupsEndPoints.getGroupForums(id);
  //     final response = await dio.get(
  //       url,
  //     );
  //     final GroupForums groupsResult = GroupForums.fromJson(response.data);
  //     debugPrint(response.data.toString());
  //     return ApiResult.success(data: groupsResult);
  //   } on DioError catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<Categories>> getCategories() async {
  //   try {
  //     final url = CategoriesEndPoints.getCategories;
  //     final response = await dio.get(
  //       url,
  //     );
  //     final Categories categoriesResult = Categories.fromJson(response.data);
  //     // debugPrint(response.data.toString());
  //     return ApiResult.success(data: categoriesResult);
  //   } on DioError catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> likeForum({required String forumId}) async {
  //   try {
  //     final url = CommunityForumEndPoints.likeForum;
  //     await dio.post(
  //       '$url/$forumId',
  //     );
  //     // debugPrint(response.data.toString());
  //     return const ApiResult.success(data: true);
  //   } on DioError catch (e) {
  //     // debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> likeForumAnswer({required String answerId}) async {
  //   try {
  //     final url = CommunityForumEndPoints.likeForumAnswer;
  //     await dio.post(
  //       '$url/$answerId',
  //     );
  //     // debugPrint(response.data.toString());
  //     return const ApiResult.success(data: true);
  //   } on DioError catch (e) {
  //     // debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> likeForumAnswerReply(
  //     {required String replyId}) async {
  //   try {
  //     final url = CommunityForumEndPoints.likeForumAnswerReply;
  //     await dio.post(
  //       '$url/$replyId',
  //     );
  //     // debugPrint(response.data.toString());
  //     return const ApiResult.success(data: true);
  //   } on DioError catch (e) {
  //     // debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<SingleCategoryForums>> getForumByCategory(
  //     {required String categoryId}) async {
  //   try {
  //     final url = CommunityForumEndPoints.getForumByCategory;
  //     final response = await dio.get('$url/$categoryId');
  //
  //     debugPrint(response.data.toString());
  //
  //     final SingleCategoryForums userResponse =
  //         SingleCategoryForums.fromJson(response.data);
  //
  //     return ApiResult.success(data: userResponse);
  //   } on DioError catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<ReportReason>> getReportReasons() async {
  //   try {
  //     final url = ReportEndpoints.getReportReasons;
  //     final response = await dio.get(url);
  //
  //     debugPrint(response.data.toString());
  //
  //     final ReportReason reportReasonResponse =
  //         ReportReason.fromJson(response.data);
  //
  //     return ApiResult.success(data: reportReasonResponse);
  //   } on DioError catch (e) {
  //     debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> reportQuestion({
  //   required String questionId,
  //   required String reportReasonId,
  //   String? explanation,
  // }) async {
  //   try {
  //     final url = ReportEndpoints.reportQuestion(questionId);
  //     await dio.post(
  //       url,
  //       data: FormData.fromMap(
  //         {
  //           'report_reason_id': reportReasonId,
  //           'explanation': explanation,
  //         },
  //       ),
  //     );
  //     // debugPrint(response.data.toString());
  //     return const ApiResult.success(data: true);
  //   } on DioError catch (e) {
  //     // debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> reportQuestionAnswer({
  //   required String questionAnswerId,
  //   required String reportReasonId,
  //   String? explanation,
  // }) async {
  //   try {
  //     final url = ReportEndpoints.reportQuestionAnswer(questionAnswerId);
  //     await dio.post(
  //       url,
  //       data: FormData.fromMap(
  //         {
  //           'report_reason_id': reportReasonId,
  //           'explanation': explanation,
  //         },
  //       ),
  //     );
  //     // debugPrint(response.data.toString());
  //     return const ApiResult.success(data: true);
  //   } on DioError catch (e) {
  //     // debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
  //
  // @override
  // Future<ApiResult<bool>> reportQuestionAnswerReply({
  //   required String questionAnswerReplyId,
  //   required String reportReasonId,
  //   String? explanation,
  // }) async {
  //   try {
  //     final url =
  //         ReportEndpoints.reportQuestionAnswerReply(questionAnswerReplyId);
  //     await dio.post(
  //       url,
  //       data: FormData.fromMap(
  //         {
  //           'report_reason_id': reportReasonId,
  //           'explanation': explanation,
  //         },
  //       ),
  //     );
  //     // debugPrint(response.data.toString());
  //     return const ApiResult.success(data: true);
  //   } on DioError catch (e) {
  //     // debugPrint(e.toString());
  //     return ApiResult.failure(error: NetworkExceptions.fromError(e.response));
  //   }
  // }
}
