import '../services/user_service.dart';
import '../utils/loading_status.dart';
import '../model/user/user_model.dart';

class UserAccessViewModel {
  UserService service = UserServiceImpl();
  var loadingStatus = LoadingStatus.loading;
  Exception userException;

  Future<void> createOrAuthenticateUser(UserModel user,
      {bool login = true}) async {
    try {
      loadingStatus = LoadingStatus.loading;
      await service.createOrAuthenticateUser(user, login: login);
      loadingStatus = LoadingStatus.completed;
    } catch (error) {
      loadingStatus = LoadingStatus.error;
      userException = error;
    }
  }

  Stream<dynamic> verifyAuthUser() {
    return service.verifyAuthUser();
  }

  Future<dynamic> signOut() {
    return service.signOut();
  }

  Future<dynamic> getCurrentUser() async {
    return await service.getCurrentUser();
  }

  Future<UserModel> getUserData() async {
    try {
      final result = await service.getUserData();
      return result;
    } catch (error) {
      throw error;
    }
  }
}
