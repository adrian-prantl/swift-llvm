; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=corei7-avx -mattr=+avx | FileCheck %s

; Verify that the backend correctly folds a sign/zero extend of a vector where
; elements are all constant values or UNDEFs.
; The backend should be able to optimize all the test functions below into
; simple loads from constant pool of the result. That is because the resulting
; vector should be known at static time.

define <4 x i16> @test1() {
; CHECK-LABEL: test1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = [0,4294967295,2,4294967293]
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 0, i32 0
  %2 = insertelement <4 x i8> %1, i8 -1, i32 1
  %3 = insertelement <4 x i8> %2, i8 2, i32 2
  %4 = insertelement <4 x i8> %3, i8 -3, i32 3
  %5 = sext <4 x i8> %4 to <4 x i16>
  ret <4 x i16> %5
}

define <4 x i16> @test2() {
; CHECK-LABEL: test2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = <u,4294967295,u,4294967293>
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 undef, i32 0
  %2 = insertelement <4 x i8> %1, i8 -1, i32 1
  %3 = insertelement <4 x i8> %2, i8 undef, i32 2
  %4 = insertelement <4 x i8> %3, i8 -3, i32 3
  %5 = sext <4 x i8> %4 to <4 x i16>
  ret <4 x i16> %5
}

define <4 x i32> @test3() {
; CHECK-LABEL: test3:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = [0,4294967295,2,4294967293]
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 0, i32 0
  %2 = insertelement <4 x i8> %1, i8 -1, i32 1
  %3 = insertelement <4 x i8> %2, i8 2, i32 2
  %4 = insertelement <4 x i8> %3, i8 -3, i32 3
  %5 = sext <4 x i8> %4 to <4 x i32>
  ret <4 x i32> %5
}

define <4 x i32> @test4() {
; CHECK-LABEL: test4:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = <u,4294967295,u,4294967293>
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 undef, i32 0
  %2 = insertelement <4 x i8> %1, i8 -1, i32 1
  %3 = insertelement <4 x i8> %2, i8 undef, i32 2
  %4 = insertelement <4 x i8> %3, i8 -3, i32 3
  %5 = sext <4 x i8> %4 to <4 x i32>
  ret <4 x i32> %5
}

define <4 x i64> @test5() {
; CHECK-LABEL: test5:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} ymm0 = [0,18446744073709551615,2,18446744073709551613]
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 0, i32 0
  %2 = insertelement <4 x i8> %1, i8 -1, i32 1
  %3 = insertelement <4 x i8> %2, i8 2, i32 2
  %4 = insertelement <4 x i8> %3, i8 -3, i32 3
  %5 = sext <4 x i8> %4 to <4 x i64>
  ret <4 x i64> %5
}

define <4 x i64> @test6() {
; CHECK-LABEL: test6:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} ymm0 = <u,18446744073709551615,u,18446744073709551613>
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 undef, i32 0
  %2 = insertelement <4 x i8> %1, i8 -1, i32 1
  %3 = insertelement <4 x i8> %2, i8 undef, i32 2
  %4 = insertelement <4 x i8> %3, i8 -3, i32 3
  %5 = sext <4 x i8> %4 to <4 x i64>
  ret <4 x i64> %5
}

define <8 x i16> @test7() {
; CHECK-LABEL: test7:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = <0,65535,2,65533,u,u,u,u>
; CHECK-NEXT:    retq
  %1 = insertelement <8 x i8> undef, i8 0, i32 0
  %2 = insertelement <8 x i8> %1, i8 -1, i32 1
  %3 = insertelement <8 x i8> %2, i8 2, i32 2
  %4 = insertelement <8 x i8> %3, i8 -3, i32 3
  %5 = insertelement <8 x i8> %4, i8 4, i32 4
  %6 = insertelement <8 x i8> %5, i8 -5, i32 5
  %7 = insertelement <8 x i8> %6, i8 6, i32 6
  %8 = insertelement <8 x i8> %7, i8 -7, i32 7
  %9 = sext <8 x i8> %4 to <8 x i16>
  ret <8 x i16> %9
}

