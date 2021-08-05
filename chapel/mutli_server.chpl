use Socket;
use IO;
use Time;

var host = "localhost";
var address = ipAddr.create(host, 8000, IPFamily.IPv4);
const server = listen(address, backlog = 6000);
writeln("Listening for connections on ", server.addr.host, ":", server.addr.port);
config const n = 500;

const D: domain(1) = {0..<n};
var arr:[D] tcpConn;
var mutex$: sync int = 1;
writeln(D);

var t: Timer;
t.start();
forall x in arr do {
  mutex$.readFE();
    x = server.accept();
  mutex$.writeEF(1);
  const writer = x.writer();
  const reader = x.reader();
  var x:bytes;
  reader.readln(x);
  writer.writeln(getpeername(x));
}
t.stop();
writeln(t.elasped());

writeln("done");

forall x in arr do {
  x.close();
}

server.close();
