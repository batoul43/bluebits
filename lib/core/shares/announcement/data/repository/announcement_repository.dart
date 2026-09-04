import 'package:bluebits_app/core/shares/announcement/data/api_service/announcement_api_service.dart';
import 'package:bluebits_app/core/shares/announcement/data/models/annnouncement_models.dart';

class AnnouncementRepository {
  final AnnouncementApiService apiService;

  AnnouncementRepository(this.apiService);

  // جلب جميع الإعلانات
  Future<AnnouncementResponse> getAllAnnouncements(String token) async {
    final response = await apiService.getAllAnnouncements(token);
    print('-------------------------------------------');
    print('repoAnnouncement - GetAll: $response');
    print('-------------------------------------------');
    return AnnouncementResponse.fromJson(response);
  }

  // إنشاء إعلان جديد
  Future<AnnouncementResponse> createAnnouncement(
    String token,
    String title,
    String content,
    String yearId,
  ) async {
    final response = await apiService.createAnnouncement(
      token,
      title,
      content,
      yearId,
    );
    print('-------------------------------------------');
    print('repoAnnouncement - Create: $response');
    print('-------------------------------------------');
    return AnnouncementResponse.fromJson(response);
  }

  // جلب إعلان بواسطة المعرف (ID)
  Future<AnnouncementResponse> getAnnouncementById(
    String token,
    String announcementId,
  ) async {
    final response = await apiService.getAnnouncementById(
      token,
      announcementId,
    );
    print('-------------------------------------------');
    print('repoAnnouncement - GetById: $response');
    print('-------------------------------------------');
    return AnnouncementResponse.fromJson(response);
  }

  // تحديث إعلان موجود
  Future<AnnouncementResponse> updateAnnouncement(
    String token,
    String announcementId, {
    String? title,
    String? content,
    String? yearId,
  }) async {
    final response = await apiService.updateAnnouncement(
      token,
      announcementId,
      title: title,
      content: content,
      yearId: yearId,
    );
    print('-------------------------------------------');
    print('repoAnnouncement - Update: $response');
    print('-------------------------------------------');
    return AnnouncementResponse.fromJson(response);
  }

  // حذف إعلان
  Future<AnnouncementResponse> deleteAnnouncement(
    String token,
    String announcementId,
  ) async {
    final response = await apiService.deleteAnnouncement(token, announcementId);
    print('-------------------------------------------');
    print('repoAnnouncement - Delete: $response');
    print('-------------------------------------------');
    return AnnouncementResponse.fromJson(response);
  }
}
