open Core.Std
open Modules

 (* This module includes functions to initialize Shamir's Secret Sharing Scheme
  * dencryption algorithm*)
module FiniteShamirIntDecode = (FiniteShamirInt_decode : SHAMIR_DECODE)
let rec try_read_int () =
  try read_int () with
    Failure _ -> 
      print_string "\nPlease enter an integer value: ";
      try_read_int ()
  ;;

let rec get_key_cl (count: int) (accum: (int * int) list) : (int * int) list =
  if count <= 0 then accum
  else (let () = print_string "\nEnter key x: " in
        let x = try_read_int () in
        let () = print_string "\nEnter key y: " in
        let y = try_read_int () in
          get_key_cl (count - 1) ((x,y)::accum))
;; 

let decrypt_init () =
  let () = print_string "\nSHAMIR'S SECRET SHARING SCHEME:
    \nInitialization Decryption Process...
    \nEnter in the prime base value: " in
  let prime = try_read_int () in
  let () = print_string "\nGive me the threshold value: " in
  let threshold = try_read_int () in
    (prime, (get_key_cl threshold []))
;;

let main_decrypt () =
  let (prime, keys) = decrypt_init () in
  let secret = FiniteShamirIntDecode.get_secret (prime)
    (FiniteShamirIntDecode.int_int_to_key keys) in
  Printf.printf "secret: %i\n" secret
;;

