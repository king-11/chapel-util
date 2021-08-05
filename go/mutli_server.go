package main

import (
	"fmt"
	"net"
	"sync"
	"time"
)

var connections = make([]net.Conn, 5000)
var server net.Listener
var err error

var mutex sync.Mutex
func acceptConn(i int) {
	mutex.Lock()
	defer mutex.Unlock()
	connections[i], err = server.Accept()
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(connections[i].RemoteAddr())
}

func closeConn(i int){
	connections[i].Close()
}

func main(){
	server, err = net.Listen("tcp","127.0.0.1:8000")
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println("Listening On :", server.Addr())
	defer server.Close()

	for i := 0; i < 5000; i++ {
		go acceptConn(i)
	}

	fmt.Scanln()
	fmt.Println("done")

	time.Sleep(2)
	for i := 0; i < 5000; i++ {
		go closeConn(i)
	}
}
