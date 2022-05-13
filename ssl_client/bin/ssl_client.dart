import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  var keyFile = File("bin/key.pem");
  var keyBytes = await keyFile.readAsBytes();

  SecurityContext clientContext = SecurityContext()
    ..setTrustedCertificatesBytes(keyBytes);

  HttpClient client = HttpClient(context: clientContext);
  var requset = await client.getUrl(Uri.https('localhost:8080', 'example'));
  var response = await requset.close();
  print(await response.transform(utf8.decoder).join());
}
