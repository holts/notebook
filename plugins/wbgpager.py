"""
Summary
=======

Plugin for paging long index pages.  

PyBlosxom uses the num_entries configuration variable to prevent
more than num_entries being rendered by cutting the list down
to num_entries entries.  So if your num_entries is set to 20, you
will only see the first 20 entries rendered.

The wbgpager overrides this functionality and allows for paging.

To install wbgpager, do the following:

1. add "wbgpager" to your load_plugins list variable in your
   config.py file--make sure it's the first thing listed so
   that it has a chance to operate on the entry list before
   other plugins.
2. add the $page_navigation variable to your head or foot
   (or both) templates.  this is where the page navigation
   HTML will appear.


Here are some additional configuration variables to adjust the 
behavior::

  wbgpager_count_from
    datatype:       int
    default value:  0
    description:    Some folks like their paging to start at 1--this
                    enables you to do that.

  wbgpager_previous_text
    datatype:       string
    default value:  &lt;&lt;
    description:    Allows you to change the text for the prev link.

  wbgpager_next_text
    datatype:       string
    default value:  &gt;&gt;
    description:    Allows you to change the text for the next link.

  wbgpager_linkstyle
    datatype:       integer
    default value:  1
    description:    This allows you to change the link style of the paging.
                    style 0:  [1] 2 3 4 5 6 7 8 9 ... >>
                    style 1:  Page 1 of 4 >>


That should be it!


Note: This plugin doesn't work particularly well with static rendering.
The problem is that it relies on the querystring to figure out which
page to show and when you're static rendering, only the first page
is rendered.  This will require a lot of thought to fix.  If you are
someone who is passionate about fixing this issue, let me know.

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

Copyright 2004-2008 Will Kahn-Greene

SUBVERSION VERSION: $Id$

Revisions:
2009-06-12 - fixed it to work with PyBlosxom 1.5
2008-02-10 - reworked the wbgpager to use the truncatelist callback.
2007-11-30 - Fixed the wbgpager_linkstyle documentation.  Thanks Steve!
2007-07-07 - Converted documentation to reST.
2006-01-15 - Fixed problems with static rendering, added a note about how
             wbgpager sucks with static rendering, and also added a
             verify_installation section to check that num_entries is set.
2005-11-11 - Pulled into new VCS.
1.6 - (26 October, 2005) pulled into new VCS
1.5 - (26 September 2005) added configurable 1, 2, 3, 4, ... or Page 1 of 23
                          linking methodologies
1.4 - (19 May 2005) added configurable next/prev links, additional spaceing
                    between links, and configurable page start 
                    (thanks Martin Michlmayr!)
1.3 - (06 May 2005) fixed off-by-one issues (thanks Martin Michlmayr!)
1.2 - (11 April 2005) fixed to work with PyBlosxom 1.2
1.1 - (22 January 2005) fixed to work with PyBlosxom 1.1
1.0 - (30 April 2004) initial writing
"""
__author__ = "Will Kahn-Greene - willg at bluesock dot org"
__version__ = "$Date$"
__url__ = "https://github.com/willkg/pyblosxom-plugins"
__description__ = "Allows navigation by page for indexes that have too many entries."

def verify_installation(request):
    config = request.getConfiguration()
    if config.get("num_entries", 0) == 0:
        print "missing config property 'num_entries'.  wbgpager won't do "
        print "anything without num_entries set.  either set num_entries "
        print "to a positive integer, or disable the wbgpager plugin."
        print "see the documentation at the top of the wbgpager plugin "
        print "code file for more details."
        return 0

    return 1

