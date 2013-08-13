from setuptools import setup, find_packages

setup(name='HyTest',
      version='0.1.0',
      author='Thomas Stephens',
      author_email='spiralman@gmail.com',
      description='Simplify unit testing in Hy',
      license='MIT',
      packages=find_packages(),
      entry_points={
          'nose.plugins.0.10': [
              'hynose = hynose.hynose:HyNose'
          ]
      })
