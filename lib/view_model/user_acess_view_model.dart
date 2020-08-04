import '../services/avalia_app_service.dart';
import '../utils/loading_status.dart';
import '../model/user_model.dart';

class UserAccessViewModel {
  AvaliaAppService service = AvaliaAppServiceImpl();
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

  Future<void> signOut() {
    return service.signOut();
  }
}
