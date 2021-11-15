class ApiEndpoint {

  static const String BASE_URL = "http://3.128.130.247/api/v1/";
  static const String MEDIA_PATH = "http://3.128.130.247/storage/";
  static const String OPERATION_MEDIA_PATH = "http://3.128.130.247/storage/uploads/operations/";
  static const String NOTES_MEDIA_PATH = "https://serverdevelopment.s3.us-east-2.amazonaws.com/equipment_notes/";
  static const String LOCKOUT_MEDIA_PATH = "https://serverdevelopment.s3.us-east-2.amazonaws.com/lockout_videos/";
  static const String TERMS_AND_CONDITION = "http://3.128.130.247/terms_and_conditions";
  static const String FILTER_IMAGE_PATH = "http://3.128.130.247/storage/uploads/";
  static const String CONTROL_ROOM_VIDEO_PATH = "https://serverdevelopment.s3.us-east-2.amazonaws.com/";


  //static const String TERMS_AND_CONDITION = "http://3.128.130.247/terms_and_conditions";

  static const  LOGIN = 'login';
  static const  REGISTER = 'completeSignup';
  static const  LOGOUT = 'logout';
  static const  FORGET_PASSWORD = 'forgotPassword';
  static const  UPDATE_PASSWORD = 'update_password';
  static const  VERIFY_OTP_FORGET_PASSWORD = 'verifyOTP';
  static const  PLANT_CATEGORIES = 'plant_categories';
  static const  PLANT_PRODUCT_LIST = 'products_listing';
  static const  FILTER_PRODUCT_LIST = 'product_listings';
  static const  UPDATE_USER_PASSWORD = 'update_user_password';
  static const  UPDATE_USER_PROFILE = 'update_user_profile';
  static const  FETCH_PRODUCT_DETAILS_FOR_PLANT = 'fetch_product_details';
  static const  FETCH_PRODUCT_DETAILS_FOR_PLANT222 = 'new_fetch_product_details';
  static const  UPDATE_USER_LOCATION = 'update_user_location';
  static const  FETCH_LOCKOUT_DETAILS = 'fetch_lockout_details';
  static const  ADD_PRODUCT_NOTES = 'add_product_notes';
  static const  FETCH_OPERATION_SUB_CATEGORY = 'operations';
  static const  FETCH_CONTROL_ROOM_PRODUCT_DETAILS = 'fetch_opn_product_details';
  static const  FETCH_PRODUCT_DETAILS_FOR_FILTER_CHANGE = 'product_details_with_notes';


}