define <8 x i32> @test8() {
; CHECK-LABEL: test8:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} ymm0 = <0,4294967295,2,4294967293,u,u,u,u>
; CHECK-NEXT:    retq
  %1 = insertelement <8 x i8> undef, i8 0, i32 0
  %2 = insertelement <8 x i8> %1, i8 -1, i32 1
  %3 = insertelement <8 x i8> %2, i8 2, i32 2
  %4 = insertelement <8 x i8> %3, i8 -3, i32 3
  %5 = insertelement <8 x i8> %4, i8 4, i32 4
  %6 = insertelement <8 x i8> %5, i8 -5, i32 5
  %7 = insertelement <8 x i8> %6, i8 6, i32 6
  %8 = insertelement <8 x i8> %7, i8 -7, i32 7
  %9 = sext <8 x i8> %4 to <8 x i32>
  ret <8 x i32> %9
}

define <8 x i16> @test9() {
; CHECK-LABEL: test9:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = <u,65535,u,65533,u,u,u,u>
; CHECK-NEXT:    retq
  %1 = insertelement <8 x i8> undef, i8 undef, i32 0
  %2 = insertelement <8 x i8> %1, i8 -1, i32 1
  %3 = insertelement <8 x i8> %2, i8 undef, i32 2
  %4 = insertelement <8 x i8> %3, i8 -3, i32 3
  %5 = insertelement <8 x i8> %4, i8 undef, i32 4
  %6 = insertelement <8 x i8> %5, i8 -5, i32 5
  %7 = insertelement <8 x i8> %6, i8 undef, i32 6
  %8 = insertelement <8 x i8> %7, i8 -7, i32 7
  %9 = sext <8 x i8> %4 to <8 x i16>
  ret <8 x i16> %9
}

define <8 x i32> @test10() {
; CHECK-LABEL: test10:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} ymm0 = <0,u,2,u,u,u,u,u>
; CHECK-NEXT:    retq
  %1 = insertelement <8 x i8> undef, i8 0, i32 0
  %2 = insertelement <8 x i8> %1, i8 undef, i32 1
  %3 = insertelement <8 x i8> %2, i8 2, i32 2
  %4 = insertelement <8 x i8> %3, i8 undef, i32 3
  %5 = insertelement <8 x i8> %4, i8 4, i32 4
  %6 = insertelement <8 x i8> %5, i8 undef, i32 5
  %7 = insertelement <8 x i8> %6, i8 6, i32 6
  %8 = insertelement <8 x i8> %7, i8 undef, i32 7
  %9 = sext <8 x i8> %4 to <8 x i32>
  ret <8 x i32> %9
}

define <4 x i16> @test11() {
; CHECK-LABEL: test11:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = [0,255,2,253]
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 0, i32 0
  %2 = insertelement <4 x i8> %1, i8 -1, i32 1
  %3 = insertelement <4 x i8> %2, i8 2, i32 2
  %4 = insertelement <4 x i8> %3, i8 -3, i32 3
  %5 = zext <4 x i8> %4 to <4 x i16>
  ret <4 x i16> %5
}

define <4 x i32> @test12() {
; CHECK-LABEL: test12:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = [0,255,2,253]
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 0, i32 0
  %2 = insertelement <4 x i8> %1, i8 -1, i32 1
  %3 = insertelement <4 x i8> %2, i8 2, i32 2
  %4 = insertelement <4 x i8> %3, i8 -3, i32 3
  %5 = zext <4 x i8> %4 to <4 x i32>
  ret <4 x i32> %5
}

define <4 x i64> @test13() {
; CHECK-LABEL: test13:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} ymm0 = [0,255,2,253]
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 0, i32 0
  %2 = insertelement <4 x i8> %1, i8 -1, i32 1
  %3 = insertelement <4 x i8> %2, i8 2, i32 2
  %4 = insertelement <4 x i8> %3, i8 -3, i32 3
  %5 = zext <4 x i8> %4 to <4 x i64>
  ret <4 x i64> %5
}

define <4 x i16> @test14() {
; CHECK-LABEL: test14:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = <u,255,u,253>
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 undef, i32 0
  %2 = insertelement <4 x i8> %1, i8 -1, i32 1
  %3 = insertelement <4 x i8> %2, i8 undef, i32 2
  %4 = insertelement <4 x i8> %3, i8 -3, i32 3
  %5 = zext <4 x i8> %4 to <4 x i16>
  ret <4 x i16> %5
}

