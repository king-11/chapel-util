package main

import (
	"fmt"
	"net"
)

func main() {
	server, err := net.Listen("tcp","127.0.0.1:8000")
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println("Listening On :", server.Addr())
	defer server.Close()

	for {
		server.Accept()
	}
}
