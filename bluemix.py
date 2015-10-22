import os

from server import app
from wsgiref import simple_server


# Read port selected by the cloud for our application
PORT = int(os.getenv('VCAP_APP_PORT', 8000))
# Change current directory to avoid exposure of control files
# os.chdir('static')

httpd = simple_server.make_server("", PORT, app)
try:
  print("Start serving at port %i" % PORT)
  httpd.serve_forever()
except KeyboardInterrupt:
  pass
httpd.server_close()

