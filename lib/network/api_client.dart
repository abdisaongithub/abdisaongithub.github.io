import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'core/core.dart';

abstract class ApiClient {
  final Dio _dio;
  String? _authToken;

  String? get authToken => _authToken;

  Dio get dio => _dio;

  bool get isAuthenticated => _authToken != null;

  set authToken(String? token) {
    // debugPrint('Setting ApiClient token: $token');
    _authToken = token;
    // debugPrint(_authToken);
  }

  ApiClient(this._dio) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          final body = options.data;

          if (body != null) {
            // debugPrint('Request Body:$body');
          }
          options.followRedirects = false;
          // // will not throw errors
          options.validateStatus = (status) => true;
          // print(options);
          return handler.next(options);
        },
        onResponse: (option, handler) {
          return handler.next(option);
        },
        onError: (err, option) {
          // print('error :${err}');
          return option.next(err);
        },
      ),
    );
  }

//   Future<ApiResult<UserData>> login(
//       {required int phone, required String password});
//
//   Future<ApiResult<UserData>> register({
//     required String password,
//     required String name,
//     required int phone,
//   });
//
//   Future<ApiResult<UserData>> getProfile();
//
//   Future<ApiResult<UserData>> resetPassword({required int phone});
//
//   Future<ApiResult<bool>> reSendOtp({required int phone});
//
//   Future<ApiResult<bool>> verifyOtp({required int phone, required int otp});
//
//   Future<ApiResult<bool>> createNewPassword(
//       {required String newPassword, required String confirmPassword});
//
//   Future<ApiResult<bool>> createPregnant({
//     required String dob,
//     required double height,
//     required double weight,
//     required String babyNamePreference,
//   });
//
//   ///Forum Api calls
//   Future<ApiResult<bool>> createForums({
//     required String body,
//     String? title,
//     List<String>? tags,
//     List<XFile>? listOfImages,
//     String categoryId,
//     String? groupId,
//   });
//
//   Future<ApiResult<bool>> answerOnForum({
//     required String body,
//     required String forumId,
//     List<XFile>? listOfImages,
//   });
//
//   Future<ApiResult<bool>> replyToAnswer({
//     required String body,
//     required String answerId,
//     List<XFile>? listOfImages,
//   });
//
//   Future<ApiResult<CommunityForum>> getForums();
// // Future<ApiResult<SpecificForum>> getForum({required String id});
//
//   /// get Groups
//   Future<ApiResult<Groups>> getGroups();
//
//   Future<ApiResult<GroupForums>> getGroupForums(String id);
//
//   /// get categories
//   Future<ApiResult<Categories>> getCategories();
//
//   /// Like
//   Future<ApiResult<bool>> likeForum({required String forumId});
//
//   Future<ApiResult<bool>> likeForumAnswer({required String answerId});
//
//   Future<ApiResult<bool>> likeForumAnswerReply({required String replyId});
//
//   Future<ApiResult<SingleCategoryForums>> getForumByCategory(
//       {required String categoryId});
//
//   /// Report
//   Future<ApiResult<ReportReason>> getReportReasons();
//
//   Future<ApiResult<bool>> reportQuestion({
//     required String questionId,
//     required String reportReasonId,
//     String? explanation,
//   });
//
//   Future<ApiResult<bool>> reportQuestionAnswer({
//     required String questionAnswerId,
//     required String reportReasonId,
//     String? explanation,
//   });
//
//   Future<ApiResult<bool>> reportQuestionAnswerReply({
//     required String questionAnswerReplyId,
//     required String reportReasonId,
//     String? explanation,
//   });
}
