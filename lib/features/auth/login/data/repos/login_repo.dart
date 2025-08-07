
import '../../../../../core/constants/endpoint_constants.dart';
import '../../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

class LoginRepo
{
  final dio = DioClient();

  Future<UserModel> login(String email, String password) async{
    final response = await dio.post(
      EndpointConstants.login,
      queryParameters: {
        "email": email.toString(),
        "password": password.toString(),
      },
    );

    if (response.statusCode == 200 && response.data['status'] == "success") {
      return UserModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.data['message'] ?? "Unknown error");
    }
  }
}