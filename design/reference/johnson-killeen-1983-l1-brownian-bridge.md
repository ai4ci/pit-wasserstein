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
Johnson and Killeen derive the CDF of the absolute area of the standard Brownian bridge. In the manuscript this is the limiting law of the scaled baseline score, $\sqrt{n}\,B_{\rm pit}$, under independent uniform PITs. Equation (1) gives the Airy series. Table I gives 0.5821 and 0.7518 as the 95th and 99th percentiles of this limiting distribution. The fitted unsigned score uses a median-adjusted bridge and has a different reference law. [Publisher’s article](https://doi.org/10.1214/aop/1176993528) · [DOI metadata tracking](../task/verify-johnson-killeen-doi.md)

## Transcription of the published note

### An Explicit Formula for the C.D.F. of the $L_1$ Norm of the Brownian Bridge

B. McK. Johnson and T. Killeen<br>
The University of Connecticut<br>
*The Annals of Probability*, 1983, Vol. 11, No. 3, 807–808.

*Transcription note.* The six numbered equations and Table I were checked against the two-page scan. The printed text uses both $\exp(z^{-\alpha})$ and $\exp(-z^\alpha)$ in the passage across the page break. These expressions are reproduced as printed. The text cites Watson as [6], and the bibliography labels Watson [5].

### Page 807

Let $X(t)$, $0\le t\le 1$, be the Brownian bridge and $L=\int_0^1 |X(t)|\,dt$. Using results of Shepp [5] and Rice [4], an explicit formula for $P(L\le\ell)$ is obtained.

#### 1. Introduction.

Let $X(t)$, $t\in[0,1]$, be the Brownian bridge and

$$
L=\int_0^1 |X(t)|\,dt
$$

The distribution of $L$ has been recently studied in [5] and [4]. Shepp [5] using the Kac formula obtains the moments of $L$ and characterizes $Ee^{-\beta L}$. Rice [4] using the results of [5] gives an explicit formula for $Ee^{-\beta L}$ and obtains the density of $L$ by a numerical inversion. In this note, we invert $\beta^{-1}Ee^{-\beta L}$ to obtain an explicit formula for the C.D.F., $P(L\le\ell)$. The C.D.F. is also tabulated.

#### 2. Main result.

We establish the following.

**Theorem.**

$$
P(L\le\ell)=(\pi/2)^{1/2}\sum_{j=1}^{\infty}
\frac{1}{\delta_j^{3/2}}\psi(\ell/\delta_j^{3/2}),\tag{1}
$$

where

i) $\displaystyle \psi(t)=\frac{3^{2/3}e^{-2/(27t^2)}}{t^{1/3}}\operatorname{Ai}\!\left((3t)^{-4/3}\right)$, and $\operatorname{Ai}$ is the Airy function, and

ii) $\delta_j=-a'_j/2^{1/3}$ and $a'_j$ is the $j$th zero of $\operatorname{Ai}'$.

To establish the above, we begin with an equivalent form of the formula (8) of [4].

$$
Ee^{-\beta L}=(\pi/2)^{1/2}\sum_{j=1}^{\infty}
\frac{\beta^{1/3}e^{-\delta_j\beta^{2/3}}}{\delta_j}\tag{2}
$$

where the $\delta_j$ are as above and are also the positive zeros of $P'$, where

$$
P(y)=\frac{(2y)^{1/2}}{3}\left(
J_{-1/3}\!\left(\frac{(2y)^{3/2}}{3}\right)
-J_{1/3}\!\left(\frac{(2y)^{3/2}}{3}\right)\right).\tag{3}
$$

Formula (3) is required below and that $P'(\delta_j)=0$ follows easily from the definition of the $Ai$.

To invert

$$
\beta^{-1}Ee^{-\beta L}=(\pi/2)^{1/2}\sum_{j=1}^{\infty}
\frac{e^{-\delta_j\beta^{2/3}}}{\delta_j\beta^{2/3}},\tag{4}
$$

our interest centers on inverting $z^{-2/3}\exp(-z^{2/3})$. Humbert [2], in a heuristic exposition, inverts such functions as $z^{1/3}\exp(-z^{1/3})$. Pollard [3], with a judicious choice of contour, inverts $\exp(z^{-\alpha})$, $0<\alpha<1$. $z^{-\alpha}\exp(-z^\alpha)$ is the convolution of $t^{\alpha-1}/\Gamma(\alpha)$ with Pollard’s

