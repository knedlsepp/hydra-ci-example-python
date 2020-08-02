#!/usr/bin/env python
from package_name.module_name import sum


def test_other():
    assert True


def test_sum():
    assert sum(1, 2) == 3
    assert sum(1, -1) == 0
    assert sum(1., -1.) < 1e-5
