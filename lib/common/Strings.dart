class Strings {
  static const String dummy = 'What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it has?';
  static const String USER = 'user';
  static const String appName = 'Archive';
  static const String version = 'Archive';
  static const String plant = "  Plant Equipment";
  static const String operations = "  Operations";
  static const String compressors = "  Compressors";
  static const String operationHeavyTask = "Operation Heavy Tasks";
  static const String coolers = "  Coolers";
  static const String pump = "  Pumps";
  static const String vessels = "  Vessels";
  static const String filters = "  Filters";
  static const String update = "update";
  static const String notUpdate = "notUpdate";
  static const String youtubeLInk = "Enter Youtube Link";
  static const String successPasswordUpdated = 'Password Successfully Updated';
  static const String successNotedAdded = 'Note Successfully Added';
  static const String successProfileUpdated = 'Profile Successfully Updated';
  static const String successRegistered = 'Registered Successfully';

  static const String tAndCondition = "T&C and Privacy Policy";
  static const String termsCondition = "Terms & Conditions";
  static const String scan = "  Scan";
  static const String changePwd = "  Change";
  static const String home = "  Home";
  static const String drawer = "  Drawer";
  static const String engine = "  Engine";
  static const String plantEquipment = "  Plant Equipment";
  static const String operation = "  Operation";
  static const String compressor = "Compressor";
  static const String viewAllNotes = "View All Notes";
  static const String addNote = "  Add Note";
  static const String newText = "New";
  static const String camera = "Camera";
  static const String gallery = "Gallery";
  static const String youtubeLink = "Youtube Link";
  static const String enterNote = "Please enter your note";
  static const String opsHeavyTask = "Operation Heavy Task";
  static const String carbonBeg = "Carbon Bed Change";
  static const String molsieveBed = "Molsieve Bed Change";
  static const String filterChange = "Filter Change";
  static const String controlRoom = "Control Room Documents";
  static const String permits = "Permits";
  static const String passDown = "Pass Down Notes";
  static const String logout = "Logout";
  static const String email = 'Your Email';
  static const String name = 'Your Name';
  static const String enterTitle = 'Please enter your title';
  static const String companyName = 'Company Name';
  static const String location = 'Location';
  static const String selectLocation = 'Select Location';
  static const String left = 'left';
  static const String right = 'right';
  static const String submit = 'Submit';
  static const String phoneNumber = 'Phone Number';
  static const String oldPassword = 'Old Password';
  static const String password = 'Password';
  static const String newPassword = 'New Password';
  static const String cPassword = 'Confirm Password';
  static const String cNewPassword = "Confirm New Password";
  static const String checkInternet = "Please check your internet connection";
  static const String rememberEmail = "rememberEmail";
  static const String profile = "profile";
  static const String forget = "forget";
  static const String cancel = "Cancel";
  static const String qrCode = "qrCode";
  static const String search = "search";
  static const String forgetPwd = "Forgot Password";
  static const String forgetPwdDesc = "Enter the email associated with your account and we'll send an email with instruction to reset your password";
  static const String rememberPassword = "rememberPassword";
  static const String passwordHint = "Password must have at least 8 characters, at least 1 uppercase, 1 lowercase,1 special symbol and 1 number";
  static const String went_wrong = "Something  went wrong. Please try again later";

  static const String textDescription = '''    What is Lorem Ipsum?
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

Why do we use it?
It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).


Where does it come from?
Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.

The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.

Where can I get some?
There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.''';


  static bool isEmail(String email) {
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
    return emailValid;
  }



  static  bool validatePassword(String value){
    bool regExp =  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value);
    return regExp;
  }

}
