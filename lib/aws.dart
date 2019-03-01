import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:http/http.dart' as http;

class Credentials {
  final CognitoCredentials _cognitoCredentials;
  final String _token;
  final String _authenticator;

  Credentials(String identityPoolId, String userPoolId, String clientId, this._token, [this._authenticator])
      : _cognitoCredentials = new CognitoCredentials(identityPoolId, new CognitoUserPool(userPoolId, clientId));

  Future<CognitoCredentials> get cognitoCredentials async {
    await _cognitoCredentials.getAwsCredentials(_token, _authenticator);
    return _cognitoCredentials;
  }
}

class Api {
  final String endpoint;
  final String path;
  final String region;
  final Credentials credentials;

  Api(this.endpoint, this.path, this.region, this.credentials);

  post(Map body) async {
    CognitoCredentials cognitoCredentials = await credentials.cognitoCredentials;
    final awsSigV4Client = new AwsSigV4Client(
      cognitoCredentials.accessKeyId,
      cognitoCredentials.secretAccessKey,
      endpoint,
      sessionToken: cognitoCredentials.sessionToken,
      region: region,
    );
    final signedRequest = new SigV4Request(
      awsSigV4Client,
      method: 'POST',
      path: path,
      // headers: new Map<String, String>.from({'header-1': 'one', 'header-2': 'two'}),
      // queryParams: new Map<String, String>.from({'tracking': 'x123'}),
      body: new Map<String, dynamic>.from(body),
    );

    http.Response response;

    response = await http.post(signedRequest.url, headers: signedRequest.headers, body: signedRequest.body);

    return response;
  }
}
