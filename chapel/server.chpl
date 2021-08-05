use Socket;


proc main() {
  var host = "localhost";
  var address = ipAddr.create(host, 8000, IPFamily.IPv4);
  const server = listen(address, backlog = 6000);
  writeln("Listening for connections on ", server.addr.host, ":", server.addr.port);
  defer server.close();

  for {
    server.accept();
  }
}
