//===- llvm/ADT/SmallString.h - 'Normally small' strings --------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the SmallString class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_ADT_SMALLSTRING_H
#define LLVM_ADT_SMALLSTRING_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"

namespace llvm {

/// SmallString - A SmallString is just a SmallVector with methods and accessors
/// that make it work better as a string (e.g. operator+ etc).
template<unsigned InternalLen>
class SmallString : public SmallVector<char, InternalLen> {
public:
  /// Default ctor - Initialize to empty.
  SmallString() {}

  /// Initialize from a StringRef.
  SmallString(StringRef S) : SmallVector<char, InternalLen>(S.begin(), S.end()) {}

  /// Initialize with a range.
  template<typename ItTy>
  SmallString(ItTy S, ItTy E) : SmallVector<char, InternalLen>(S, E) {}

  /// Copy ctor.
  SmallString(const SmallString &RHS) : SmallVector<char, InternalLen>(RHS) {}

  // Note that in order to add new overloads for append & assign, we have to
  // duplicate the inherited versions so as not to inadvertently hide them.

  /// @}
  /// @name String Assignment
  /// @{

  /// Assign from a repeated element
  void assign(size_t NumElts, char Elt) {
    this->SmallVectorImpl<char>::assign(NumElts, Elt);
  }

  /// Assign from an iterator pair
  template<typename in_iter>
  void assign(in_iter S, in_iter E) {
    this->clear();
    SmallVectorImpl<char>::append(S, E);
  }

  /// Assign from a StringRef
  void assign(StringRef RHS) {
    this->clear();
    SmallVectorImpl<char>::append(RHS.begin(), RHS.end());
  }

  /// Assign from a SmallVector
  void assign(const SmallVectorImpl<char> &RHS) {
    this->clear();
    SmallVectorImpl<char>::append(RHS.begin(), RHS.end());
  }

  /// @}
  /// @name String Concatenation
  /// @{

  /// Append from an iterator pair
  template<typename in_iter>
  void append(in_iter S, in_iter E) {
    SmallVectorImpl<char>::append(S, E);
  }
  
  void append(size_t NumInputs, char Elt) {
    SmallVectorImpl<char>::append(NumInputs, Elt);
  }


  /// Append from a StringRef
  void append(StringRef RHS) {
    SmallVectorImpl<char>::append(RHS.begin(), RHS.end());
  }

  /// Append from a SmallVector
  void append(const SmallVectorImpl<char> &RHS) {
    SmallVectorImpl<char>::append(RHS.begin(), RHS.end());
  }

  /// @}
  /// @name String Comparison
  /// @{

  /// equals - Check for string equality, this is more efficient than
  /// compare() when the relative ordering of inequal strings isn't needed.
  bool equals(StringRef RHS) const {
    return str().equals(RHS);
  }

  /// equals_lower - Check for string equality, ignoring case.
  bool equals_lower(StringRef RHS) const {
    return str().equals_lower(RHS);
  }

  /// compare - Compare two strings; the result is -1, 0, or 1 if this string
  /// is lexicographically less than, equal to, or greater than the \arg RHS.
  int compare(StringRef RHS) const {
    return str().compare(RHS);
  }

  /// compare_lower - Compare two strings, ignoring case.
  int compare_lower(StringRef RHS) const {
    return str().compare_lower(RHS);
  }

  /// compare_numeric - Compare two strings, treating sequences of digits as
  /// numbers.
  int compare_numeric(StringRef RHS) const {
    return str().compare_numeric(RHS);
  }

  /// @}
  /// @name String Predicates
  /// @{

  /// startswith - Check if this string starts with the given \arg Prefix.
  bool startswith(StringRef Prefix) const {
    return str().startswith(Prefix);
  }

  /// endswith - Check if this string ends with the given \arg Suffix.
  bool endswith(StringRef Suffix) const {
    return str().endswith(Suffix);
  }

  /// @}
  /// @name String Searching
  /// @{

  /// find - Search for the first character \arg C in the string.
  ///
  /// \return - The index of the first occurrence of \arg C, or npos if not
  /// found.
  size_t find(char C, size_t From = 0) const {
    return str().find(C, From);
  }

