# -*- coding: utf-8 -*-
from setuptools import setup, find_packages

config = {
    'name': 'projectname',
    'version': '0.1',
    'author': 'My Name',
    'author_email': 'My email.',
    'description': 'My Project',
    'packages': find_packages('src'),
    'package_dir': {
        '': 'src'
    },
    'package_data': {
        'package_name': ['package_name/data/*']
    },
    'scripts': [],
    'install_requires': ['numpy'],
    'setup_requires': ['pytest-runner'],
    'test_suite': 'tests',
    'tests_require': ['pytest'],
}

setup(**config)
