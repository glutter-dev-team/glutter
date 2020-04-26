import 'package:http/http.dart';

class GlancesService {
  String serverAddress = "seafileserver:61208";
  String glcsResponse;
  String statusCodeStr;

  getServerStatus(String params) async {
    Response rawResp;

    try {
      rawResp = await get("http://"+serverAddress+"/api/2/"+params);

      int statusCode = rawResp.statusCode;
      Map<String, String> headers = rawResp.headers;
      String contentType = headers['content-type'];
      this.glcsResponse = rawResp.body;

      this.statusCodeStr = "Status code " + statusCode.toString();

      print(" ### http response logging: ###");
      print("Status code: " + statusCode.toString());
      print("headers: " + headers.toString());
      print("contentType: " + contentType.toString());
      print("content:" + rawResp.body.toString());
    } catch(_) {
      print("http get attempt error");
    }


  }
}
