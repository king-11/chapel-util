use Socket;
use IO;
use Time;

config var host = "127.0.0.1";
config var port:uint(16) = 8500;
var address = ipAddr.create(host, port, IPFamily.IPv4);
const server = listen(address, reuseAddr = true, backlog = 6000);
writeln("Listening for connections on ", server.addr.host, ":", server.addr.port);
config const n = 1000;

const D: domain(1) = {0..<n};
var arr:[D] tcpConn;
var mutex$: sync int = 1;
writeln(D);
sleep(4);

var sum:[D] real(64);
writeln("now");
forall (x, y) in zip(arr, sum) do {
  var t: Timer;
  t.start();
  mutex$.readFE();
  x = server.accept();
  mutex$.writeEF(1);
  const reader = x.reader();
  var readBytes:bytes;
  reader.readln(readBytes);
  const writer = x.writer();
  writer.writeln(getpeername(x), readBytes);
  t.stop();
  y = t.elapsed();
}

var timed:real(64) = 0;
for x in 0..<n {
  timed += sum[x];
}
writeln(timed);

forall x in arr do {
  x.close();
}

server.close();
