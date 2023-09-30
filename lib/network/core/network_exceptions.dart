import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exceptions.freezed.dart';

@freezed
class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorizedRequest(String? errorMessage) = UnauthorizedRequest;

  const factory NetworkExceptions.badRequest(String errorMessage) = BadRequest;

  const factory NetworkExceptions.notFound(String errorMessage) = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError(String errorMessage) = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  factory NetworkExceptions.create(int statusCode, String? errorMessage) {
    switch (statusCode) {
      case 400:
        return NetworkExceptions.badRequest(errorMessage ?? 'Bad request');
      case 401:
      case 403:
        return NetworkExceptions.unauthorizedRequest(errorMessage);
      case 404:
        return NetworkExceptions.notFound(errorMessage ?? 'Resource not found');
      case 409:
        return const NetworkExceptions.conflict();
      case 408:
        return const NetworkExceptions.requestTimeout();
      case 500:
        return NetworkExceptions.internalServerError(
            errorMessage ?? 'Sorry, we failed to process your request. Please try again.');
      case 503:
        return const NetworkExceptions.serviceUnavailable();
      default:
        return NetworkExceptions.defaultError(
          'Received invalid status code: $statusCode',
        );
    }
  }

  factory NetworkExceptions.fromError(dynamic error) {
    if (error is Exception) {
      try {
        NetworkExceptions? networkExceptions;
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.unknown:
              networkExceptions = const NetworkExceptions.noInternetConnection();
              break;
            case DioExceptionType.cancel:
              networkExceptions = const NetworkExceptions.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badResponse:
              dynamic errMsg = error.response?.data['message'];

              if (errMsg is String?) {
                errMsg = errMsg;
              } else if (errMsg is List) {
                // might have a different format
                List<String> errorMsgs = List<String>.from(error.response?.data['message']);
                errMsg = errorMsgs.join(',');
              }

              networkExceptions = NetworkExceptions.create(
                error.response!.statusCode!,
                errMsg,
              );
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badCertificate:
            // TODO: Handle this case.
              break;
            default:
              networkExceptions = const NetworkExceptions.noInternetConnection();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = const NetworkExceptions.noInternetConnection();
        } else {
          debugPrint(error.toString());
          networkExceptions = const NetworkExceptions.unexpectedError();
        }
        return networkExceptions!;
      } on FormatException catch (_) {
        return const NetworkExceptions.formatException();
      } catch (e) {
        debugPrint(e.toString());
        return const NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains('is not a subtype of')) {
        return const NetworkExceptions.unableToProcess();
      } else {
        debugPrint(error?.toString());
        return const NetworkExceptions.unexpectedError();
      }
    }
  }

  static String getErrorMessage(NetworkExceptions networkExceptions) {
    return networkExceptions.when(notImplemented: () {
      return 'Not Implemented';
    }, requestCancelled: () {
      return 'Request Cancelled';
    }, internalServerError: (String errorMessage) {
      return errorMessage;
    }, notFound: (String errorMessage) {
      return errorMessage;
    }, serviceUnavailable: () {
      return 'Service unavailable';
    }, methodNotAllowed: () {
      return 'Method Allowed';
    }, badRequest: (String errorMessage) {
      return errorMessage;
    }, unauthorizedRequest: (errorMessage) {
      return errorMessage ?? 'Unauthorized request';
    }, unexpectedError: () {
      return 'Unexpected error occurred';
    }, requestTimeout: () {
      return 'Connection request timeout';
    }, noInternetConnection: () {
      return 'No internet connection';
    }, conflict: () {
      return 'Error due to a conflict';
    }, sendTimeout: () {
      return 'Send timeout in connection with API server';
    }, unableToProcess: () {
      return 'Unable to process the data';
    }, defaultError: (String error) {
      return error;
    }, formatException: () {
      return 'Failed to parse server response';
    }, notAcceptable: () {
      return 'Not acceptable';
    });
  }
}
