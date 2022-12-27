# cython: language_level=3, boundscheck=False, wraparound=False, initializedcheck=False, nonecheck=False

cimport cython
from cpython cimport PyObject
from libcpp.vector cimport vector
from libcpp.string cimport string
from libcpp cimport bool

cdef extern from "<Python.h>":
    # https://docs.python.org/3/c-api/unicode.html
    cdef char* PyUnicode_AsUTF8(str) nogil
    cdef PyObject* PyUnicode_FromString(char*) nogil
    # https://docs.python.org/3/c-api/list.html
    cdef list PyList_New(Py_ssize_t) nogil
    cdef void PyList_SET_ITEM(list, Py_ssize_t, PyObject*) nogil

cdef extern from "<tokenizer/config.h>":
    cdef string DICT_PATH

cdef extern from "<tokenizer/token.hpp>":
    cdef cppclass FullToken:
        string text

cdef extern from "<tokenizer/tokenizer.hpp>":
    cdef cppclass Tokenizer:
        @staticmethod
        Tokenizer &instance() nogil
        int initialize(string, bool) nogil
        vector[FullToken] segment_general(string, int) nogil

cdef class PyTokenizer(object):
    cdef Tokenizer __tokenizer

    def __cinit__(self, bool load_nontone_data = True):
        assert self.__tokenizer.instance().initialize(DICT_PATH, load_nontone_data) >= 0, "failed to initialize tokenizer"

    cdef list __word_tokenize(self, str original_text, int tokenize_option):
        cdef string text = <string> PyUnicode_AsUTF8(original_text)

        cdef vector[FullToken] tokens = self.__tokenizer.instance().segment_general(text, tokenize_option)

        cdef Py_ssize_t n = tokens.size(), i
        cdef list output = PyList_New(n)
        for i from 0 <= i < n:
            PyList_SET_ITEM(output, i, PyUnicode_FromString(tokens[i].text.c_str()))

        return output

    def word_tokenize(self, str original_text, int tokenize_option = 0):
        return self.__word_tokenize(original_text, tokenize_option)
