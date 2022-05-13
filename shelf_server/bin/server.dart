import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final _router = Router()
  ..get('/', _rootHandler)
  ..get('/example', _exampleHandler);

Response _rootHandler(Request req) {
  return Response.ok('SSL Server requested!\n');
}

Response _exampleHandler(Request req) {
  return Response.ok('SSL Server Example Requested!');
}

void main(List<String> args) async {
  var chainFile = File("bin/chain.pem");
  var keyFile = File("bin/key.pem");
  var chainBytes = await chainFile.readAsBytes();
  var keyBytes = await keyFile.readAsBytes();

  SecurityContext serverContext = SecurityContext()
    ..useCertificateChainBytes(chainBytes, password: 'dartdart')
    ..usePrivateKeyBytes(keyBytes, password: 'dartdart');

  final ip = InternetAddress.anyIPv4;

  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server =
      await serve(_handler, ip, port, securityContext: serverContext);

  print('Server listening on port ${server.port} host: ${server.address.host}');
}
