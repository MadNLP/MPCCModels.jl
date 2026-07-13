# API

As stated in the [Home](@ref) page, we consider the nonlinear optimization
problem in the following format:
```math
\begin{aligned}
\min \quad & f(x) \\
& \ell_c \le c_i(x) \le u_c,\\
& \ell_G\le G(x) \perp H(x)\ge l_H, \\
& \ell \leq x \leq u.
\end{aligned}
```

We implement this by wrapping an `AbstractNLPModel` in the form:
```math
\begin{aligned}
\min \quad & f(x) \\
& c_L \leq c(x) \leq c_U \\
& \ell \leq x \leq u,
\end{aligned}
```
along with three vectors `ind_cc1`, `ind_cc2`, and `cc_types`.
We encode the functions ``G(x)`` and ``H(x)`` via these vectors in the following way.
The vectors `ind_cc1` and `ind_cc2` correspond to indexes into the vectors ``x`` and ``c(x)``.
Which of these vectors are the target of the indexing is determined by the values in `cc_types`:

| `CCType[k]` | ``G_k(x)`` | ``H_k(x)`` |
|-------------|------------|------------|
| `VarVar`    | ``x_i``    | ``x_j``    |
| `VarCon`    | ``x_i``    | ``c_j(x)`` |
| `ConVar`    | ``c_i(x)`` | ``x_j``    |
| `ConCon`    | ``c_i(x)`` | ``c_j(x)`` |

This allows the user maximum flexibility when it comes to modelling the original MPCC.
For practical algorithms however, we reformulate the problem into the so called "vertical form":
```math
\begin{aligned}
\min \quad & f(x) \\
& \ell_c \le c(x) \le u_c,\\
& \ell_G\le x_1 \perp x_2\ge l_H, \\
& \ell \leq x \leq u,
\end{aligned}
```

where all of the complementarity pairs are lifted to individual variables.
This is done via the `vertical_form` function.

In order to develop algorithms for solving MPCCs we define the following api for the `AbstractMPCCModel` type:

| Function                                              | `MPCCModels.jl` function                              | Notes                                         |
|-------------------------------------------------------|-------------------------------------------------------|-----------------------------------------------|
| ``G(x)``                                              | `comp_left`                                           | Raw evaluation of ``G(x)``                    |
| ``G(x)-\ell_G``                                       | `comp_res_left`                                       | Left hand side complementarity residual       |
| ``\nabla_x G(x)``                                     | `jac_comp_left_structure` and `jac_comp_left_coord`   | Jacobian of left hand side of complementarity |
| ``H(x)``                                              | `comp_right`                                          |                                               |
| ``H(x)-\ell_H``                                       | `comp_res_right`                                      | Right hand side complementarity residual      |
| ``\nabla_x G(x)``                                     | `jac_comp_right_structure` and `jac_comp_right_coord` | Jacobian of left hand side of complementarity |
| ``\vert\min(G(x)-\ell_G,H(x)-\ell_H)\vert_\infty``    | `comp_residual`                                       |                                               |
| ``\vert (G(x)-\ell_G)\odot(H(x)-\ell_H)\vert_\infty`` | `comp_residual_product`                               |                                               |
| ``(G(x)-\ell_G)\dot(H(x)-\ell_H)``                    | `comp_residual_sum`                                   |                                               |

along with overloads for the following `NLPModels.jl` api.

| Function                  | `NLPModels.jl` function                    | notes                                                                                                            |
|---------------------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| ``f(x)``                  | `obj`                                      |                                                                                                                  |
| ``\nabla f(x)``           | `grad`                                     |                                                                                                                  |
| ``c(x)``                  | `cons`                                     | Note that this includes possible lifted constraints but _not_ those contained in ``G(x)`` or ``H(x)``            |
| ``\nabla c(x)``           | `jac`, `jac_structure`, and `jac_coord`    | Note that this includes possible lifted constraints but _not_ those contained in ``G(x)`` or ``H(x)``            |
| ``\nabla^2 L(x,\lambda)`` | `hess`, `hess_structure`, and `hess_coord` | Note that this is not the MPCC lagrangian but the NLP Lagrangian with no contribution from the complementarities |
