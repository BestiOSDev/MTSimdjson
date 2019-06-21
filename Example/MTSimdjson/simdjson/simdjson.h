#ifndef  SIMDJSON_ERR_H
# define SIMDJSON_ERR_H

#include <string>

struct simdjson {
  enum errorValues {
    SUCCESS = 0,
    CAPACITY = 1, // This ParsedJson can't support a document that big
    MEMALLOC = 2, // Error allocating memory, most likely out of memory
    TAPE_ERROR = 3, // Something went wrong while writing to the tape (stage 2), this is a generic error
    DEPTH_ERROR = 4, // Your document exceeds the user-specified depth limitation
    STRING_ERROR = 5, // Problem while parsing a string
    T_ATOM_ERROR = 6, // Problem while parsing an atom starting with the letter 't'
    F_ATOM_ERROR, // Problem while parsing an atom starting with the letter 'f'
    N_ATOM_ERROR, // Problem while parsing an atom starting with the letter 'n'
    NUMBER_ERROR, // Problem while parsing a number
    UTF8_ERROR, // the input is not valid UTF-8
    UNITIALIZED, // unknown error, or uninitialized document
    EMPTY, // no structural document found
    UNESCAPED_CHARS, // found unescaped characters in a string.
    UNCLOSED_STRING, // missing quote at the end
    UNEXPECTED_ERROR // indicative of a bug in simdjson
  };
  static const std::string& errorMsg(const int);
};

#endif
