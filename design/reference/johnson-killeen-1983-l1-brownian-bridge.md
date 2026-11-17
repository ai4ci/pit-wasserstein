---
class: reference
id: johnson-killeen-1983-l1-brownian-bridge.md
title: An explicit formula for the c.d.f. of the L1 norm of the Brownian bridge
citeKey: johnson-killeen-1983
year: 1983
doi: 10.1214/aop/1176993673
zoteroKey: 4DEXX53I
citedIn:
- paper:refs.bib
---
Johnson & Killeen (1983), *The Annals of Probability* 11(3):807–808.

**The key reference for $U^*_{pit}$.** Derives an explicit formula for the CDF of
the L1 norm of the Brownian bridge:

$$F_{L_1}(x) = P\left(\int_0^1 |B^\circ(t)|\,dt \le x\right)$$

The formula is expressed as an infinite series (closed-form in the sense of a
convergent series with explicit terms). This is the exact distribution needed
for the $\sqrt{n}\,U^*_{pit}$ limit.

**Why cite:** the $U^*_{pit}$ limiting distribution is not a table — it has an
explicit CDF formula. This makes the significance test fully analytical rather
than simulation-dependent.

## Their notation

$X(t)$ is a brownian bridge

$$
L =  \int_0^1 |X(t)| dt
$$

$$
P(L \leq \ell) = (\pi/2)^{1/2} \sum_{j=1}^{\infty} \frac{1}{\delta_j^{3/2}} \psi(\ell/\delta_j^{3/2})
$$


where

$$
\begin{align*}
\text{i) } & \psi(t) = \frac{3^{2/3} e^{-\frac{2}{27t^2}}}{t^{1/3}} Ai((3t)^{-4/3}), \ \text{\textit{and }} Ai \text{ \textit{is the Airy function, and}} \\
\text{ii) } & \delta_j = -a'_j / 2^{1/3} \ \text{\textit{and }} a'_j \text{ \textit{is the }} j\text{\textit{th zero of }} Ai'.
\end{align*}
$$
