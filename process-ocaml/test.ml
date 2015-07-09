open OUnit2

let test_works test_ctxt = assert_equal () (Process.process "Name" "../test_data/")

let suite = "suite">::: ["test_works">:: test_works]

let () = run_test_tt_main suite
