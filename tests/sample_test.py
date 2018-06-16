#!/usr/bin/env python
import pytest
from package_name.module_name import sum

def test_sum():
    assert sum(1, 2) == 3
    assert sum(1, -1) == 0
    assert sum(1., -1.) < 1e-5

if __name__ == '__main__':
    unittest.main()
