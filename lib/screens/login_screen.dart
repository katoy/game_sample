import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/constants.dart';
import '/utils/custom_route.dart';
import '/screens/namer_screen.dart';
import '/auth_service.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';
  static final AuthService _authService = AuthService();

  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _registerUser(SignupData data) {
    if (kDebugMode) {
      print('Email: ${data.name}, Password: ${data.password}');
    }
    return Future.delayed(loginTime).then((_) async {
      if (data.name == null || data.password == null) {
        return 'メールアドレスまたはパスワードが入力されていません。';
      }
      var userCredential =
          await _authService.signUp(data.name!, data.password!);
      if (userCredential == null) {
        return 'メールアドレスがすでに登録されているか、無効です。';
      }
      return null;
    });
  }

  Future<String?> _authUser(LoginData data) {
    if (kDebugMode) {
      print('Email: ${data.name}, Password: ${data.password}');
    }
    return Future.delayed(loginTime).then((_) async {
      // ignore: unnecessary_null_comparison
      if (data.name == null) {
        return 'メールアドレスまたはパスワードが入力されていません。';
      }
      var userCredential = await _authService.signIn(data.name, data.password);
      if (userCredential == null) {
        return 'メールアドレスまたはパスワードが間違っています。';
      }
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    //
    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);

    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: Constants.appName,
      logo: const AssetImage('assets/images/app.png'),
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      onConfirmRecover: _signupConfirm,
      onConfirmSignup: _signupConfirm,
      loginAfterSignUp: false,
      loginProviders: [
        // google
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            debugPrint('start google sign in');
            await Future.delayed(loginTime);

            GoogleAuthProvider googleProvider = GoogleAuthProvider();
            UserCredential uc =
                await FirebaseAuth.instance.signInWithPopup(googleProvider);

            debugPrint('stop gogle sign in');
            if (uc.user == null) {
              return "error";
            }
            return null;
          },
        ),
        // github
        LoginProvider(
          icon: FontAwesomeIcons.githubAlt,
          label: 'github',
          callback: () async {
            debugPrint('start github sign in');
            await Future.delayed(loginTime);

            GithubAuthProvider githubProvider = GithubAuthProvider();
            UserCredential uc =
                await FirebaseAuth.instance.signInWithPopup(githubProvider);

            debugPrint('stop github sign in');
            if (uc.user == null) {
              return "error";
            }
            return null;
          },
        ),
        // twitter
        LoginProvider(
          icon: FontAwesomeIcons.twitter,
          label: 'twitter',
          callback: () async {
            debugPrint('start twitter sign in');
            await Future.delayed(loginTime);

            TwitterAuthProvider twitterProvider = TwitterAuthProvider();
            UserCredential uc =
                await FirebaseAuth.instance.signInWithPopup(twitterProvider);

            debugPrint('stop twitter sign in');
            if (uc.user == null) {
              return "error";
            }
            return null;
          },
        ),
        // line
        LoginProvider(
          icon: FontAwesomeIcons.line,
          label: 'line',
          callback: () async {
            debugPrint('start line sign in');
            await Future.delayed(loginTime);
            debugPrint('stop line sign in');
            return null;
          },
        ),
      ],
      termsOfService: [
        TermOfService(
          id: 'newsletter',
          mandatory: false,
          text: 'Newsletter subscription',
        ),
        TermOfService(
          id: 'general-term',
          mandatory: true,
          text: 'Term of services',
          linkUrl: 'https://github.com/NearHuscarl/flutter_login',
        ),
      ],
      additionalSignupFields: [
        const UserFormField(
          keyName: 'Username',
          icon: Icon(FontAwesomeIcons.userLarge),
        ),
        const UserFormField(keyName: 'Name'),
        const UserFormField(keyName: 'Surname'),
        UserFormField(
          keyName: 'phone_number',
          displayName: 'Phone Number',
          userType: LoginUserType.phone,
          fieldValidator: (value) {
            final phoneRegExp = RegExp(
              '^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}\$',
            );
            if (value != null &&
                value.length < 7 &&
                !phoneRegExp.hasMatch(value)) {
              return "This isn't a valid phone number";
            }
            return null;
          },
        ),
      ],
      scrollable: true,
      theme: LoginTheme(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.yellow,
        errorColor: Colors.deepOrange,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Quicksand',
          letterSpacing: 4,
        ),
      ),

      messages: LoginMessages(
          userHint: 'foo@example.com',
          passwordHint: 'パスワード',
          confirmPasswordHint: 'パスワード確認',
          loginButton: 'ログイン',
          signupButton: '登録',
          forgotPasswordButton: 'パスワードを忘れましたか？',
          recoverPasswordButton: 'ヘルプ',
          goBackButton: '戻る',
          confirmPasswordError: '一致しません',
          recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
          recoverPasswordDescription:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
          recoverPasswordSuccess: 'パスワードをリセットしました',
          flushbarTitleError: 'Oh no!',
          flushbarTitleSuccess: 'Succes!',
          providersTitleFirst: 'あるいは以下でログイン'),

      // scrollable: true,
      // hideProvidersTitle: false,
      // loginAfterSignUp: false,
      // hideForgotPasswordButton: true,
      // hideSignUpButton: true,
      // disableCustomPageTransformer: true,
      // messages: LoginMessages(
      //   userHint: 'User',
      //   passwordHint: 'Pass',
      //   confirmPasswordHint: 'Confirm',
      //   loginButton: 'LOG IN',
      //   signupButton: 'REGISTER',
      //   forgotPasswordButton: 'Forgot huh?',
      //   recoverPasswordButton: 'HELP ME',
      //   goBackButton: 'GO BACK',
      //   confirmPasswordError: 'Not match!',
      //   recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
      //   recoverPasswordDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
      //   recoverPasswordSuccess: 'Password rescued successfully',
      //   flushbarTitleError: 'Oh no!',
      //   flushbarTitleSuccess: 'Succes!',
      //   providersTitle: 'login with'
      // ),
      // theme: LoginTheme(
      //   primaryColor: Colors.teal,
      //   accentColor: Colors.yellow,
      //   errorColor: Colors.deepOrange,
      //   pageColorLight: Colors.indigo.shade300,
      //   pageColorDark: Colors.indigo.shade500,
      //   logoWidth: 0.80,
      //   titleStyle: TextStyle(
      //     color: Colors.greenAccent,
      //     fontFamily: 'Quicksand',
      //     letterSpacing: 4,
      //   ),
      //   // beforeHeroFontSize: 50,
      //   // afterHeroFontSize: 20,
      //   bodyStyle: TextStyle(
      //     fontStyle: FontStyle.italic,
      //     decoration: TextDecoration.underline,
      //   ),
      //   textFieldStyle: TextStyle(
      //     color: Colors.orange,
      //     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
      //   ),
      //   buttonStyle: TextStyle(
      //     fontWeight: FontWeight.w800,
      //     color: Colors.yellow,
      //   ),
      //   cardTheme: CardTheme(
      //     color: Colors.yellow.shade100,
      //     elevation: 5,
      //     margin: EdgeInsets.only(top: 15),
      //     shape: ContinuousRectangleBorder(
      //         borderRadius: BorderRadius.circular(100.0)),
      //   ),
      //   inputTheme: InputDecorationTheme(
      //     filled: true,
      //     fillColor: Colors.purple.withOpacity(.1),
      //     contentPadding: EdgeInsets.zero,
      //     errorStyle: TextStyle(
      //       backgroundColor: Colors.orange,
      //       color: Colors.white,
      //     ),
      //     labelStyle: TextStyle(fontSize: 12),
      //     enabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //     errorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedErrorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
      //       borderRadius: inputBorder,
      //     ),
      //     disabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.grey, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //   ),
      //   buttonTheme: LoginButtonTheme(
      //     splashColor: Colors.purple,
      //     backgroundColor: Colors.pinkAccent,
      //     highlightColor: Colors.lightGreen,
      //     elevation: 9.0,
      //     highlightElevation: 6.0,
      //     shape: BeveledRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
      //     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      //   ),
      // ),
      userValidator: (value) {
        if (!value!.contains('@')) {
          return "Email must contain '@'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: _authUser,
      onSignup: _registerUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          FadePageRoute(
            builder: (context) => const NamerScreen(),
          ),
        );
      },
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      headerWidget: const IntroWidget(),
    );
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "You are trying to login/sign up on server hosted on ",
              ),
              TextSpan(
                text: "example.com",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          textAlign: TextAlign.justify,
        ),
        Row(
          children: <Widget>[
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("認証"),
            ),
            Expanded(child: Divider()),
          ],
        ),
      ],
    );
  }
}
