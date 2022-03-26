from urllib import response
import mysql.connector
from http.server import BaseHTTPRequestHandler, HTTPServer
import time
from urllib.parse import urlparse, parse_qsl
from json import dumps, loads

def database(query):
    db = mysql.connector.connect(host = "74.207.234.113",user="esseee",password="essee1234",database="ghambeel")

    cursor = db.cursor()
    cursor.execute(query)

    result = cursor.fetchall()

    return result

hostName = "localhost"
serverPort = 8080

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.send_header('Access-Control-Allow-Credentials', 'true')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header("Access-Control-Allow-Headers", "X-Requested-With, Content-type")
        self.end_headers()
        if "?" in self.path:
            query = dict(parse_qsl(self.path[2:])) ## This is where the url parameters are gotten
            username = query['username']
            password = query['password']
            data = database(fr"SELECT * FROM Users WHERE Name='{username}' AND Pass='{password}'")
            if len(data) > 0:
                response = {"status":"true"}
                self.wfile.write(bytes(dumps(response), "utf8"))
            else:
                response = {"status":"false"}
                self.wfile.write(bytes(dumps(response), "utf8"))
    
    def do_POST(self):
        content_len = int(self.headers.get('Content-Length'))
        post_data = self.rfile.read(content_len)
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        print(post_data)

if __name__ == "__main__":        
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")



