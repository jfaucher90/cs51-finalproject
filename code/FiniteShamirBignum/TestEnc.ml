open Core.Std
open BigNum
open FiniteShamirBigNum
open Modules
include FiniteShamirBigNum_encode

(* To use get_secret function in test_gen_keys
module ShamirBigNumDecode = (ShamirBigNum_decode : SHAMIR_DECODE)
*) 

let test_to_secret () =
  let a = (fromInt 123) in
  assert(to_secret a = (fromInt 123));
  let b = (fromInt (-9876543)) in
  assert(to_secret b = (fromInt (-9876543)))
;;

let test_gen_poly () =
  Random.self_init();
  let t = (Random.int 9) + 1 in
  let s = (fromInt 1234) in
  let poly = gen_poly s t in
  assert(List.length poly = t);
  assert(List.hd_exn poly = s);
  let t2 = (Random.int 9) + 1 in
  let s2 = randbignum (fromInt 9999) in
  let poly2 = gen_poly s2 t2 in
  assert(List.length poly2 = t2);
  assert(List.hd_exn poly2 = s2)
;;

let test_eval_poly () =
  let prime = (fromInt 1279) in
  let poly = [(fromInt 1234); (fromInt 166); (fromInt 94)] in
  let x0 = 0 in
  assert(eval_poly x0 poly prime = (fromInt 1234));
  let x1 = 1 in
  assert(eval_poly x1 poly prime = (fromInt 215));
  let x2 = 2 in
  assert(eval_poly x2 poly prime = (fromInt 663));
  let x3 = 3 in 
  assert(eval_poly x3 poly prime  = (fromInt 20));
  let poly2 = [(fromInt 500); (fromInt (-10)); (fromInt 5)] in
  assert(eval_poly x0 poly2 prime = (fromInt 500));
  assert(eval_poly x1 poly2 prime = (fromInt 495));
  assert(eval_poly x2 poly2 prime = (fromInt 500));
  assert(eval_poly x3 poly2 prime = (fromInt 515))
;;

(* Helper function to grab t-keys from a list of keys k 
let rec get_t_keys t k acc =
  if t < 0 then acc
  else 
    let rem_key = List.nth_exn k (Random.int (List.length k)) in
    let rem_key_x = fst(rem_key) in
    let keys_left = List.filter ~f:(fun x -> fst(x) <> rem_key_x) k in
    get_t_keys (t-1) keys_left (rem_key:: acc)
;; *)

let test_gen_keys () =
  Random.self_init();
  let s = (fromInt 1234) in
  let n = 10 in
  let t = (Random.int 8) + 1 in
  let primekeys = gen_keys s t n in
  let keys = snd(primekeys) in
  assert(List.length keys = n);
  (*let rand_keys = get_t_keys t keys [] in
  assert((ShamirBigNumDecode.get_secret 
	   (List.map ~f:(ShamirBigNumDecode.to_key) rand_keys)) = s);*)
  let s2 = randbignum (fromInt 9999) in
  let n2 = 10 in
  let t2 = (Random.int 8) + 1 in
  let primekeys2 = gen_keys s2 t2 n2 in
  let keys2 = snd(primekeys2) in
  assert(List.length keys2 = n2);
  (*let rand_keys2 = get_t_keys t2 keys2 [] in
  assert((ShamirBigNumDecode.get_secret 
	   (List.map ~f:(ShamirBigNumDecode.to_key) rand_keys2)) = s2);*)
  let s3 = randbignum (fromInt 9999) in
  let n3 = 5 in
  let t3 = 3 in
  let primekeys3 = gen_keys s3 t3 n3 in
  let keys3 = snd(primekeys3) in
  assert(List.length keys3 = n3);
  (*let rand_keys3 = get_t_keys t3 keys3 [] in
  assert((ShamirBigNumDecode.get_secret 
	   (List.map ~f:(ShamirBigNumDecode.to_key) rand_keys3)) = s3)*)
;;

let run_tests () =
  test_to_secret ();
  test_gen_poly ();
  test_eval_poly ();
  test_gen_keys ();
;;

run_tests ()
