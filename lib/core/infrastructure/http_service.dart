import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';

abstract class HttpServiceBase {
  Future<Map<String, dynamic>> query(String query, Map vars);

  Future<Map<String, dynamic>> mutation(String query, Map vars);

  Future<Map<String, dynamic>> images(
    String query,
    List<CollectionImage> images,
    String map,
  );
}

class HttpService extends HttpServiceBase {
  final Client client;
  final String host;

  HttpService({required this.host, required this.client});

  Future<String> getToken() async {
    // try {
    //   final string =
    //       (await SharedPreferences.getInstance()).getString('session') ?? '';
    //   final result = SessionModel.fromJson(json.decode(string));
    //   return "Bearer ${result.token}";
    // } catch (e) {
    return '';
    // }
  }

  @override
  Future<Map<String, dynamic>> query(String query, Map vars) async {
    Map<String, dynamic> body = {
      "query": "query $query",
      "variables": vars,
    };
    var response = await client.post(
      Uri.parse(host),
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        "Authorization": await getToken()
      },
    );
    checkStatusCode(response);
    return json.decode(response.body);
  }

  @override
  Future<Map<String, dynamic>> mutation(String query, Map vars) async {
    Map<String, dynamic> body = {"query": "mutation $query", "variables": vars};
    var response = await client.post(
      Uri.parse(host),
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        "Authorization": await getToken()
      },
    );
    checkStatusCode(response);
    return json.decode(response.body);
  }

  @override
  Future<Map<String, dynamic>> images(
    String query,
    List<CollectionImage> images,
    String map,
  ) async {
    var headers = {'Content-Type': 'multipart/form-data'};
    var req = http.MultipartRequest('POST', Uri.parse(host));
    req.headers.addAll(headers);
    req.fields.addAll({'operations': query, 'map': map});
    for (var i = 0; i < images.length; i++) {
      var image = images[i];
      req.files.add(
        http.MultipartFile.fromBytes(
          '$i',
          image.bytes.cast(),
          filename: image.name,
          contentType: MediaType('image', image.mimeType),
        ),
      );
    }
    try {
      var response = await req.send();
      response.stream.bytesToString().asStream().listen((event) {
        var parsedJson = json.decode(event);
        print(parsedJson);
        print(response.statusCode);
      }).onError((e) => print(e));
      return json.decode("{}");
    } catch (e) {
      throw Error();
    }
  }

  checkStatusCode(Response response) {
    print(response.statusCode);
    print(response.body);

    // if (response.statusCode == 401) {
    //   throw UnhandledFailure(message: 'Unauthorized 401');
    // }
    // if (response.statusCode == 500) {
    //   throw UnhandledFailure(message: 'Error desconocido code:500');
    // }
    // final body = jsonDecode(response.body) as Map<String, dynamic>;
    // if (body['errors'] != null)
    //   throw UnhandledFailure(message: body['errors'][0]['message']);
  }
}