class PageDisplay:
    def __init__(self, url, current_page, max_pages, count_from, previous, next, linkstyle):
        self._url = url
        self._current_page = current_page
        self._max_pages = max_pages
        self._count_from = count_from
        self._previous = previous
        self._next = next
        self._linkstyle = linkstyle

    def __str__(self):
        output = []
        # prev
        if self._current_page != self._count_from:
            output.append('<a href="%s%d">%s</a>&nbsp;' % 
                          (self._url, self._current_page - 1, self._previous))

        if self._linkstyle == 0:
            for i in range(self._count_from, self._max_pages):
                if i == self._current_page:
                    output.append('[%d]' % i)
                else:
                    output.append('<a href="%s%d">%d</a>' %
                                  (self._url, i, i))
        elif self._linkstyle == 1:
            output.append(' Page %s of %s ' % (self._current_page, self._max_pages-1))

        # next
        if self._current_page < self._max_pages - 1:
            output.append('&nbsp;<a href="%s%d">%s</a>' % 
                          (self._url, self._current_page + 1, self._next))

        return " ".join(output)
    
def page(request, num_entries, entry_list):
    http = request.getHttp()
    config = request.getConfiguration()
    data = request.getData()

    previous = config.get("wbgpager_previous_text", "&lt;&lt;")
    next = config.get("wbgpager_next_text", "&gt;&gt;")

    linkstyle = config.get("wbgpager_linkstyle", 1)
    if linkstyle > 1: linkstyle = 1

    max = num_entries
    count_from = config.get("wbgpager_count_from", 0)

    if max > 0 and isinstance(entry_list, list) and len(entry_list) > max:
        # this is the old way we got the form (PyBlosxom 1.1 and before)
        form = http.get("form", None)

        # this is the new way to get the form (PyBlosxom 1.2 and after)
        if not form and getattr(request, "getForm"):
            form = request.getForm()

        page = count_from
        if form:
            try:
                page = int(form.getvalue("page"))
            except:
                page = count_from

        begin = (page - count_from) * max
        end = (page + 1 - count_from) * max
        if end > len(entry_list):
            end = len(entry_list)

        maxpages = ((len(entry_list) - 1) / max) + 1 + count_from

        url = http.get("REQUEST_URI", http.get("HTTP_REQUEST_URI", ""))
        if url.find("?") != -1:
            query = url[url.find("?")+1:]
            url = url[:url.find("?")]

            query = query.split("&")
            query = [m for m in query if not m.startswith("page=")]
            if len(query) == 0:
                url = url + "?" + "page="
            else:
                url = url + "?" + "&amp;".join(query) + "&amp;page="
        else:
            url = url + "?page="

        data["entry_list"] = entry_list[begin:end]

        data["page_navigation"] = PageDisplay(url, page, maxpages, count_from, previous, next, linkstyle)

    else:
        data["page_navigation"] = ""


from Pyblosxom import pyblosxom

########################################################################
# This functionality handles PyBlosxom 1.5 by using the new truncatelist
# callback.  No klugy num_entries sleight-of-hand anymore.

def cb_truncatelist(args):
    if pyblosxom.VERSION_SPLIT < (1, 5, 0):
        return

    request = args["request"]
    entry_list = args["entry_list"]

    page(request, request.config.get("num_entries", 10), entry_list)
    return request.data.get("entry_list", entry_list)


########################################################################
# This functionality kicks in for pre PyBlosxom 1.5 versions that don't
# have the truncatelist callback.  It's very klugy.

def cb_start(args):
    if pyblosxom.VERSION_SPLIT >= (1, 5, 0):
        return

    req = args["request"]
    config = req.getConfiguration()

    # we do a quick slight of hand here so that PyBlosxom doesn't
    # go and cut down the list of entries before we get a chance
    # to.
    if not config.has_key("wbgpager_num_entries"):
        ne = config.get("num_entries", 0)
        config["wbgpager_num_entries"] = ne
        config["num_entries"] = 0

def cb_prepare(args):
    if pyblosxom.VERSION_SPLIT >= (1, 5, 0):
        return

    request = args["request"]
    http = request.getHttp()
    config = request.getConfiguration()
    data = request.getData()
    previous = config.get("wbgpager_previous_text", "&lt;&lt;")
    next = config.get("wbgpager_next_text", "&gt;&gt;")

    linkstyle = config.get("wbgpager_linkstyle", 1)
    if linkstyle > 1: linkstyle = 1

    # grab the entry list
    entry_list = data["entry_list"]
    max = config.get("wbgpager_num_entries", 20)

    page(request, config.get("wbgpager_num_entries", 20), entry_list)
