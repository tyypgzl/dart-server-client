// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// OtherResources=certificates/server_chain.pem
// OtherResources=certificates/server_key.pem
// OtherResources=certificates/trusted_certs.pem

import "dart:io";
import "dart:isolate";

late InternetAddress HOST;

String localFile(path) => Platform.script.resolve(path).toFilePath();

SecurityContext serverContext = SecurityContext()
  ..useCertificateChain(localFile('certificates/server_chain.pem'))
  ..usePrivateKey(localFile('certificates/server_key.pem'),
      password: 'dartdart');

SecurityContext clientContext = SecurityContext()
  ..setTrustedCertificates(localFile('certificates/trusted_certs.pem'));

void testListenOn() {
  void test(void onDone()) {
    HttpServer.bindSecure(HOST, 0, serverContext, backlog: 5).then((server) {
      ReceivePort serverPort = ReceivePort();
      server.listen((HttpRequest request) {
        request.listen((_) {}, onDone: () {
          request.response.close();
          serverPort.close();
        });
      });

      HttpClient client = HttpClient(context: clientContext);
      ReceivePort clientPort = ReceivePort();
      client
          .getUrl(Uri.parse("https://${HOST.host}:${server.port}/"))
          .then((HttpClientRequest request) {
        return request.close();
      }).then((HttpClientResponse response) {
        response.listen((_) {}, onDone: () {
          client.close();
          clientPort.close();
          server.close();
          onDone();
        });
      }).catchError((e, trace) {
        String msg = "Unexpected error in Https client: $e";
        if (trace != null) msg += "\nStackTrace: $trace";
      });
    });
  }

  // Test two servers in succession.
  test(() {
    test(() {});
  });
}

void testEarlyClientClose() {
  HttpServer.bindSecure(HOST, 0, serverContext).then((server) {
    server.listen((request) {
      String name = Platform.script.toFilePath();
      File(name)
          .openRead()
          .cast<List<int>>()
          .pipe(request.response)
          .catchError((e) {/* ignore */});
    });

    var count = 0;
    makeRequest() {
      Socket.connect(HOST, server.port).then((socket) {
        var data = "Invalid TLS handshake";
        socket.write(data);
        socket.close();
        socket.done.then((_) {
          socket.destroy();
          if (++count < 10) {
            makeRequest();
          } else {
            server.close();
          }
        });
      });
    }

    makeRequest();
  });
}

void main() {
  InternetAddress.lookup("localhost").then((hosts) {
    HOST = hosts.first;
    testListenOn();
    testEarlyClientClose();
  });
}
