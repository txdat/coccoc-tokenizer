from setuptools import setup
from Cython.Build import cythonize


setup(
    name = "CocCocTokenizer",
    version = "1.4",
    description = "high performance tokenizer for Vietnamese language",
    long_description = "high performance tokenizer for Vietnamese language",
    author = "Le Anh Duc",
    author_email = "anhducle@coccoc.com",
    url = "https://github.com/coccoc/coccoc-tokenizer",
    license = "GNU Lesser General Public License v3",
    ext_modules = cythonize("CocCocTokenizer.pyx", language="c++"),
)
