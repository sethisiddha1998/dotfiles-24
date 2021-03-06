#!/usr/bin/env python

from os.path import expanduser
from subprocess import check_output, CalledProcessError


def passwd(acc):
    """
    Get a password from a gpg file, expects something like 'password = "bla"'
    """
    path = '{}/.mutt/mutt-{}.gpg'.format(expanduser('~'), acc)
    args = ['gpg', '-q', '-d', path]
    try:
        return check_output(args).strip().split('"')[1]
    except CalledProcessError:
        return 'FAIL'
