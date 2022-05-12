import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  var keyFile = File("bin/key.pem");
  var keyBytes = await keyFile.readAsBytes();

  SecurityContext clientContext = SecurityContext()
    ..setTrustedCertificatesBytes(keyBytes);

  HttpClient client = HttpClient(context: clientContext);
  var requset = await client.getUrl(Uri.https('localhost:8081', 'example'));
  var response = await requset.close();
  print(await response.transform(utf8.decoder).join());
}

/* String localFile(path) => Platform.script.resolve(path).toFilePath();

  SecurityContext clientContext = SecurityContext()
    ..setTrustedCertificates(localFile('trusted_certs.pem'));

  HttpClient client = HttpClient(context: clientContext);
  var requset = await client.get('127.0.0.1', 8080, '');
  var response = await requset.close();
  print(response.transform(utf8.decoder).join()); */





/*  var file = File("bin/server.pfx");
  var data = await file.readAsBytes();
  SecurityContext clientContext = SecurityContext();
  clientContext.useCertificateChainBytes(data, password: 'password');
  

  var client = HttpClient(context: clientContext);

  try {
    var request = await client.get('127.0.0.1', 8081, 'path');

    var response = await request.close();
    final datas = await response.transform(utf8.decoder).join();
    print(datas);
  } catch (e) {
    print(e);
  } finally {
    client.close();
  } */














/*

   ByteData data = await rootBundle.load('assets/raw/certificate.crt');
SecurityContext context = SecurityContext.defaultContext;
context.setTrustedCertificatesBytes(data.buffer.asUint8List());
client = HttpClient(context: context);

 */

//
/* 

import 'dart:io';

import 'package:flutter/services.dart';

Future<void> main(List<String> args) async {
  SecurityContext clientContext = SecurityContext()
    ..setTrustedCertificatesBytes([12, 12, 12, 12]);
  var client = HttpClient(context: clientContext);
  var request =
      await client.getUrl(Uri.parse('http://127.0.0.1:51534/z_h0hVeCyfQ=/'));
  var response = await request.close();
}




/* ByteData data = await rootBundle.load('assets/raw/certificate.crt');
SecurityContext context = SecurityContext.defaultContext;
context.setTrustedCertificatesBytes(data.buffer.asUint8List());
client = HttpClient(context: context); */



 */

