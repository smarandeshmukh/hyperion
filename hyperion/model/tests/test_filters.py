from __future__ import print_function, division

import os
import shutil
import tempfile

from astropy.tests.helper import pytest
import numpy as np
from numpy.testing import assert_array_almost_equal_nulp

from astropy import units as u

from .. import Model
from ..image import Image
from ...util.functions import random_id
from .test_helpers import get_test_dust, get_highly_reflective_dust


class TestFilters(object):

    def setup_class(self):

        m = Model()

        m.set_cartesian_grid([-1., 1.],
                             [-1., 1.],
                             [-1., 1.])

        m.add_density_grid(np.array([[[1.e-30]]]), get_test_dust())

        s = m.add_point_source()
        s.name = 'first'
        s.luminosity = 1.
        s.temperature = 6000.

        s = m.add_point_source()
        s.name = 'second'
        s.luminosity = 1.
        s.temperature = 6000.

        filters = []
        filters.append(([1, 1.1, 1.2, 1.3] * u.micron,
                        [0., 100., 50, 0.] * u.percent))
        filters.append(([2, 2.1, 2.2, 2.3, 2.4] * u.micron,
                        [0., 50, 100, 60, 0.] * u.percent))

        i = m.add_peeled_images(sed=True, image=True)
        i.set_viewing_angles([1., 2., 3.], [1., 2., 3.])
        i.set_image_limits(-1., 1., -1., 1.)
        i.set_image_size(10, 20)
        i.set_filters(filters)

        m.set_n_initial_iterations(0)

        m.set_n_photons(imaging=1)

        self.tmpdir = tempfile.mkdtemp()
        m.write(os.path.join(self.tmpdir, random_id()))

        self.m = m.run()

    def teardown_class(self):
        shutil.rmtree(self.tmpdir)

    def test_image_wav(self):
        image = self.m.get_image()
        assert image.wav == ()
        
    def test_image_shape(self):
        image = self.m.get_image()
        assert image.val.shape == (3, 20, 10, 2)

    def test_sed_shape(self):
        sed = self.m.get_sed()
        assert sed.val.shape == (3, 1, 2)
