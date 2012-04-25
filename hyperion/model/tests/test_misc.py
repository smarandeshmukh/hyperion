import numpy as np

from .. import Model

from .test_helpers import get_test_model_noimaging, random_filename


def test_monochromatic_wav():

    model = Model()
    model.set_cartesian_grid([-1., 1.], [-1., 1.], [-1., 1.])
    model.set_n_initial_iterations(1)

    source = model.add_point_source()
    source.luminosity = 1.
    source.temperature = 1000.

    model.set_monochromatic(True, wavelengths=[1., 2., 3.])

    model.set_n_photons(initial=1, imaging_sources=1, imaging_dust=1)

    model.write(random_filename())
    model.run(random_filename())


def test_model_spectrum():

    model = get_test_model_noimaging()

    source = model.add_point_source()
    source.luminosity = 1.
    source.spectrum = (np.array([1.e5, 1.e15]),
                       np.array([1., 1.]))

    model.write(random_filename())
    model.run(random_filename())