  /// find - Search for the first string \arg Str in the string.
  ///
  /// \return - The index of the first occurrence of \arg Str, or npos if not
  /// found.
  size_t find(StringRef Str, size_t From = 0) const {
    return str().find(Str, From);
  }

  /// rfind - Search for the last character \arg C in the string.
  ///
  /// \return - The index of the last occurrence of \arg C, or npos if not
  /// found.
  size_t rfind(char C, size_t From = StringRef::npos) const {
    return str().rfind(C, From);
  }

  /// rfind - Search for the last string \arg Str in the string.
  ///
  /// \return - The index of the last occurrence of \arg Str, or npos if not
  /// found.
  size_t rfind(StringRef Str) const {
    return str().rfind(Str);
  }

  /// find_first_of - Find the first character in the string that is \arg C,
  /// or npos if not found. Same as find.
  size_t find_first_of(char C, size_t From = 0) const {
    return str().find_first_of(C, From);
  }

  /// find_first_of - Find the first character in the string that is in \arg
  /// Chars, or npos if not found.
  ///
  /// Note: O(size() + Chars.size())
  size_t find_first_of(StringRef Chars, size_t From = 0) const {
    return str().find_first_of(Chars, From);
  }

  /// find_first_not_of - Find the first character in the string that is not
  /// \arg C or npos if not found.
  size_t find_first_not_of(char C, size_t From = 0) const {
    return str().find_first_not_of(C, From);
  }

  /// find_first_not_of - Find the first character in the string that is not
  /// in the string \arg Chars, or npos if not found.
  ///
  /// Note: O(size() + Chars.size())
  size_t find_first_not_of(StringRef Chars, size_t From = 0) const {
    return str().find_first_not_of(Chars, From);
  }

  /// find_last_of - Find the last character in the string that is \arg C, or
  /// npos if not found.
  size_t find_last_of(char C, size_t From = StringRef::npos) const {
    return str().find_last_of(C, From);
  }

  /// find_last_of - Find the last character in the string that is in \arg C,
  /// or npos if not found.
  ///
  /// Note: O(size() + Chars.size())
  size_t find_last_of(
      StringRef Chars, size_t From = StringRef::npos) const {
    return str().find_last_of(Chars, From);
  }

  /// @}
  /// @name Helpful Algorithms
  /// @{

  /// count - Return the number of occurrences of \arg C in the string.
  size_t count(char C) const {
    return str().count(C);
  }

  /// count - Return the number of non-overlapped occurrences of \arg Str in
  /// the string.
  size_t count(StringRef Str) const {
    return str().count(Str);
  }

  /// @}
  /// @name Substring Operations
  /// @{

  /// substr - Return a reference to the substring from [Start, Start + N).
  ///
  /// \param Start - The index of the starting character in the substring; if
  /// the index is npos or greater than the length of the string then the
  /// empty substring will be returned.
  ///
  /// \param N - The number of characters to included in the substring. If N
  /// exceeds the number of characters remaining in the string, the string
  /// suffix (starting with \arg Start) will be returned.
  StringRef substr(size_t Start, size_t N = StringRef::npos) const {
    return str().substr(Start, N);
  }

  /// slice - Return a reference to the substring from [Start, End).
  ///
  /// \param Start - The index of the starting character in the substring; if
  /// the index is npos or greater than the length of the string then the
  /// empty substring will be returned.
  ///
  /// \param End - The index following the last character to include in the
  /// substring. If this is npos, or less than \arg Start, or exceeds the
  /// number of characters remaining in the string, the string suffix
  /// (starting with \arg Start) will be returned.
  StringRef slice(size_t Start, size_t End) const {
    return str().slice(Start, End);
  }

  // Extra methods.

  /// Explicit conversion to StringRef
  StringRef str() const { return StringRef(this->begin(), this->size()); }

  // TODO: Make this const, if it's safe...
  const char* c_str() {
    this->push_back(0);
    this->pop_back();
    return this->data();
  }

  /// Implicit conversion to StringRef.
  operator StringRef() const { return str(); }

  // Extra operators.
  const SmallString &operator=(StringRef RHS) {
    this->clear();
    return *this += RHS;
  }

  SmallString &operator+=(StringRef RHS) {
    this->append(RHS.begin(), RHS.end());
    return *this;
  }
  SmallString &operator+=(char C) {
    this->push_back(C);
    return *this;
  }
};

}

#endif
