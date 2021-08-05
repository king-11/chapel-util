import socket
import sys
import threading
from time import sleep
from typing import List

host = sys.argv[1]
port = int(sys.argv[2])

def createConnect(i):
	try:
		s = socket.create_connection((host, port))
		s.send(f"hello {i}\n".encode())
	except ConnectionResetError or ConnectionRefusedError:
		pass

threads:List[threading.Thread] = []

for x in range(int(sys.argv[3])):
	thread = threading.Thread(target=createConnect,args=([x]))
	threads.append(thread)

for thread in threads:
	thread.start()

for thread in threads:
	thread.join()
