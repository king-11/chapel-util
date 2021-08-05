use Socket;
use Time;

var address = ipAddr.create("0.0.0.0",8000);

var receiver = new udpSocket();
bind(receiver, address);

var data = receiver.recv(5);

writeln(data);
