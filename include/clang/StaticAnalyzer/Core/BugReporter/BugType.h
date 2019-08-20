//===---  BugType.h - Bug Information Description ---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//  This file defines BugType, a class representing a bug type.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CLANG_STATICANALYZER_CORE_BUGREPORTER_BUGTYPE_H
#define LLVM_CLANG_STATICANALYZER_CORE_BUGREPORTER_BUGTYPE_H

#include "clang/Basic/LLVM.h"
#include "clang/StaticAnalyzer/Core/BugReporter/CommonBugCategories.h"
#include "clang/StaticAnalyzer/Core/Checker.h"
#include <string>

namespace clang {

namespace ento {

class BugReporter;
class ExplodedNode;
class ExprEngine;

class BugType {
private:
  const CheckName Check;
  const std::string Name;
  const std::string Category;
  const CheckerBase *Checker;
  bool SuppressOnSink;

  virtual void anchor();

public:
  BugType(CheckName Check, StringRef Name, StringRef Cat,
          bool SuppressOnSink=false)
      : Check(Check), Name(Name), Category(Cat), Checker(nullptr),
        SuppressOnSink(SuppressOnSink) {}
  BugType(const CheckerBase *Checker, StringRef Name, StringRef Cat,
          bool SuppressOnSink=false)
      : Check(Checker->getCheckName()), Name(Name), Category(Cat),
        Checker(Checker), SuppressOnSink(SuppressOnSink) {}
  virtual ~BugType() = default;

  StringRef getName() const { return Name; }
  StringRef getCategory() const { return Category; }
  StringRef getCheckName() const {
    // FIXME: This is a workaround to ensure that the correct check name is used
    // The check names are set after the constructors are run.
    // In case the BugType object is initialized in the checker's ctor
    // the Check field will be empty. To circumvent this problem we use
    // CheckerBase whenever it is possible.
    StringRef CheckName =
        Checker ? Checker->getCheckName().getName() : Check.getName();
    assert(!CheckName.empty() && "Check name is not set properly.");
    return CheckName;
  }

  /// isSuppressOnSink - Returns true if bug reports associated with this bug
  ///  type should be suppressed if the end node of the report is post-dominated
  ///  by a sink node.
  bool isSuppressOnSink() const { return SuppressOnSink; }
};

class BuiltinBug : public BugType {
  const std::string desc;
  void anchor() override;
public:
  BuiltinBug(class CheckName check, const char *name, const char *description)
      : BugType(check, name, categories::LogicError), desc(description) {}

  BuiltinBug(const CheckerBase *checker, const char *name,
             const char *description)
      : BugType(checker, name, categories::LogicError), desc(description) {}

  BuiltinBug(const CheckerBase *checker, const char *name)
      : BugType(checker, name, categories::LogicError), desc(name) {}

  StringRef getDescription() const { return desc; }
};

} // end ento namespace

} // end clang namespace
#endif
