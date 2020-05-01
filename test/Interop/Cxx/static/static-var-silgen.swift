// RUN: %target-swift-emit-sil -I %S/Inputs -enable-cxx-interop %s | %FileCheck %s

import StaticVar

func initStaticVars() -> CInt {
  return staticVar + staticVarInit + staticVarInlineInit + staticConst + staticConstInit
    + staticConstInlineInit + staticConstexpr + staticNonTrivial.val + staticConstNonTrivial.val
    + staticConstexprNonTrivial.val
}

// CHECK: sil_global @staticVar : $Int32
// CHECK: sil_global @staticVarInit : $Int32
// CHECK: sil_global @staticVarInlineInit : $Int32
// CHECK: sil_global [let] @staticConst : $Int32
// CHECK: sil_global [let] @staticConstInit : $Int32
// CHECK: sil_global [let] @staticConstInlineInit : $Int32
// CHECK: sil_global [let] @staticConstexpr : $Int32
// CHECK: sil_global @staticNonTrivial : $NonTrivial
// CHECK: sil_global [let] @staticConstNonTrivial : $NonTrivial
// CHECK: sil_global [let] @staticConstexprNonTrivial : $NonTrivial

func readStaticVar() -> CInt {
  return staticVar
}

// CHECK: sil hidden @$s4main13readStaticVars5Int32VyF : $@convention(thin) () -> Int32
// CHECK: [[ADDR:%.*]] = global_addr @staticVar : $*Int32
// CHECK: [[ACCESS:%.*]] = begin_access [read] [dynamic] [[ADDR]] : $*Int32
// CHECK: [[VALUE:%.*]] = load [[ACCESS]] : $*Int32
// CHECK: return [[VALUE]] : $Int32

func writeStaticVar(_ v: CInt) {
  staticVar = v
}

// CHECK: sil hidden @$s4main14writeStaticVaryys5Int32VF : $@convention(thin) (Int32) -> ()
// CHECK: [[ADDR:%.*]] = global_addr @staticVar : $*Int32
// CHECK: [[ACCESS:%.*]] = begin_access [modify] [dynamic] [[ADDR]] : $*Int32
// CHECK: store %0 to [[ACCESS]] : $*Int32

func readStaticNonTrivial() -> NonTrivial {
  return staticNonTrivial
}

// CHECK: sil hidden @$s4main20readStaticNonTrivialSo0dE0VyF : $@convention(thin) () -> NonTrivial
// CHECK: [[ADDR:%.*]] = global_addr @staticNonTrivial : $*NonTrivial
// CHECK: [[ACCESS:%.*]] = begin_access [read] [dynamic] [[ADDR]] : $*NonTrivial
// CHECK: [[VALUE:%.*]] = load [[ACCESS]] : $*NonTrivial
// CHECK: return [[VALUE]] : $NonTrivial

func writeStaticNonTrivial(_ i: NonTrivial) {
  staticNonTrivial = i
}

// CHECK: sil hidden @$s4main21writeStaticNonTrivialyySo0dE0VF : $@convention(thin) (NonTrivial) -> ()
// CHECK: [[ADDR:%.*]] = global_addr @staticNonTrivial : $*NonTrivial
// CHECK: [[ACCESS:%.*]] = begin_access [modify] [dynamic] [[ADDR]] : $*NonTrivial
// CHECK: store %0 to [[ACCESS]] : $*NonTrivial

func modifyInout(_ c: inout CInt) {
  c = 42
}

func passingVarAsInout() {
  modifyInout(&staticVar)
}

// CHECK: sil hidden @$s4main17passingVarAsInoutyyF : $@convention(thin) () -> ()
// CHECK: [[ADDR:%.*]] = global_addr @staticVar : $*Int32
// CHECK: [[ACCESS:%.*]] = begin_access [modify] [dynamic] [[ADDR]] : $*Int32
// CHECK: [[FUNC:%.*]] = function_ref @$s4main11modifyInoutyys5Int32VzF : $@convention(thin) (@inout Int32) -> ()
// CHECK: apply [[FUNC]]([[ACCESS]]) : $@convention(thin) (@inout Int32) -> ()
