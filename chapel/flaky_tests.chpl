use Socket;
use UnitTest;
use IO;

// utility for below test
proc recv_string(test: borrowed Test) throws {
  var port:uint(16) = 8811;
  var host = "127.0.0.1";
  var address = ipAddr.ipv4(IPv4Localhost, port);
  var server = listen(address);
  sync {
    begin {
      var conn = server.accept();
      var writer = conn.writer();
      writer.write("hello world\n");
    }

    var conn = connect(host, port);
    var reader = conn.reader();
    var x:bytes;
    reader.readline(x);
    test.assertEqual(x, b"hello world\n");
  }
}

// works only after above one solo not runs hangs on connect
proc send_string(test: borrowed Test) throws {
  var port:uint(16) = 8811;
  var host = "127.0.0.1";
  var address = ipAddr.ipv4(IPv4Localhost, port);
  var server = listen(address);
  sync {
    begin {
      var conn = server.accept();
      var reader = conn.reader();
      var x:bytes;
      reader.readline(x);
      test.assertEqual(x, b"hello world\n");
    }

    var conn = connect(host, port);
    var writer = conn.writer();
    writer.write("hello world\n");
  }
}

// FIFO fail no communication btw sync vars even though got event
proc test_send_recv(test: borrowed Test) throws {
  var host = "127.0.0.1";
  var address = ipAddr.create(host, 8111);
  var receiver = new udpSocket();
  bind(receiver, address);
  var sender = new udpSocket();
  var sent = b"hello";
  var received:bytes;
  sync {
    begin {
      var sentBytes = sender.send(sent, address);
      test.assertEqual(sentBytes, sent.size);
    }
    received = receiver.recv(sent.size);
    test.assertEqual(received, sent);
  }
}

// blocking check
proc test_fail_backlog_ipv6(test: borrowed Test) throws {
  var port:uint(16) = 7722;
  var host = "::1";
  var address = ipAddr.ipv6(IPv6Localhost, port);
  var server = listen(address, backlog = 6);

  var failures = 0;
  coforall x in 1..20 with (+ reduce failures) do {
    try {
      var conn = connect(address, new timeval(1, 0));
    }
    catch e {
      failures += 1;
    }
  }

  test.assertNotEqual(failures, 0);
}

UnitTest.main();
