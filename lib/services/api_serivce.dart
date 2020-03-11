import 'package:dio/dio.dart';
import 'package:flutter_images_task/models/failure_model.dart';
import 'package:flutter_images_task/models/image_model.dart';

class ApiService {
  Dio _dio = Dio();
  //default page limit
  static const kLimit = 25;
  static const kBaseUrl = 'https://picsum.photos/v2/';
  static const kImageListEndPoint = 'list';
  String grayscaleImageUrl(String id) =>
      'https://picsum.photos/id/$id/500/?grayscale';
  String imageInfoByIdUrl(String id) => 'https://picsum.photos/id/$id/info';

  Future<List<ImageModel>> getColorfulImages(int pageNo) async {
    Map<String, dynamic> map = Map();
    map['page'] = pageNo.toString();
    map['limit'] = kLimit.toString();
    try {
      var response =
          await _dio.get(kBaseUrl + kImageListEndPoint, queryParameters: map);
      List<ImageModel> list = List();

      List<dynamic> resList = response.data;
      resList.forEach((res) {
        ImageModel model = ImageModel.fromJson(res);
        model.grayscaleDownloadUrl = grayscaleImageUrl(model.id);
        list.add(model);
      });

      return list;
    } on DioError catch (e) {
      throw Failure(e.error.message);
    } catch (e) {
      throw Failure(e.response.data['message']);
    }
  }

  Future<ImageModel> getImageInfo(String id) async {
    try {
      var response = await _dio.get(imageInfoByIdUrl(id));
      ImageModel model = ImageModel();

      model = ImageModel.fromJson(response.data);
      model.grayscaleDownloadUrl = grayscaleImageUrl(model.id);

      return model;
    } on DioError catch (e) {
      throw Failure(e.error.message);
    } catch (e) {
      throw Failure(e.response.data['message']);
    }
  }
}
