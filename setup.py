import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
README = open(os.path.join(here, 'README.txt')).read()
CHANGES = open(os.path.join(here, 'CHANGES.txt')).read()

requires = [
    'pyblosxom',
    'docutils',
    'pastedeploy',
    'pastescript',
    'paste',
    'wheel',
    'six',
    ]

setup(name='htblog',
      version='0.0',
      description='htblog',
      long_description=README + '\n\n' +  CHANGES,
      classifiers=[
        "Programming Language :: Python",
        "Framework :: Pyblosxom",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        ],
      author='holts',
      author_email='holts.he@gmail.com',
      url='http://htblog.mybluemix.net',
      keywords='web python radio machinery music',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      install_requires=requires,
      tests_require=requires,
      test_suite="htblog",
      entry_points = """\
      [paste.app_factory]
      main = htblog:main
      [console_scripts]
      qpwrapper = htblog.scripts.qpwrapper:main
      """,
      )