*Page 807 footnote.* Received February 1982; revised April 1982.
*AMS 1980 subject classification.* Primary 60G15; secondary 60E05.
*Key words and phrases.* Brownian bridge, $L_1$ norm.

### Page 808

**Table I**

| $\ell$ | $P(L\le\ell)$ | $\ell$ | $P(L\le\ell)$ | $\ell$ | $P(L\le\ell)$ |
| ---: | ---: | ---: | ---: | ---: | ---: |
| .1531 | .05 | .2818 | .50 | .5123 | .91 |
| .1721 | .10 | .2975 | .55 | .5267 | .92 |
| .1875 | .15 | .3147 | .60 | .5427 | .93 |
| .2011 | .20 | .3338 | .65 | .5610 | .94 |
| .2142 | .25 | .3553 | .70 | .5821 | .95 |
| .2270 | .30 | .3804 | .75 | .6074 | .96 |
| .2395 | .35 | .4103 | .80 | .6391 | .97 |
| .2533 | .40 | .4480 | .85 | .6822 | .98 |
| .2671 | .45 | .4993 | .90 | .7518 | .99 |

result. On the other hand, using Pollard’s contour, it is easily seen the inverse of $z^{-\alpha}(\exp(z^{-\alpha}))$ is

$$
\psi_\alpha(t)=\frac{1}{\pi}I\left\{
\sum_{k=0}^\infty\frac{(-1)^k}{k!}\exp(-i\pi\alpha(k-1))
\frac{\Gamma((k-1)\alpha+1)}{t^{(k-1)\alpha+1}}\right\},\tag{5}
$$

where $I\{\ \}$ is the imaginary part of $\{\ \}$. In the case $\alpha=2/3$ one finds

$$
\psi_{2/3}(t)=\frac{3^{1/2}}{2\pi}\left\{
\frac{\Gamma(1/3)}{t^{1/3}}\Phi\!\left(\frac16,\frac13,\frac{-4}{27t^2}\right)
-\frac{\Gamma(2/3)}{3t^{5/3}}\Phi\!\left(\frac56,\frac53,\frac{-4}{27t^2}\right)
\right\},\tag{6}
$$

where $\Phi(a,c,\cdot)$ is the confluent hypergeometric function. Using relations between $\Phi$ and modified Bessel functions when $c=2a$, $\psi_{2/3}$ is seen to be the $\psi$ of the theorem.

It remains to justify the termwise inversion. $\psi$ is clearly positive on $(0,\infty)$, though not nondecreasing. Recalling formula (3) and using the fact that the zeros of $P'$ and $P$ alternate and information on the zeros of $J_{-1/3}$ and $J_{1/3}$, Watson [6], page 490, lower bounds of $\delta_j\ge\tfrac12(3\pi(j-2+\tfrac{7}{12}))^{2/3}$, $j\ge3$, are obvious. As the series (1) converges, the proof is complete.

#### 3. Tabulation.

The series (1) converges very rapidly. With the crude bound on the $\delta_j$, a majorizing integral for the sum from $j=11$ on is $\le 2\times10^{-10}$ for $0<t\le2$. Table I was obtained using tables of $Ai$ and $a'_j$, *Handbook of Mathematical Functions* [1], and is supposed to be accurate to five places with interpolation. In the range of the argument of the table, all terms from the fifth to the tenth are zero to seven places.

#### References

[1] Abramowitz, M. and Stegun, I. A. (1964). *Handbook of Mathematical Functions*. National Bureau of Standards, Applied Math. Series, 55.

[2] Humbert, P. (1945). Nouvelles correspondances symboloques. *Bull. Soc. Math. France* **69** 121–129.

[3] Pollard, H. (1946). The Representation of $e^{-x}$ as a Laplace integral. *Bull. Amer. Math. Soc.* **52** 908–910.

[4] Rice, S. O. (1982). The integral of the absolute value of the pinned Wiener process—calculation of its probability density by numerical integration. *Ann. Probability* **10** 240–243.

[5] Shepp, L. A. (1982). On the integral of the absolute value of the pinned Wiener process. *Ann. Probability* **10** 234–239.

[5] Watson, G. N. (1958). *A Treatise on the Theory of Bessel Functions*, Second Edition. Cambridge University Press, Cambridge.

Department of Statistics<br>
The University of Connecticut<br>
Storrs, Connecticut 06268
