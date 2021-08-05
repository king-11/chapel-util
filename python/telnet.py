import socket
import sys
import threading
from time import sleep
from typing import List

host = sys.argv[1]
port = int(sys.argv[2])

try:
	s = socket.create_connection((host, port))
except ConnectionResetError or ConnectionRefusedError:
	pass
