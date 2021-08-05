use Socket;

proc main() throws {
  var host = "localhost";
  var address = ipAddr.ipv4(IPv4Localhost, 8111);
  var receiver = new udpSocket();
  bind(receiver, address);

  var address1 = ipAddr.ipv4(IPv4Localhost, 8110);
  var sender = new udpSocket();
  bind(sender, address1);
  writeln(receiver);
  writeln(sender);

  var sent = b"hello";
  writeln(sent);
  var received:bytes;
  begin {
    var sentBytes = sender.send(sent, address);
    writeln(sentBytes);
  }
  writeln("give data now");
  received = receiver.recv(sent.size);

  writeln(received, sent);
}
