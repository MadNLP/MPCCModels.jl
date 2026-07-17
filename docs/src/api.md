# API

As stated in the [Home](@ref) page, we consider the nonlinear optimization
problem in the following format:
```math
\begin{aligned}
\min \quad & f(x) \\
& \ell_c \le c(x) \le u_c,\\
& \ell_G\le G(x) \perp H(x)\ge l_H, \\
& \ell \leq x \leq u,
\end{aligned}
```

We implement this by wrapping an `AbstractNLPModel` in the form:
```math
\begin{aligned}
\min \quad & f(x) \\
& c_L \leq c'(x) \leq c_U \\
& \ell \leq x \leq u,
\end{aligned}
```
along with three vectors `ind_cc1`, `ind_cc2`, and `cc_types`.
We encode the functions ``G(x)`` and ``H(x)`` via these vectors in the following way.
The vectors `ind_cc1` and `ind_cc2` correspond to indexes into the vectors ``x`` and ``c'(x)``.
Which of these vectors are the target of the indexing is determined by the values in `cc_types`:

| `CCType[k]` | ``G_k(x)`` | ``H_k(x)`` |
|-------------|------------|------------|
| `VarVar`    | ``x_i``    | ``x_j``    |
| `VarCon`    | ``x_i``    | ``c'_j(x)`` |
| `ConVar`    | ``c'_i(x)`` | ``x_j``    |
| `ConCon`    | ``c'_i(x)`` | ``c'_j(x)`` |

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
This is done via the [`vertical_form`](@ref) function.

In order to develop algorithms for solving MPCCs we define the following API for the [`AbstractMPCCModel`](@ref) type:

| Function                                              | `MPCCModels.jl` function                                              | Notes                                         |
|-------------------------------------------------------|-----------------------------------------------------------------------|-----------------------------------------------|
| ``G(x)``                                              | [`comp_left`](@ref)                                                   | Raw evaluation of ``G(x)``                    |
| ``G(x)-\ell_G``                                       | [`comp_res_left`](@ref)                                               | Left hand side complementarity residual       |
| ``\nabla_x G(x)``                                     | [`jac_comp_left_structure`](@ref) and [`jac_comp_left_coord`](@ref)   | Jacobian of left hand side of complementarity |
| ``H(x)``                                              | [`comp_right`](@ref)                                                  |                                               |
| ``H(x)-\ell_H``                                       | [`comp_res_right`](@ref)                                              | Right hand side complementarity residual      |
| ``\nabla_x G(x)``                                     | [`jac_comp_right_structure`](@ref) and [`jac_comp_right_coord`](@ref) | Jacobian of left hand side of complementarity |
| ``\vert\min(G(x)-\ell_G,H(x)-\ell_H)\vert_\infty``    | [`comp_residual`](@ref)                                               |                                               |
| ``\vert (G(x)-\ell_G)\odot(H(x)-\ell_H)\vert_\infty`` | [`comp_residual_product`](@ref)                                       |                                               |
| ``(G(x)-\ell_G)\dot(H(x)-\ell_H)``                    | [`comp_residual_sum`](@ref)                                           |                                               |

along with overloads for the following `NLPModels.jl` API.

| Function                  | `NLPModels.jl` function                                            | notes                                                                                                            |
|---------------------------|--------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| ``f(x)``                  | [`NLPModels.obj`](@ref)                                            |                                                                                                                  |
| ``\nabla f(x)``           | [`NLPModels.grad`](@ref)                                                     |                                                                                                                  |
| ``c(x)``                  | [`NLPModels.cons`](@ref)                                                     | Note that this includes possible lifted constraints but _not_ those contained in ``G(x)`` or ``H(x)``            |
| ``\nabla c(x)``           | [`NLPModels.jac`](@ref), [`NLPModels.jac_structure`](@ref), and [`NLPModels.jac_coord`](@ref)    | Note that this includes possible lifted constraints but _not_ those contained in ``G(x)`` or ``H(x)``            |
| ``\nabla^2 L(x,\lambda)`` | [`NLPModels.hess`](@ref), [`NLPModels.hess_structure`](@ref), and [`NLPModels.hess_coord`](@ref) | Note that this is not the MPCC lagrangian but the NLP Lagrangian with no contribution from the complementarities |
