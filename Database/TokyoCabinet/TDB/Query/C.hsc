{-# LANGUAGE ForeignFunctionInterface, EmptyDataDecls #-}
module Database.TokyoCabinet.TDB.Query.C where

import Data.Word

import Foreign.Ptr
import Foreign.C.Types
import Foreign.C.String

import Database.TokyoCabinet.Map.C
import Database.TokyoCabinet.List.C

#include <tctdb.h>

data Condition =
    QCSTREQ   |
    QCSTRINC  |
    QCSTRBW   |
    QCSTREW   |
    QCSTRAND  |
    QCSTROR   |
    QCSTROREQ |
    QCSTRRX   |
    QCNUMEQ   |
    QCNUMGT   |
    QCNUMGE   |
    QCNUMLT   |
    QCNUMLE   |
    QCNUMBT   |
    QCNUMOREQ |
    QCNEGATE  |
    QCNOIDX
    deriving (Eq, Ord, Show)

data OrderType =
    QOSTRASC  |
    QOSTRDESC |
    QONUMASC  |
    QONUMDESC
    deriving (Eq, Ord, Show)

data PostTreatment =
    QPPUT  |
    QPOUT  |
    QPSTOP
    deriving (Eq, Ord, Show)

condToCInt :: Condition -> CInt
condToCInt QCSTREQ   = #const TDBQCSTREQ
condToCInt QCSTRINC  = #const TDBQCSTRINC
condToCInt QCSTRBW   = #const TDBQCSTRBW
condToCInt QCSTREW   = #const TDBQCSTREW
condToCInt QCSTRAND  = #const TDBQCSTRAND
condToCInt QCSTROR   = #const TDBQCSTROR
condToCInt QCSTROREQ = #const TDBQCSTROREQ
condToCInt QCSTRRX   = #const TDBQCSTRRX
condToCInt QCNUMEQ   = #const TDBQCNUMEQ
condToCInt QCNUMGT   = #const TDBQCNUMGT
condToCInt QCNUMGE   = #const TDBQCNUMGE
condToCInt QCNUMLT   = #const TDBQCNUMLT
condToCInt QCNUMLE   = #const TDBQCNUMLE
condToCInt QCNUMBT   = #const TDBQCNUMBT
condToCInt QCNUMOREQ = #const TDBQCNUMOREQ
condToCInt QCNEGATE  = #const TDBQCNEGATE
condToCInt QCNOIDX   = #const TDBQCNOIDX

orderToCInt :: OrderType -> CInt
orderToCInt QOSTRASC  = #const TDBQOSTRASC
orderToCInt QOSTRDESC = #const TDBQOSTRDESC
orderToCInt QONUMASC  = #const TDBQONUMASC
orderToCInt QONUMDESC = #const TDBQONUMDESC

ptToCInt :: PostTreatment -> CInt
ptToCInt QPPUT  = #const TDBQPPUT
ptToCInt QPOUT  = #const TDBQPOUT
ptToCInt QPSTOP = #const TDBQPSTOP

data QRY

foreign import ccall safe "tctdbqrynew"
  c_tctdbqrynew :: IO (Ptr QRY)

foreign import ccall safe "tctdbqrydel"
  c_tctdbqrydel :: Ptr QRY -> IO ()

foreign import ccall safe "&tctdbqrydel"
  tctdbqryFinalizer :: FunPtr (Ptr QRY -> IO ())

foreign import ccall safe "tctdbqryaddcond"
  c_tctdbqryaddcond :: Ptr QRY -> CString -> CInt -> CString -> IO ()

foreign import ccall safe "tctdbqrysetorder"
  c_tctdbqrysetorder :: Ptr QRY -> CString -> CInt -> IO ()

foreign import ccall safe "tctdbqrysetlimit"
  c_tctdbqrysetlimit :: Ptr QRY -> CInt -> CInt -> IO ()

foreign import ccall safe "tctdbqrysearch"
  c_tctdbqrysearch :: Ptr QRY -> IO (Ptr LIST)

foreign import ccall safe "tctdbqrysearchout"
  c_tctdbqrysearchout :: Ptr QRY -> IO Bool

foreign import ccall safe "tctdbqryproc"
  c_tctdbqryproc :: Ptr QRY
                 -> FunPtr (Ptr Word8 -> CInt -> Ptr MAP -> Ptr Word8)
                 -> Ptr Word8
                 -> IO Bool

foreign import ccall safe "tctdbqryhint"
  c_tctdbqryhint :: Ptr QRY -> IO CString