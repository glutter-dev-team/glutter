import 'package:http/http.dart';

class GlancesService {
  String serverAddress;

  String glcsResponse;
  String statusCodeStr;

  sendCommand(String params) async {
    print("trying to get response from: " + "http://"+serverAddress+"/control?"+params);
    Response commandRes = await get("http://"+serverAddress+"/control?"+params);
  }

  getServerStatus(String params) async {
    Response rawResp;

    try {
      rawResp = await get("http://"+serverAddress+"/api/3/"+params);

      int statusCode = rawResp.statusCode;
      Map<String, String> headers = rawResp.headers;
      String contentType = headers['content-type'];
      this.glcsResponse = rawResp.body;

      this.statusCodeStr = "Status code " + statusCode.toString();

      print(" ### getPinStatus logging: ###");
      print("Status code: " + statusCode.toString());
      print("headers: " + headers.toString());
      print("contentType: " + contentType.toString());
    } catch(_) {
      print("http get attempt error");
    }


  }
}
