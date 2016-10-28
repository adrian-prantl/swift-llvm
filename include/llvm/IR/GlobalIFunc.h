//===-------- llvm/GlobalIFunc.h - GlobalIFunc class ------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \brief
/// This file contains the declaration of the GlobalIFunc class, which
/// represents a single indirect function in the IR. Indirect function uses
/// ELF symbol type extension to mark that the address of a declaration should
/// be resolved at runtime by calling a resolver function.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_IR_GLOBALIFUNC_H
#define LLVM_IR_GLOBALIFUNC_H

#include "llvm/ADT/ilist_node.h"
#include "llvm/IR/GlobalIndirectSymbol.h"

namespace llvm {

class Twine;
class Module;

// Traits class for using GlobalIFunc in symbol table in Module.
template <typename ValueSubClass> class SymbolTableListTraits;

class GlobalIFunc final : public GlobalIndirectSymbol,
                          public ilist_node<GlobalIFunc> {
  friend class SymbolTableListTraits<GlobalIFunc>;
  void operator=(const GlobalIFunc &) = delete;
  GlobalIFunc(const GlobalIFunc &) = delete;

  GlobalIFunc(Type *Ty, unsigned AddressSpace, LinkageTypes Linkage,
              const Twine &Name, Constant *Resolver, Module *Parent);

public:
  /// If a parent module is specified, the ifunc is automatically inserted into
  /// the end of the specified module's ifunc list.
  static GlobalIFunc *create(Type *Ty, unsigned AddressSpace,
                             LinkageTypes Linkage, const Twine &Name,
                             Constant *Resolver, Module *Parent);

  /// This method unlinks 'this' from the containing module, but does not
  /// delete it.
  void removeFromParent() final;

  /// This method unlinks 'this' from the containing module and deletes it.
  void eraseFromParent() final;

  /// These methods retrieve and set ifunc resolver function.
  void setResolver(Constant *Resolver) {
    setIndirectSymbol(Resolver);
  }
  const Constant *getResolver() const {
    return getIndirectSymbol();
  }
  Constant *getResolver() {
    return getIndirectSymbol();
  }

  // Methods for support type inquiry through isa, cast, and dyn_cast:
  static inline bool classof(const Value *V) {
    return V->getValueID() == Value::GlobalIFuncVal;
  }
};

} // End llvm namespace

#endif
