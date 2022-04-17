from typing import final
from unittest import result
from urllib import response
import mysql.connector
from http.server import BaseHTTPRequestHandler, HTTPServer
import time
from urllib.parse import urlparse, parse_qsl
from json import dumps, loads
import hashlib

def database(query, post=False):
    db = mysql.connector.connect(host = "74.207.234.113",user="esseee",password="essee1234",database="ghambeel")

    cursor = db.cursor()
    cursor.execute(query)
    if not post:
        result = cursor.fetchall()

        return result
    else:
        result = cursor.fetchall()
        db.commit()
    cursor.close()

def addUser(data):
    username = data['username']
    email = data['email']
    password = data['password']
    password = hashlib.sha256(password.encode())
    query = fr"INSERT INTO Users VALUES ('{username}', '{password}', '{email}')"
    print(query)
    database(query, True)
    
def getTask(user):
    query = fr"SELECT Task FROM Tasks WHERE Users='{user}'"
    tasks = database(query)
    print(tasks)
    result = []
    for item in tasks:
        result.append(item[0])
    print(result)
    return result

def deleteTable(user, Table):
    query = fr"DELETE FROM {Table} WHERE Users='{user}'"
    database(query, True)

def addTask(data, user):
    incomplete = list(data['incomplete'].keys())
    complete = list(data['complete'].keys())
    # alreadyin = getTask(user)
    deleteTable(user, "Tasks")
    finalquery = ""
    for item in incomplete:
        #if item not in alreadyin:
        temp = dumps(data['incomplete'][item])
        finalquery = finalquery + fr"('{user}', '{item}', 'incomplete', '{temp}'),"
    for item in complete:
        # if item not in alreadyin:
        temp = dumps(data['complete'][item])
        finalquery = finalquery + fr"('{user}', '{item}', 'complete', '{temp}'),"
    if finalquery != "":
        finalquery = finalquery[:-1]
        finalquery = fr"INSERT INTO Tasks VALUES {finalquery}"
        database(finalquery, True)
    else:
        print("Nothing to add")

def getRecovery(username):
    data = database(fr"SELECT * FROM Tasks WHERE Users='{username}'")
    incomplete = []
    complete = []
    for item in data:
        taskNum = item[1]
        status = item[2]
        details = item[3]
        if status == "incomplete":
            incomplete.append({
                "taskNum" : taskNum,
                "details" : details
            })
        if status == "complete":
            complete.append({
                "taskNum" : taskNum,
                "details" : details
            })
    result = {
        "incomplete" : incomplete,
        "complete" : complete
    }
    return result

#     "username" : username,
#     "data" : jsonEncode({
#       "priority" : cumPriority,
#       "timeTaken" : cumTimeTaken,
#       "month" : cumMonth
#     })
#   });

def calcProd(stats):
    result = []
    if stats == None:
        return 0
    
    psum = 0
    tsum = 0

    for item in stats:
        psum = psum + int(item[0]) + 1
        tsum = tsum + int(item[1])    
    return psum*3600/tsum

def addScore(data, user):
    deleteTable(user, "Scoreboard")
    priority = data['priority']
    timeTaken = data['timeTaken']
    month = data["month"]
    result = [None]*12
    monthlyProductivity = []
    for i in range(len(month)):
        m = int(month[i])
        if result[m-1] == None:
            result[m-1] = []
        result[m-1].append((priority[i], timeTaken[i]))
    for item in result:
        monthlyProductivity.append(calcProd(item))
    
    print(monthlyProductivity)
    finalquery = ""
    for i, val in enumerate(monthlyProductivity):
        if val == 0:
            continue
        finalquery = finalquery + fr"('{user}', '{i}', '{val}'),"
    
    if finalquery != "":
        finalquery = finalquery[:-1]
        finalquery = fr"INSERT INTO Scoreboard VALUES {finalquery}"
        database(finalquery, True)
    else:
        print("Nothing to add")

def getScores(month):
    data = database(fr"SELECT * FROM Scoreboard WHERE Month='{month}'")
    result = []
    for item in data:
        result.append({
            "username" : item[0],
            "score" : round(float(item[2]), 3)
        })
    return result

def changePass(data, user):
    password = data['password']
    password = hashlib.sha256(password.encode())
    query = fr"UPDATE Users SET pass='{password}' WHERE Name='{user}'"
    database(query, True)


hostName = "0.0.0.0"
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
            if 'password' in query.keys():
                username = query['username']
                password = query['password']
                password = hashlib.sha256(password.encode())
                print(query)
                data = database(fr"SELECT * FROM Users WHERE Name='{username}' AND Pass='{password}'")
                if len(data) > 0:
                    response = {"status":"true"}
                    self.wfile.write(bytes(dumps(response), "utf8"))
                else:
                    response = {"status":"false"}
                    self.wfile.write(bytes(dumps(response), "utf8"))
            if 'recovery' in query.keys():
                username = query['username']
                response = getRecovery(username)
                self.wfile.write(bytes(dumps(response), "utf8"))
            if 'scores' in query.keys():
                username = query['username']
                scores = query['scores'] # This stores the month for which data is required
                response = getScores(scores)
                self.wfile.write(bytes(dumps(response), "utf8"))
    
    def do_POST(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.send_header('Access-Control-Allow-Credentials', 'true')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header("Access-Control-Allow-Headers", "X-Requested-With, Content-type")
        self.end_headers()
        content_len = int(self.headers.get('Content-Length'))
        post_data = loads(self.rfile.read(content_len))
        self.send_response(200)
        print(post_data)
        print(loads(post_data['data']))
        if post_data['table'] == 'Users':
            addUser(loads(post_data['data']))
        if post_data['table'] == "Tasks":
            temp = loads(post_data['data'])
            addTask(loads(temp['data']), temp['username'])
        if post_data['table'] == "Stats":
            temp = loads(post_data['data'])
            addScore(loads(temp['data']), temp['username'])
        if post_data['table'] == "Password":
            temp = loads(post_data['data'])
            changePass(loads(temp['data']), temp['username'])

if __name__ == "__main__":
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")




