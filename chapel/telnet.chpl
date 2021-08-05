use Socket;
use Time;

config var host:string = "127.0.0.1", port:uint(16) = 3000;
config const n = 500;
const D: domain(1) = {0..<n};
const address = ipAddr.create(host, port);
var arr:[D] tcpConn;

forall x in arr {
  try {
    x = connect(address);
  }
  catch e {
    writeln(e.message());
  }
}

sleep(2);

forall x in arr do {
  x.close();
}
