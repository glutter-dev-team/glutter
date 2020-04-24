import 'package:http/http.dart';

class GlancesService {
  String serverAddress;
  String glcsResponse;
  String statusCodeStr;

  getServerStatus(String params) async {
    Response rawResp;

    try {
      rawResp = await get("http://"+serverAddress+"/api/3/"+params);

      int statusCode = rawResp.statusCode;
      Map<String, String> headers = rawResp.headers;
      String contentType = headers['content-type'];
      this.glcsResponse = rawResp.body;

      this.statusCodeStr = "Status code " + statusCode.toString();

      print(" ### http response logging: ###");
      print("Status code: " + statusCode.toString());
      print("headers: " + headers.toString());
      print("contentType: " + contentType.toString());
    } catch(_) {
      print("http get attempt error");
    }


  }
}
