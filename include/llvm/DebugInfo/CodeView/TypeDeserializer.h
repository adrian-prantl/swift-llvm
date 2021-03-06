//===- TypeDeserializer.h ---------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DEBUGINFO_CODEVIEW_TYPEDESERIALIZER_H
#define LLVM_DEBUGINFO_CODEVIEW_TYPEDESERIALIZER_H

#include "llvm/DebugInfo/CodeView/TypeVisitorCallbacks.h"
#include "llvm/Support/Error.h"

namespace llvm {
namespace codeview {
class TypeDeserializerBase : public TypeVisitorCallbacks {
public:
  explicit TypeDeserializerBase(TypeVisitorCallbacks &Recipient)
      : Recipient(Recipient) {}

  Error visitTypeBegin(const CVRecord<TypeLeafKind> &Record) override {
    return Recipient.visitTypeBegin(Record);
  }

  Error visitTypeEnd(const CVRecord<TypeLeafKind> &Record) override {
    return Recipient.visitTypeEnd(Record);
  }

#define TYPE_RECORD(EnumName, EnumVal, Name)                                   \
  Error visitKnownRecord(const CVRecord<TypeLeafKind> &CVR,                    \
                         Name##Record &Record) override {                      \
    return defaultVisitKnownRecord(CVR, Record);                               \
  }
#define MEMBER_RECORD(EnumName, EnumVal, Name)                                 \
  TYPE_RECORD(EnumName, EnumVal, Name)
#define TYPE_RECORD_ALIAS(EnumName, EnumVal, Name, AliasName)
#define MEMBER_RECORD_ALIAS(EnumName, EnumVal, Name, AliasName)
#include "TypeRecords.def"

protected:
  TypeVisitorCallbacks &Recipient;

  template <typename T>
  Error deserializeRecord(ArrayRef<uint8_t> &Data, TypeLeafKind Kind,
                          T &Record) const {
    TypeRecordKind RK = static_cast<TypeRecordKind>(Kind);
    auto ExpectedRecord = T::deserialize(RK, Data);
    if (!ExpectedRecord)
      return ExpectedRecord.takeError();
    Record = std::move(*ExpectedRecord);
    return Error::success();
  }

private:
  template <typename T>
  Error defaultVisitKnownRecord(const CVRecord<TypeLeafKind> &CVR, T &Record) {
    ArrayRef<uint8_t> RD = CVR.Data;
    if (auto EC = deserializeRecord(RD, CVR.Type, Record))
      return EC;
    return Recipient.visitKnownRecord(CVR, Record);
  }
};

class TypeDeserializer : public TypeDeserializerBase {
public:
  explicit TypeDeserializer(TypeVisitorCallbacks &Recipient)
      : TypeDeserializerBase(Recipient) {}

  /// FieldList records need special handling.  For starters, they do not
  /// describe their own length, so a different extraction algorithm is
  /// necessary.  Secondly, a single FieldList record will result in the
  /// deserialization of many records.  So even though the top level visitor
  /// calls visitFieldBegin() on a single record, multiple records get visited
  /// through the callback interface.
  Error visitKnownRecord(const CVRecord<TypeLeafKind> &CVR,
                         FieldListRecord &Record) override;

private:
  template <typename T>
  Error visitKnownMember(ArrayRef<uint8_t> &Data, TypeLeafKind Kind,
                         T &Record) {
    ArrayRef<uint8_t> OldData = Data;
    if (auto EC = deserializeRecord(Data, Kind, Record))
      return EC;
    assert(Data.size() < OldData.size());

    CVRecord<TypeLeafKind> CVR;
    CVR.Length = OldData.size() - Data.size();
    CVR.Data = OldData.slice(0, CVR.Length);
    CVR.RawData = CVR.Data;
    return Recipient.visitKnownRecord(CVR, Record);
  }

  Error skipPadding(ArrayRef<uint8_t> &Data);
};
}
}

#endif
