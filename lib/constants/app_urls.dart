class AppUrls {
  static const String baseUrl = "https://api.mwalimufinder.com/api/v1";
  static const String getTeacherDetails = "$baseUrl/users/teacher/";
  static const String getNotifications = "$baseUrl/jobs/notifications/";
  static const String updateNotification =
      "$baseUrl/jobs/notifications/update/";
  static const String jobsBaseUrl = "$baseUrl/jobs/";

  // URLs for Live Profile functionality
  static const String postTeacherProfile = "$jobsBaseUrl/teacher/profile/user/";
  static const String makeProfileLive = "$baseUrl/payments/mpesa/profile/make/";
  static const String checkPaymentStatus = "$baseUrl/payments/mpesa/confirm/";
  static const String deleteTeacherProfilePost =
      "$jobsBaseUrl/teacher/profile/modify/";

  // URLs for My Jobs functionality
  static const String savedJobsUrl = "$jobsBaseUrl/saves/";
  static const String viewedJobsUrl = "$jobsBaseUrl/user/viewed/";
  static const String deleteSavedJobUrl = "$jobsBaseUrl/saves/delete/";

  // URLs for Payment functionality
  static const String paymentMethodsUrl = "$baseUrl/payments/user/methods/";
  static const String paymentUrl = "$baseUrl/payments/mpesa/view/make/";
  static const String checkPaymentStatusUrl =
      "$baseUrl/payments/mpesa/confirm/";

  // URLs for Profile functionality
  static const String userBaseUrl = "$baseUrl/users/";
  static const String countiesUrl = "$userBaseUrl/counties/";
  static const String subCountiesUrl = "$userBaseUrl/sub-scounties/list/";
  static const String changePasswordUrl = "$userBaseUrl/user/password/change/";
  static const String modifyTeacherProfileUrl = "$userBaseUrl/teacher/modify/";

  // URL for fetching school photos
  static const String schoolPhotosUrl = "$userBaseUrl/school/photos/get/";

  // URL for fetching job details
  static const String viewJobUrl = "$jobsBaseUrl/view/";
}
