using Base.Test, CSoM

data = Dict(
  # GenericSolid(ndim, nst, nels, nn, nip, finite_element(nod, nodof), axisymmentrix)
  :struc_el => GenericSolid(2, 3, 6, 35, 9, Quadrilateral(9, 2), false),
  :properties => [1.0e6 0.3 0.0;],
  :g_coord => [
    0.0  0.0; 1.5  0.0; 3.0  0.0; 4.5  0.0; 6.0  0.0; 0.0 -1.5;
    1.5 -1.5; 3.0 -1.5; 4.5 -1.5; 6.0 -1.5; 0.0 -3.0; 1.5 -3.0;
    3.0 -3.0; 4.5 -3.0; 6.0 -3.0; 0.0 -4.5; 1.5 -4.5; 3.0 -4.5;
    4.5 -4.5; 6.0 -4.5; 0.0 -6.0; 1.5 -6.0; 3.0 -6.0; 4.5 -6.0;
    6.0 -6.0; 0.0 -7.5; 1.5 -7.5; 3.0 -7.5; 4.5 -7.5; 6.0 -7.5;
    0.0 -9.0; 1.5 -9.0; 3.0 -9.0; 4.5 -9.0; 6.0 -9.0],
  :g_num => [
    11,  6,  1,  2,  3,  8, 13, 12,  7,
    21, 16, 11, 12, 13, 18, 23, 22, 17,
    31, 26, 21, 22, 23, 28, 33, 32, 27,
    13,  8,  3,  4,  5, 10, 15, 14,  9,
    23, 18, 13, 14, 15, 20, 25, 24, 19,
    33, 28, 23, 24, 25, 30, 35, 34, 29
  ],
  :support => [
    ( 1, [0 1]), ( 5, [0 1]), ( 6, [0 1]), (10, [0 1]), (11, [0 1]), (15, [0 1]),
    (16, [0 1]), (20, [0 1]), (21, [0 1]), (25, [0 1]), (26, [0 1]), (30, [0 1]),
    (31, [0 0]), (32, [0 0]), (33, [0 0]), (34, [0 0]), (35, [0 0])
  ],
  :loaded_nodes => [
    ( 1, [0.0 -0.5]),
    ( 2, [0.0 -2.0]),
    ( 3, [0.0 -0.5])
  ]
)

@time m = FE5_4(data)

@test round(m.sigma, 6) == round([-0.2063109419741752,-0.44483848277216465,
  0.006022685692717362], 6)