# [MPCCModels.jl documentation](@id Home)

This package provides general guidelines to represent non-linear programming (NLP)
problems in Julia and a standardized API to evaluate the functions and
their derivatives. The main objective is to be able to rely on that [API](@ref) when
designing optimization solvers in Julia.

## Introduction

The general form of the optimization problem is
```math
\begin{aligned}
\min \quad & f(x) \\
& c_i(x) = c_{E_i}, \quad i \in {\cal E}, \\
& c_{L_i} \leq c_i(x) \leq c_{U_i}, \quad i \in {\cal I}, \\
& \ell \leq x \leq u,
\end{aligned}
```
where ``f:\mathbb{R}^n\rightarrow\mathbb{R}``,
``c:\mathbb{R}^n\rightarrow\mathbb{R}^m``,
``{\cal E}\cup {\cal I} = \{1,2,\dots,m\}``, ``{\cal E}\cap {\cal I} = \emptyset``,
and
``c_{E_i}, c_{L_i}, c_{U_i}, \ell_j, u_j \in \mathbb{R}\cup\{\pm\infty\}``
for ``i = 1,\dots,m`` and ``j = 1,\dots,n``.

For computational reasons, we write
```math
\begin{aligned}
\min \quad & f(x) \\
& c_L \leq c(x) \leq c_U \\
& \ell \leq x \leq u,
\end{aligned}
```
defining ``c_{L_i} = c_{U_i} = c_{E_i}`` for all ``i \in {\cal E}``.
The Lagrangian of this problem is defined as
```math
L(x,y,z^L,z^U;\sigma) = \sigma f(x) + c(x)^T y  + \sum_{i=1}^n z_{L_i}(x_i-l_i) + \sum_{i=1}^n z_{U_i}(u_i-x_i),
```
where ``\sigma`` is a scaling parameter included for computational reasons.
Since the final two sums are linear in ``x``, the variables ``z_L`` and ``z_U`` do not appear in the Hessian ``\nabla^2 L(x,y)``.

Optimization problems are represented by an instance/subtype of `AbstractMPCCModel`.
Such instances are composed of

- an instance of [`MPCCModelMeta`](@ref Attributes), which provides information about the problem,
  including the number of variables, constraints, bounds on the variables, etc.
- other data specific to the provenance of the problem.

## Install

Install `MPCCModels.jl` with the following command.
```julia
pkg> add MPCCModels
```

This will enable the use of the API and the tools described here, and it allows the creation of a manually written model.

## License

This content is released under the [MIT](https://opensource.org/license/mit) License.

## Contents

```@contents
```
