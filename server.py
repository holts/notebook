
import os
import sys

root = os.path.dirname(__file__)
sys.path.insert(0,os.path.join(root,'site-packages'))

from paste import deploy
from wsgiref import simple_server
 
paste_file = 'blog.ini'
app = deploy.loadapp("config:%s" % os.path.abspath(paste_file))

if __name__ == '__main__':
	server = simple_server.make_server("",5000,app)
	server.serve_forever()

