
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni_links/uni_links.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/screen/PlantAndOperationScreen_5.dart';
import 'package:zacharchive_flutter/screen/RegisterScreen_3.dart';
import 'package:zacharchive_flutter/screen/WelcomScreen_1.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';


class SplashController extends GetxController {

  bool _initialUriIsHandled = false;





  @override
  void onInit() {
    super.onInit();

    3.delay(() {
    _handleInitialUri();
    _handleIncomingLinks();

    });




  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {

    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
     // '_handleInitialUri called'.toast();
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no_initial uri');
         //'no_url'.toast();


          //if user is already logged in
          if(await checkLoginStatus())
            PlantAndOperationScreen().navigate(isRemove:true);
          else
            WelcomeScreen().navigate(isRemove:true);


        } else {
          print('got_initial uri: $uri');
          //"uriFound".toString().toast();

          final queryParams = uri.queryParametersAll.entries.toList();

          print('querPrarams'+queryParams.toString());

          //if user is already logged in
          if(await checkLoginStatus())
            PlantAndOperationScreen().navigate(isRemove:true);
          else
          RegisterScreen(uri.toString()).navigate(isRemove:true);


        }
      //  if (!mounted) return;
      //  setState(() => _initialUri = uri);
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
       // 'falied to get initial uri'.toast();
      } on FormatException catch (err) {
       // if (!mounted) return;
        print('malformed initial uri');
       // 'malformed initial uri'.toast();
      }
    }
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  Future<void> _handleIncomingLinks() async {
    if (!kIsWeb) {

      StreamSubscription _sub;

      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri)async {
      //  if (!mounted) return;
        print('got_uri: $uri');
        //'gotUri'.toast();
        final queryParams = uri?.queryParametersAll.entries.toList();

        //if user is already logged in
        if(await checkLoginStatus())
          PlantAndOperationScreen().navigate(isRemove:true);
        else
        RegisterScreen(uri.toString()).navigate(isRemove:true);

      }, onError: (Object err) {
       // if (!mounted) return;
        print('got err: $err');

      });
    }
  }


  Future<bool> checkLoginStatus() async {

      var user = await getUser();

      if (user == null)
    return false;

      return true;
  }


}


