open Core.Std
open BigNum
open ShamirBigNum
include ShamirBigNum_decode

let run_tests () =

  let sec = (fromInt 1234) in
  (* let threshold = 3 in
   * let participants = 6 in *)
  let p0 = [fromInt 0] in
  let p1 = [fromInt 1] in
  let p2 = [sec; (fromInt 166); (fromInt 94)] in
  let p3 = [sec; (fromInt 5); (fromInt 1)] in

  (* let keys1 = [(1, (fromInt 1494)); (2, (fromInt 1942)); (3, (fromInt 2578));
	    (4, (fromInt 3402)); (5, (fromInt 4414)); (6, (fromInt 5614))] in

  let keys2 = [(1, (fromInt 1240)); (2, (fromInt 1248)); (3, (fromInt 1258));
	     (4, (fromInt 1270)); (5, (fromInt 1334)); (6, (fromInt 1300))] in *)

  assert(add_polys p0 p2 = p2) ;
  assert(add_polys p1 p2 = 
    [(fromInt 1235); (fromInt 166); (fromInt 94)]) ;
  assert(add_polys p2 p3 = 
    [(fromInt 2468); (fromInt 171); (fromInt 95)]) ;

  assert(neg_poly p0 = p0) ;
  assert(neg_poly p1 = [fromInt (-1)]) ;
  assert(neg_poly p2 = 
    [(fromInt (-1234)); (fromInt (-166)); (fromInt (-94))]) ;
  assert(mult_poly_int 5 p0 = p0) ;
  assert(mult_poly_int 5 p1 = [fromInt 5]) ;
  assert(mult_poly_int 5 p2 = 
    [(fromInt 6170); (fromInt 830); (fromInt 470)]) ;
  assert(mult_poly_int 5 p3 = 
    [(fromInt 6170); (fromInt 25); (fromInt 5)]) ;

  assert(mult_poly_bignum (fromInt 5) p0 = p0) ;
  assert(mult_poly_bignum (fromInt 5) p1 = [fromInt 5]) ;
  assert(mult_poly_bignum (fromInt 5) p2 
		= [(fromInt 6170); (fromInt 830); (fromInt 470)]) ;
  assert(mult_poly_bignum (fromInt 5) p3 
		= [(fromInt 6170); (fromInt 25); (fromInt 5)]) ;

  assert(div_poly_int 1 p0 = p0) ;
  assert(div_poly_int 1 p1 = p1) ;
  assert(div_poly_int 1 p2 = p2) ;
  assert(div_poly_int 2 p2 
		= [(fromInt 617); (fromInt 83); (fromInt 47)]) ;


  assert(mult_x_a_poly 1 p1 = [(fromInt 1); (fromInt 1)]) ;
  assert(mult_x_a_poly 2 p1 = [(fromInt 2); (fromInt 1)]) ;
  let l2_num = mult_x_a_poly (-4) (mult_x_a_poly (-5) p1) in
  assert(l2_num = [(fromInt 20); (fromInt (-9)); (fromInt 1)]) ;
  let l4_num = mult_x_a_poly (-2) (mult_x_a_poly (-5) p1) in
  assert(l4_num = [(fromInt 10); (fromInt (-7)); (fromInt 1)]) ;
  let l5_num = mult_x_a_poly (-2) (mult_x_a_poly (-4) p1) in
  assert(l5_num = [(fromInt 8); (fromInt (-6)); (fromInt 1)]) ;

  let key2 = (2, (fromInt 1942)) in
  let key4 = (4, (fromInt 3402)) in
  let key5 = (5, (fromInt 4414)) in
  let p2keys = [key2; key4; key5] in

  let l2_den = gen_lagrange_denom 2 p2keys in
  assert(l2_den = 6) ;
  let l4_den = gen_lagrange_denom 4 p2keys in
  assert(l4_den = (-2)) ;
  let l5_den = gen_lagrange_denom 5 p2keys in
  assert(l5_den = 3) ;

  assert(gen_lagrange_num 2 p2keys = l2_num) ;
  assert(gen_lagrange_num 4 p2keys = l4_num) ;
  assert(gen_lagrange_num 5 p2keys = l5_num) ;

  let l2 = (l2_den, l2_num) in
  let l4 = (l4_den, l4_num) in
  let l5 = (l5_den, l5_num) in

  assert(gen_lagrange_poly key2 p2keys = l2) ;
  assert(gen_lagrange_poly key4 p2keys = l4) ;
  assert(gen_lagrange_poly key5 p2keys = l5) ;

  let lags = [l2; l4; l5] in

  assert(gen_lag_poly_list p2keys = lags) ;

  let denoms = [l5_den;(-l4_den);l2_den] in
  assert(remove_denoms lags = denoms) ;

  assert(common_denom denoms  = 6) ;

  let scalel2 = l2 in
  assert(scale_lag_poly l2 6 = scalel2) ;
  let scalel4 = (6, [(fromInt (-30)); (fromInt 21); (fromInt (-3))]) in
  assert(scale_lag_poly l4 6 = scalel4) ;
  let scalel5 = (6, [(fromInt 16); (fromInt (-12)); (fromInt 2)]) in
  assert(scale_lag_poly l5 6 = scalel5) ;

  let scaledlags = [scalel2; scalel4; scalel5] in

  assert(scale_lag_polys lags 6 = scaledlags) ;

  let combl2 = [(fromInt (38840)); (fromInt (-17478)); (fromInt 1942)] in
  let combl4 = [(fromInt (-102060)); (fromInt 71442); (fromInt (-10206))] in  
  let combl5 = [(fromInt 70624); (fromInt (-52968)); (fromInt 8828)] in

  let comblagys = [combl2; combl4; combl5] in
  assert(combine_lag_ys [(fromInt 1942);(fromInt 3402);(fromInt 4414)] scaledlags = comblagys) ;

  let calcp2 = List.fold_right ~init:[fromInt 0] ~f:(add_polys) comblagys in

  assert(calcp2 = [(fromInt 7404); (fromInt 996); (fromInt 564)]) ;

  let calcpdiv = div_poly_int 6 calcp2 in

  assert(decode_keys p2keys = calcpdiv) ;

  assert(decode_keys p2keys = p2);;

run_tests ();;
