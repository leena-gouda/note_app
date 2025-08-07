import '../../../../../core/constants/endpoint_constants.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../login/data/models/user_model.dart';

class SignUpRepo {
  final dio = DioClient();

  Future<UserModel> signUp(
      String username,
      String email,
      String password,
      ) async {
    final response = await dio.post(
      EndpointConstants.register,
      queryParameters: {
        "username": username,
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200 && response.data['status'] == "success") {
      return UserModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.data['message'] ?? "Unknown error");
    }
  }
}