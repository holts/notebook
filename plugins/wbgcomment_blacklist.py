"""
Summary
=======

This works in conjunction with the comments plugin and allows you to
reduce comment spam by a words blacklist.  Any comment that contains
one of the blacklisted words will be rejected immediately.

This shouldn't be the only way you reduce comment spam.  It's probably
not useful to everyone, but would be useful to some people as a quick
way of catching some of the comment spam they're getting.


Usage
=====

For setup, all you need to do is set the comment_rejected_words 
property in your config.py file.  For example, the following will
reject any incoming comments with the words ``gambling`` or ``casino``
in them::

   py["comment_rejected_words"] = ["gambling", "casino"]


The comment_rejected_words property takes a list of strings as a
value.

Additionally, the wbgcomments_blacklist plugin can log when it
blacklisted a comment and what word was used to blacklist it.
Sometimes this information is interesting.  1 if "yes, I want
to log" and 0 (default) if "no, i don't want to log".  Example::

   py["comment_rejected_words_log"] = 1

----

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Copyright 2002-2007 Will Kahn-Greene

SUBVERSION VERSION $Id$

Revisions:
2007-07-07 - converted documentation to reST.
2005-11-11 - Pulled into new VCS.
1.5 - (26 October, 2005) pulled into new VCS
1.0 - (11 April, 2005) first release
"""

import time, os.path

__author__ = "Will Kahn-Greene - willg at bluesock dot org"
__version__ = "$Date$"
__url__ = "https://github.com/willkg/pyblosxom-plugins"
__description__ = "Rejects comments that contain specified blacklisted words."

def verify_installation(request):
    config = request.getConfiguration()
    if not config.has_key("comment_rejected_words"):
        print "The \"comment_rejected_words\" property must be set in your config.py "
        print "file.  It takes a list of strings as a value.  Refer to the "
        print "documentation at the top of the comment_blacklist plugin for more "
        print "details."
        return 0

    crw = config["comment_rejected_words"]
    if type(crw) != type( [] ) and type(crw) != type ( () ):
        print "The \"comment_rejected_words\" property is incorrectly set in your "
        print "config.py file.  It takes a list of strings as a value.  Refer to "
        print "the documentation at the top of the comment_blacklist plugin for "
        print "more details."
        return 0
    return 1


def cb_comment_reject(args):
    r = args["request"]
    c = args["comment"]

    config = r.getConfiguration()

    badwords = config.get("comment_rejected_words", [])
    for mem in c.values():
        mem = mem.lower()
        for word in badwords:
            if mem.find(word) != -1:
                if config.get("comment_rejected_words_log", 0):
                    if config.has_key("logdir"):
                        fn = os.path.join(config["logdir"], "blacklist.log")
                        f = open(fn, "a")
                        f.write("%s: %s\n" % (time.ctime(time.time()), word))
                        f.close()
                return (1, "Comment rejected: contains blacklisted words.")

    return 0