define <4 x i32> @test15() {
; CHECK-LABEL: test15:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = <0,u,2,u>
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 0, i32 0
  %2 = insertelement <4 x i8> %1, i8 undef, i32 1
  %3 = insertelement <4 x i8> %2, i8 2, i32 2
  %4 = insertelement <4 x i8> %3, i8 undef, i32 3
  %5 = zext <4 x i8> %4 to <4 x i32>
  ret <4 x i32> %5
}

define <4 x i64> @test16() {
; CHECK-LABEL: test16:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} ymm0 = <u,255,2,u>
; CHECK-NEXT:    retq
  %1 = insertelement <4 x i8> undef, i8 undef, i32 0
  %2 = insertelement <4 x i8> %1, i8 -1, i32 1
  %3 = insertelement <4 x i8> %2, i8 2, i32 2
  %4 = insertelement <4 x i8> %3, i8 undef, i32 3
  %5 = zext <4 x i8> %4 to <4 x i64>
  ret <4 x i64> %5
}

define <8 x i16> @test17() {
; CHECK-LABEL: test17:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = [0,255,2,253,4,251,6,249]
; CHECK-NEXT:    retq
  %1 = insertelement <8 x i8> undef, i8 0, i32 0
  %2 = insertelement <8 x i8> %1, i8 -1, i32 1
  %3 = insertelement <8 x i8> %2, i8 2, i32 2
  %4 = insertelement <8 x i8> %3, i8 -3, i32 3
  %5 = insertelement <8 x i8> %4, i8 4, i32 4
  %6 = insertelement <8 x i8> %5, i8 -5, i32 5
  %7 = insertelement <8 x i8> %6, i8 6, i32 6
  %8 = insertelement <8 x i8> %7, i8 -7, i32 7
  %9 = zext <8 x i8> %8 to <8 x i16>
  ret <8 x i16> %9
}

define <8 x i32> @test18() {
; CHECK-LABEL: test18:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} ymm0 = [0,255,2,253,4,251,6,249]
; CHECK-NEXT:    retq
  %1 = insertelement <8 x i8> undef, i8 0, i32 0
  %2 = insertelement <8 x i8> %1, i8 -1, i32 1
  %3 = insertelement <8 x i8> %2, i8 2, i32 2
  %4 = insertelement <8 x i8> %3, i8 -3, i32 3
  %5 = insertelement <8 x i8> %4, i8 4, i32 4
  %6 = insertelement <8 x i8> %5, i8 -5, i32 5
  %7 = insertelement <8 x i8> %6, i8 6, i32 6
  %8 = insertelement <8 x i8> %7, i8 -7, i32 7
  %9 = zext <8 x i8> %8 to <8 x i32>
  ret <8 x i32> %9
}

define <8 x i16> @test19() {
; CHECK-LABEL: test19:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = <u,255,u,253,u,251,u,249>
; CHECK-NEXT:    retq
  %1 = insertelement <8 x i8> undef, i8 undef, i32 0
  %2 = insertelement <8 x i8> %1, i8 -1, i32 1
  %3 = insertelement <8 x i8> %2, i8 undef, i32 2
  %4 = insertelement <8 x i8> %3, i8 -3, i32 3
  %5 = insertelement <8 x i8> %4, i8 undef, i32 4
  %6 = insertelement <8 x i8> %5, i8 -5, i32 5
  %7 = insertelement <8 x i8> %6, i8 undef, i32 6
  %8 = insertelement <8 x i8> %7, i8 -7, i32 7
  %9 = zext <8 x i8> %8 to <8 x i16>
  ret <8 x i16> %9
}

define <8 x i32> @test20() {
; CHECK-LABEL: test20:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovaps {{.*#+}} ymm0 = <0,u,2,253,4,u,6,u>
; CHECK-NEXT:    retq
  %1 = insertelement <8 x i8> undef, i8 0, i32 0
  %2 = insertelement <8 x i8> %1, i8 undef, i32 1
  %3 = insertelement <8 x i8> %2, i8 2, i32 2
  %4 = insertelement <8 x i8> %3, i8 -3, i32 3
  %5 = insertelement <8 x i8> %4, i8 4, i32 4
  %6 = insertelement <8 x i8> %5, i8 undef, i32 5
  %7 = insertelement <8 x i8> %6, i8 6, i32 6
  %8 = insertelement <8 x i8> %7, i8 undef, i32 7
  %9 = zext <8 x i8> %8 to <8 x i32>
  ret <8 x i32> %9
}
