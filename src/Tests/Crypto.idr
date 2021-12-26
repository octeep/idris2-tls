module Tests.Crypto

import Control.Monad.State
import Crypto.RSA
import Crypto.Random
import Crypto.Random.C
import Crypto.AES.Common
import Crypto.AES.Small
import Crypto.AES.Big
import Data.Vect
import Utils.Bytes
import Utils.Misc

test_chacha : HasIO m => m ()
test_chacha = do
  drg <- new_chacha12_drg
  let a = evalState drg (random_bytes 1024)
  putStrLn $ show a

test_rsa : HasIO m => m Integer
test_rsa = do
  (pk, sk) <- generate_key_pair 1024
  let m = 42069
  let c = rsa_encrypt pk m
  rsa_decrypt_blinded sk c

test_aes_128_key : Vect 16 Bits8
test_aes_128_key =
  [ 0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c ]

test_aes_192_key : Vect 24 Bits8
test_aes_192_key =
  [ 0x8e, 0x73, 0xb0, 0xf7, 0xda, 0x0e, 0x64, 0x52, 0xc8, 0x10, 0xf3, 0x2b, 0x80, 0x90, 0x79, 0xe5
  , 0x62, 0xf8, 0xea, 0xd2, 0x52, 0x2c, 0x6b, 0x7b ]

test_aes_256_key : Vect 32 Bits8
test_aes_256_key =
  [ 0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe, 0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81
  , 0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7, 0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4 ]

test_aes_plaintext : Vect 16 Bits8
test_aes_plaintext =
  [ 0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a ]

test_aes_128_ciphertext : Vect 16 Bits8
test_aes_128_ciphertext =
  Small.encrypt_block AES128 test_aes_128_key test_aes_plaintext

test_aes_192_ciphertext : Vect 16 Bits8
test_aes_192_ciphertext =
  Small.encrypt_block AES192 test_aes_192_key test_aes_plaintext

test_aes_256_ciphertext : Vect 16 Bits8
test_aes_256_ciphertext =
  Small.encrypt_block AES256 test_aes_256_key test_aes_plaintext

test_aes_big_128_ciphertext : Vect 16 Bits8
test_aes_big_128_ciphertext =
  Big.encrypt_block AES128 test_aes_128_key test_aes_plaintext

test_aes_big_192_ciphertext : Vect 16 Bits8
test_aes_big_192_ciphertext =
  Big.encrypt_block AES192 test_aes_192_key test_aes_plaintext

test_aes_big_256_ciphertext : Vect 16 Bits8
test_aes_big_256_ciphertext =
  Big.encrypt_block AES256 test_aes_256_key test_aes_plaintext
