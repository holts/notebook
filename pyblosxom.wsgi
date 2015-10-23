# This is the pyblosxom.wsgi script that powers the blog.

import os
import sys

root = os.path.dirname(__file__)
sys.path.insert(0,os.path.join(root,'site-packages'))

def add_to_path(d):
   if d not in sys.path:
      sys.path.insert(0, d)

# call add_to_path with the directory that your config.py lives in.
add_to_path(root)

# if you have Pyblosxom installed in a directory and NOT as a
# Python library, then call add_to_path with the directory that
# Pyblosxom lives in.  For example, if I untar'd
# pyblosxom-1.5.tar.gz into /home/joe/, then add like this:
# add_to_path("/home/joe/pyblosxom-1.5/")

import Pyblosxom.pyblosxom
application = Pyblosxom.pyblosxom.PyblosxomWSGIApp()
