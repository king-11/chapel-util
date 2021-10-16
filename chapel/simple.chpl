use Socket;

var port:uint(16) = 8812;
var host = "0.0.0.0";
var address = ipAddr.ipv4(IPv4Localhost, port);

proc server(srv: tcpListener) throws {
  writeln("Server accepting");
  var conn = srv.accept();
  writeln("Client connected. Now sending ", 5);
  var writer = conn.writer();
  writer.write(5, " ");
  writeln("Server done sending");
}

proc client() throws {
  writeln("Client connecting");
  var conn = connect(address);
  var reader = conn.reader();
  writeln("Client reading");
  var got = reader.read(int);
  writeln("Client read: ", got);
}

proc main() throws {
  writeln("Server listening");
  var srv = listen(address);

  sync {
    cobegin {
      server(srv);
      client();
    }
  }
  srv.close();
}
