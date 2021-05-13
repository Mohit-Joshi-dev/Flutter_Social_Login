import 'dart:convert';
import 'package:social_login/social_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

class LoginPage extends HookWidget {
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  Widget build(BuildContext context) {
    final _message = useState('Log in/out by pressing the buttons below.');
    final profile = useState('');
    _showMessage(String message) {
      _message.value = message;
      print(message);
    }

    ;
    final _login = () async {
      final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = result.accessToken;
          _showMessage('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
          final token = result.accessToken.token;
          final graphResponse = await http.get(Uri.parse(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
          final Map<String, dynamic> profileData =
              json.decode(graphResponse.body);
          print(profileData['name']);
          profile.value = profileData['name'];
          break;
        case FacebookLoginStatus.cancelledByUser:
          _showMessage('Login cancelled by the user.');
          break;
        case FacebookLoginStatus.error:
          _showMessage('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          break;
      }
    };

    final _logOut = () async {
      await facebookSignIn.logOut();
      _showMessage('Logged out.');
    };

    final signIn = useMemoized(
      () => setupGoogleSignIn(
        scopes: [
          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      ),
    );

    final accessToken = useState('');
    final username = useState('');

    final onSignIn = () async {
      final credentials = await signIn.signIn();
      final user = await signIn.getCurrentUser();

      accessToken.value = credentials.accessToken;
      username.value = user.displayName;
    };

    final onSignOut = () async {
      await signIn.signOut();
      accessToken.value = '';
      username.value = '';
    };

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Access Token: ${accessToken.value}'),
          Text('Username: ${username.value}'),
          username.value != ''
              ? ElevatedButton(onPressed: onSignOut, child: Text('Sign Out'))
              : ElevatedButton(child: Text('Sign In'), onPressed: onSignIn),
          Text(_message.value),
          Text(profile.value),
          ElevatedButton(onPressed: _login, child: Text('FB Login')),
          ElevatedButton(onPressed: _logOut, child: Text('FB LogOut'))
        ],
      ),
    );
  }
}
