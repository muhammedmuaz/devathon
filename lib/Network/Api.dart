import 'dart:async';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:devathon/Network/appExceptions.dart';
import 'package:devathon/Network/enviroment.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

final String baseUrl = Environment().config.baseUrl;
final String apiUrl = Environment().config.apiUrl;
final String apiClone = Environment().config.apiUrlClone;

class Api {
  var sp = GetStorage();

  Future<dynamic> get(String url, {fullUrl, auth}) async {
    Dio dio = Dio();

    if (auth != null) {
      dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
    }
    try {
      var response = await dio.get(
        fullUrl ?? '$apiUrl$url',
      );
      if (response.data != null) {
        return response;
      } else {
        print("error icon");
        errorIcon(response.data['error']);
        return response;
      }
    } on SocketException catch (e) {
      return errorIcon(e.message.toString());
    } on DioException catch (e) {
      print("error dio");
      print(e.response!.data);
      return errorIcon(e.response!.data['error']);
    }
  }

  Future<dynamic> post(formData, url,
      {fullUrl, auth = false, multiPart = false}) async {
    Dio dio = Dio();
    if (auth == false) {
      // print(sp.read('token'));
      dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
    }
    try {
      print('$apiUrl$url');
      var response = await dio.post(
        fullUrl ?? '$apiUrl$url',
        data: formData,
        options: multiPart == true
            ? Options(
                headers: {
                  Headers.acceptHeader: "application/json",
                },
                contentType: 'multipart/form-data',
              )
            : Options(
                headers: {
                  Headers.acceptHeader: "application/json",
                },
              ),
      );
      if (response.data != null) {
        return response;
      } else {
        print(response.data);
        errorIcon(response.data);
        return response;
      }
    } on SocketException catch (e) {
      return errorIcon(e.message.toString());
    } on DioException catch (e) {
      print(e.response!.statusCode);
      print(e.error);
      print(e);
      if (e.response != null) {
        print("It is here");
        await _returnResponse(e.response!);
      } else {
        throw FetchDataException("Error during communication: ${e.message}");
      }
      // print(e.response!.data);
    }
  }

// Put
  Future<dynamic> put(url,
      {fullUrl, auth = false, multiPart = false, formData}) async {
    Dio dio = Dio();
    if (auth == false) {
      // Assuming you have a token stored in the 'token' variable
      dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
    }
    try {
      print('$apiUrl$url');
      var response = await dio.put(
        fullUrl ?? '$apiUrl$url',
        data: formData,
        options: multiPart == true
            ? Options(
                headers: {
                  Headers.acceptHeader: "application/json",
                },
                contentType: 'multipart/form-data',
              )
            : Options(
                headers: {
                  Headers.acceptHeader: "application/json",
                },
              ),
      );
      if (response.data != null) {
        return response;
      } else {
        errorIcon(response.data);
        return response;
      }
    } on SocketException catch (e) {
      return errorIcon(e.message.toString());
    } on DioException catch (e) {
      print(e.response!);
      print(e);
      print(e.response!.data);
      return errorIcon(e.response!);
    }
  }

  dynamic _returnResponse(Response response) {
    if (response.statusCode == 400) {
      throw BadRequestException(response.data.toString());
    } else if (response.statusCode == 401) {
      throw UnauthorisedException(response.data.toString());
    } else if (response.statusCode == 422) {
      throw UserAlreadyExistsException(response.data["error"]);
    } else {
      throw FetchDataException("Error during communication with the server");
    }
  }

  errorIcon(message) async {
    Timer(const Duration(seconds: 3), () {});
    if (message.runtimeType == String) {
      BotToast.showText(text: message);
    } else {
      BotToast.showText(
          duration: const Duration(seconds: 3), text: message['error']);
    }
  }
}
