use Socket;

var address = ipAddr.create("127.0.0.1",8000);

var sender = new udpSocket();
writeln(sender.addr);
var data = b"hello";
var sent = sender.send(data, address);
writeln(sent);
