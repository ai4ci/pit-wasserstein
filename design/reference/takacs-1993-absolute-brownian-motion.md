---
class: reference
id: takacs-1993-absolute-brownian-motion.md
title: On the Distribution of the Integral of the Absolute Value of the Brownian Motion
citeKey: takacs1993
year: 1993
doi: 10.1214/aoap/1177005514
citedIn:
- paper:refs.bib
---
Lajos Takács (1993), *The Annals of Applied Probability* **3**(1), 186–197. [Publisher's article](https://doi.org/10.1214/aoap/1177005514)

## Relevance to the PIT tests

Takács obtains the density and moments of the area under the absolute value of **standard Brownian motion** over one unit of time. Its endpoint is random. The limiting baseline PIT statistic uses a Brownian bridge pinned at zero at both ends. On p. 196 Takács traces the bridge law to Cifarelli (1975) and Shepp (1982), its numerical density to Rice (1982), and its explicit CDF to Johnson and Killeen (1983). Use the latter for baseline PIT critical values. [Johnson and Killeen reference](johnson-killeen-1983-l1-brownian-bridge.md)

## Mathematical extraction from the scan

The notes below follow the four printed sections. Equation and table numbers refer to the paper. The mathematical displays and table entries were read against the page images. The prose condenses the argument. Takács uses $a'_j>0$ for the **magnitude** of an Airy derivative zero, so the zero itself is $-a'_j$.

### 1. Random-walk area and Kac's transform (pp. 186–187)

Let $\xi_i$ be iid, with mean zero and variance one, and let $\zeta_k=\sum_{i=1}^k\xi_i$. Kac's random-walk limit, its Laplace–Stieltjes transform and the Airy expansion are

$$
\lim_{n\to\infty}\Pr\!\left(n^{-3/2}\sum_{k=1}^n|\zeta_k|\le x\right)=H(x), \tag{1}
$$

$$
\Psi(s)=\int_0^\infty e^{-sx}\,dH(x), \qquad s\ge0, \tag{2}
$$

$$
\Psi(s)=\sum_{j=1}^\infty C_j\exp\!\left(-2^{-1/3}a'_j s^{2/3}\right), \tag{3}
$$

$$
C_j=\frac{1+3\int_0^{a'_j}\operatorname{Ai}(-u)\,du}
{3a'_j\operatorname{Ai}(-a'_j)}, \tag{4}
$$

$$
\operatorname{Ai}(z)=\frac1\pi\int_0^\infty\cos(t^3/3+tz)\,dt. \tag{5}
$$

The positive magnitudes $a'_j$ are in increasing order. The scaled partial sums converge weakly to standard Brownian motion $W$. Continuity of the absolute-area functional identifies the limit in (1):

$$
\sigma=\int_0^1|W(t)|\,dt, \tag{6}
$$

$$
H(x)=\Pr(\sigma\le x). \tag{7}
$$

### 2. Density (pp. 187–190)

The positive stable density $g$ of index $2/3$ has transform and inverse

$$
\int_0^\infty e^{-sx}g(x)\,dx=e^{-s^{2/3}},\qquad \Re s\ge0, \tag{8}
$$

$$
g(x)=\frac{2^{4/3}x^{-7/3}}{\sqrt{27\pi}}e^{-4/(27x^2)}
U\!\left(\tfrac16,\tfrac43,\tfrac4{27x^2}\right),\qquad x>0, \tag{9}
$$

$$
U(\tfrac16,\tfrac43,x)=\frac1{\Gamma(1/6)}
 \int_0^\infty e^{-tx}t^{-5/6}(1+t)^{1/6}\,dt. \tag{10}
$$

**Theorem 1 (p. 187).** For $x>0$ the density is

$$
h(x)=H'(x)=\frac{\sqrt3}{x\sqrt\pi}\sum_{j=1}^\infty
 C_j e^{-v_j}v_j^{2/3}U(\tfrac16,\tfrac43,v_j), \tag{11}
$$

$$
v_j=\frac{2(a'_j)^3}{27x^2}. \tag{12}
$$

This follows by inverting each scaled stable transform in (3). With $q_j=2^{1/2}(a'_j)^{-3/2}$ the density is

$$
h(x)=\sum_{j=1}^\infty C_jq_j g(q_jx). \tag{13}
$$

For compactness, write $\theta=2x^{3/2}/3+\pi/4$, $y=3/(2x^{3/2})$,
$E_u(y)=\sum_{j\ge0}(-1)^j u_{2j}y^{2j}$ and
$O_u(y)=\sum_{j\ge0}(-1)^j u_{2j+1}y^{2j+1}$. The large-$x$ expansions used to compute (4) are

$$
\operatorname{Ai}(-x)\sim\frac{x^{-1/4}}{\sqrt\pi}
  [\sin\theta\, E_c(y)-\cos\theta\, O_c(y)], \tag{14}
$$

$$
c_0=1,\qquad c_j=\frac{\Gamma(3j+1/2)}{54^j j!\,\Gamma(j+1/2)}
=\frac{(2j+1)(2j+3)\cdots(6j-1)}{216^j j!}, \tag{15}
$$

$$
c_j=\tfrac12(j-1+5/(36j))c_{j-1},\qquad j\ge1, \tag{16}
$$

$$
\int_0^x\operatorname{Ai}(-u)\,du\sim\tfrac23-\frac{x^{-3/4}}{\sqrt\pi}
   [\cos\theta\,E_h(y)+\sin\theta\,O_h(y)], \tag{17}
$$

$$
h_0=1,\qquad h_j=c_j+\tfrac{2j-1}{2}h_{j-1}. \tag{18}
$$

Here $h_j$ is an expansion coefficient. Miller [7] tabulates the first 50 roots and Airy values. Abramowitz and Stegun [1] give the first ten and the asymptotic expansion of the roots.

**Table 1 (p. 189).** Constants for (3) and (11), with $I_j=\int_0^{a'_j}\operatorname{Ai}(-u)\,du$.

| $j$ | $a'_j$ | $\operatorname{Ai}(-a'_j)$ | $I_j$ | $C_j$ |
|---:|---:|---:|---:|---:|
| 1 | 1.01879297 | 0.53565666 | 0.47573996 | 1.48257073 |
| 2 | 3.24819758 | −0.41901548 | 0.70083344 | −0.75983287 |
| 3 | 4.82009921 | 0.38040647 | 0.65122852 | 0.53695654 |
| 4 | 6.16330736 | −0.35790794 | 0.67580399 | −0.45747262 |
| 5 | 7.37217726 | 0.34230124 | 0.66048490 | 0.39382448 |
| 6 | 8.48848673 | −0.33047623 | 0.67119622 | −0.35809002 |
| 7 | 9.53544905 | 0.32102229 | 0.66316740 | 0.32553770 |
| 8 | 10.52766040 | −0.31318539 | 0.66947361 | −0.30414730 |
| 9 | 11.47505663 | 0.30651729 | 0.66435092 | 0.28365033 |
| 10 | 12.38478837 | −0.30073083 | 0.66861921 | −0.26901755 |

The large-$j$ estimates and the estimated magnitude of the error on stopping (11) after term $n$ are

$$
a'_j\sim[3\pi(4j-3)/8]^{2/3}, \tag{19}
$$

$$
C_j\sim(-1)^{j-1}\sqrt{2/(3j)}, \tag{20}
$$

$$
R_n(x)\sim e^{-\pi^2n^2/(6x^2)}\sqrt{n\pi}/x^2. \tag{21}
$$

At $n=10$ and $x=2$, Takács estimates the error at about $2\times10^{-18}$.

**Table 2 (p. 189).** Density values calculated from (11). Figure 1 (p. 190) plots the same density, with a peak near $x=0.3$ and a long right tail.

| $x$ | $h(x)$ | $x$ | $h(x)$ | $x$ | $h(x)$ | $x$ | $h(x)$ |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.05 | 0.000000 | 0.55 | 1.092241 | 1.05 | 0.277296 | 1.55 | 0.038464 |
| 0.10 | 0.016130 | 0.60 | 0.960699 | 1.10 | 0.235011 | 1.60 | 0.030330 |
| 0.15 | 0.558418 | 0.65 | 0.846447 | 1.15 | 0.197797 | 1.65 | 0.023741 |
| 0.20 | 1.447401 | 0.70 | 0.746032 | 1.20 | 0.165309 | 1.70 | 0.018446 |
| 0.25 | 1.884812 | 0.75 | 0.656629 | 1.25 | 0.137176 | 1.75 | 0.014226 |
| 0.30 | 1.930870 | 0.80 | 0.576235 | 1.30 | 0.113017 | 1.80 | 0.010890 |
| 0.35 | 1.798081 | 0.85 | 0.503549 | 1.35 | 0.092441 | 1.85 | 0.008275 |
| 0.40 | 1.609401 | 0.90 | 0.437764 | 1.40 | 0.075064 | 1.90 | 0.006241 |
| 0.45 | 1.418331 | 0.95 | 0.378363 | 1.45 | 0.060510 | 1.95 | 0.004673 |
| 0.50 | 1.244365 | 1.00 | 0.324978 | 1.50 | 0.048421 | 2.00 | 0.003472 |

### 3. Moments and their growth (pp. 190–195)

**Theorem 2 (p. 190).** For integers $r\ge0$, the moments and the recurrence that determines them are

$$
\mu_r=\int_0^\infty x^r\,dH(x), \tag{22}
$$

$$
\mu_r=\frac{L_r r!}{2^{r/2}\Gamma((3r+2)/2)}, \tag{23}
$$

$$
L_0=1,\qquad L_n=\beta_n+\sum_{j=1}^n\frac{6j+1}{6j-1}\alpha_j L_{n-j}, \tag{24}
$$

$$
\alpha_0=1,\qquad \alpha_j=\frac{\Gamma(3j+1/2)}{36^j j!\,\Gamma(j+1/2)}
=\frac{(2j+1)(2j+3)\cdots(6j-1)}{144^j j!}, \tag{25}
$$

$$
\beta_0=1,\qquad\beta_k=\alpha_k+\frac{3(2k-1)}4\beta_{k-1}. \tag{26}
$$

Cifarelli's identity conditions on the endpoint. For $z>0$,

$$
\int_0^\infty e^{-zt}\mathbb E\!\left[e^{-\sigma\sqrt{2t^3}}\mid\sqrt t\,W(1)=x\right]
 \varphi(x/\sqrt t)\frac{dt}{\sqrt t}
=-\frac{\operatorname{Ai}(z+\sqrt2\,|x|)}{\sqrt2\,\operatorname{Ai}'(z)}, \tag{27}
$$

$$
\varphi(x)=(2\pi)^{-1/2}e^{-x^2/2}. \tag{28}
$$

Integrating over **all** endpoints gives the transform for ordinary Brownian motion. Write $A(z)=\int_0^z\operatorname{Ai}(u)\,du$. Analytic continuation and inversion give

$$
\int_0^\infty e^{-zt}\Psi(\sqrt{2t^3})\,dt=
\frac{3A(z)-1}{3\operatorname{Ai}'(z)}, \tag{29}
$$

$$
\Psi(s)=\frac1{2\pi i}\int_{-i\infty}^{i\infty}
 e^{zs^{2/3}2^{-1/3}}\frac{3A(z)-1}{3\operatorname{Ai}'(z)}\,dz. \tag{30}
$$

The poles in (30) are at the negative zeros of the Airy derivative. Their residues recover (3). Let $M=\max_{0\le u\le1}|W(u)|$. Takács bounds the moments using the path maximum and its known moments:

$$
\mu_r<\sqrt8\,(r/e)^{r/2}\quad(r\ge1), \tag{31}
$$

$$
\sigma\le M, \tag{32}
$$

$$
\mathbb E[M^r]=
\frac{2^{(r+3)/2}\Gamma((r+1)/2)}{\sqrt{2\pi}}
\sum_{k=0}^\infty\frac{(-1)^k}{(2k+1)^r}\quad(r\ge1). \tag{33}
$$

The transform therefore has an everywhere convergent series,

$$
\Psi(s)=\sum_{r=0}^\infty(-1)^r\mu_r s^r/r!. \tag{34}
$$

For the following large-$z$ expansions put $q=z^{-3/2}$, $T=\sum_{r\ge0}(-1)^rL_r q^r$,
$D=\sum_{j\ge0}(-1)^{j+1}\frac{6j+1}{6j-1}\alpha_j q^j$, and
$V=\sum_{k\ge0}(-1)^k\beta_k q^k$. Integrating (34) termwise in (29) and expanding the two Airy terms yields

$$
z\int_0^\infty e^{-zt}\Psi(\sqrt{2t^3})\,dt\sim T, \tag{35}
$$

$$
\operatorname{Ai}'(z)\sim-\frac{z^{1/4}e^{-2z^{3/2}/3}}{2\sqrt\pi}\,D, \tag{36}
$$

$$
\alpha_j=\tfrac34(j-1+5/(36j))\alpha_{j-1}, \tag{37}
$$

$$
A(z)\sim\tfrac13-\frac{z^{-3/4}e^{-2z^{3/2}/3}}{2\sqrt\pi}\,V. \tag{38}
$$

Multiplication and comparison of coefficients give (24):

$$
T D\sim V, \tag{39}
$$

$$
\sum_{j=0}^n\frac{6j+1}{6j-1}\alpha_jL_{n-j}+\beta_n=0. \tag{40}
$$

**Table 3 (p. 193).** Moments of $\sigma$. In the exact column $v=1/\sqrt{2\pi}$.

| $r$ | $L_r$ | $\mu_r$ (exact) | $\mu_r$ (decimal) |
|---:|---:|---:|---:|
| 0 | 1 | 1 | 1 |
| 1 | 1 | $4v/3$ | 0.5319230405 |
| 2 | $9/4$ | $3/8$ | 0.375 |
| 3 | $263/32$ | $263v/315$ | 0.3330851420 |
| 4 | $2709/64$ | $903/2560$ | 0.352734375 |
| 5 | $578487/2048$ | $2119v/1980$ | 0.4269488344 |
| 6 | $2370249/1024$ | $37623/65536$ | 0.5740814209 |
| 7 | $1472890279/65536$ | $11074363v/5250960$ | 0.8413759825 |
| 8 | $1032772671/4096$ | $114752519/86507520$ | 1.3265033953 |
| 9 | $26915124080747/8388608$ | $3845017725821v/688400856000$ | 2.2282658808 |
| 10 | $11968136957889/262144$ | $189970427903/47982837760$ | 3.9591328227 |

**Theorem 3 (p. 192).** As $r\to\infty$,

$$
\mu_r\sim\sqrt2\left(\frac r{3e}\right)^{r/2}. \tag{41}
$$

The proof first controls the coefficients in (24). Define $N_k=(4/3)^k/(2k-1)!!$ for $k\ge1$. Equations (37) and (25) give

$$
\alpha_j<(3/4)^j j!\qquad(j\ge1), \tag{42}
$$

$$
a(j)=N_j\alpha_j=
\frac{(6j)!\,j!}{(3j)!(2j)!^2}\left(\frac1{216}\right)^j, \tag{43}
$$

$$
1+\sum_{j=1}^\infty a(j)={}_2F_1(\tfrac16,\tfrac56;\tfrac12;\tfrac12)=\sqrt6/2. \tag{44}
$$

Equation (26) then gives

$$
N_k\beta_k=1+\sum_{j=1}^k a(j), \tag{45}
$$

$$
\lim_{k\to\infty}N_k\beta_k=\sqrt6/2. \tag{46}
$$

The scan prints the following growth estimate at (47):

$$
\beta_k\sim\sqrt2\left(\frac{k}{3e}\right)^{k/2}. \tag{47, as printed}
$$

**Transcription note.** Equation (46) instead gives $\beta_k\sim(\sqrt6/2)(3/4)^k(2k-1)!!$. The paper's final moment asymptotic (63) follows from the limit for $L_r$ and (23).

For the normalised moment coefficients, the next part of the proof establishes

$$
\lim_{r\to\infty}N_rL_r=L, \tag{48}
$$

$$
\sqrt{3/2}\le L\le4/3. \tag{49}
$$

Takács [13] supplies a positive sequence $D_r$, with $D_0=1$, $D_1=1/4$:

$$
D_r=\frac{3r-2}{4}D_{r-1}-\tfrac12\sum_{i=1}^{r-1}D_iD_{r-i}\qquad(r\ge2). \tag{50}
$$

Write $S=\sum_{r\ge0}(-1)^rD_rq^r$. The Airy quotient and (29) give

$$
S\sim-\frac{\operatorname{Ai}(z)z^{1/2}}{\operatorname{Ai}'(z)}, \tag{51}
$$

$$
z^{-1}T\sim\frac{3A(z)-1}{3\operatorname{Ai}'(z)}. \tag{52}
$$

Differentiate (52) and use $\operatorname{Ai}''(z)=z\operatorname{Ai}(z)$:

$$
-\tfrac12\sum_{r\ge0}(-1)^rL_r(3r+2)z^{-(3r+4)/2}
\sim\frac{\operatorname{Ai}(z)}{\operatorname{Ai}'(z)}
-\frac{3A(z)-1}{3\operatorname{Ai}'(z)}
 \frac{z\operatorname{Ai}(z)}{\operatorname{Ai}'(z)}, \tag{53}
$$

$$
-\tfrac12\sum_{r\ge0}(-1)^rL_r(3r+2)z^{-(3r+3)/2}\sim S(T-1). \tag{54}
$$

Equating coefficients and using $D_0=1$, $D_1=1/4$ gives

$$
\tfrac{3r-1}{2}L_{r-1}=\sum_{j=0}^{r-1}D_jL_{r-j}\quad(r\ge1), \tag{55}
$$

$$
L_r=\tfrac{3r-1}{2}L_{r-1}-\sum_{j=1}^{r-1}D_jL_{r-j}\quad(r\ge2), \tag{56}
$$

$$
L_r\le\left(\tfrac{3r-1}{2}-\tfrac14\right)L_{r-1}=\tfrac{3(2r-1)}4L_{r-1}, \tag{57}
$$

$$
N_rL_r\le N_{r-1}L_{r-1}\quad(r\ge2). \tag{58}
$$

The decreasing sequence is bounded below by $N_r\beta_r$, giving a limit. The normalised convolution in (24) tends to zero:

$$
\lim_{r\to\infty}N_rL_r=L, \tag{59}
$$

$$
\lim_{n\to\infty}N_n\sum_{j=1}^n\frac{6j+1}{6j-1}\alpha_jL_{n-j}=0. \tag{60}
$$

In detail, the bound from (58) and the estimate from (42) give

$$
N_rL_r\le\tfrac43\quad(r\ge1), \tag{61}
$$

$$
0\le N_n\sum_{j=1}^n\frac{6j+1}{6j-1}\alpha_jL_{n-j}
\le\frac{28}{15}\sum_{j=1}^n2^j j!\frac{n!(2n-2j)!}{(2n)!(n-j)!}\longrightarrow0. \tag{62}
$$

Thus $L=\sqrt6/2$. Substitution into the moment formula gives

$$
\mu_r=\frac{L_r r!}{2^{r/2}\Gamma((3r+2)/2)}
\sim\sqrt2\left(\frac r{3e}\right)^{r/2}. \tag{63}
$$

### 4. Laguerre expansions (pp. 196–197)

The final section gives an alternative numerical method using the moments. For $\alpha>-1$, the generalised Laguerre polynomials and their weight are

$$
L_n^{(\alpha)}(x)=\sum_{j=0}^n(-1)^j\binom{n+\alpha}{n-j}\frac{x^j}{j!}, \tag{64}
$$

$$
g_\alpha(x)=e^{-x}x^\alpha/\Gamma(\alpha+1), \tag{65}
$$

$$
G_\alpha(x)=\int_0^x g_\alpha(u)\,du. \tag{66}
$$

For $x\ge0$ and $a,b>0$, the printed CDF and density expansions are

$$
H(x)=G_a(bx)+a\sum_{n=1}^\infty\frac{c_n}{n}g_{a+1}(bx)L_{n-1}^{(a)}(bx), \tag{67}
$$

$$
h(x)=g_a(bx)b\sum_{n=0}^\infty c_n L_n^{(a-1)}(bx). \tag{68}
$$

The coefficients and moment-matched parameters are

$$
c_n\binom{n+a-1}{n}=\sum_{r=0}^n
  \frac{(-1)^r}{r!}\binom{n+a-1}{n-r}b^r\mu_r, \tag{69}
$$

$$
a=\frac{64}{27\pi-64}=3.073524225046, \tag{70}
$$

$$
b=\frac{48\sqrt{2\pi}}{27\pi-64}=5.778137043948. \tag{71}
$$

**Indexing note.** Equations (67)–(68) retain the printed subscripts. Under definition (65), the orthogonality weight for $L_n^{(a-1)}$ is $g_{a-1}$. This matters if implementing the expansion from the paper. Equation (69) gives $c_0=1$ and the choices (70)–(71) give $c_1=c_2=0$.

**Table 4 (p. 197).** Laguerre coefficients using (70)–(71).

| $n$ | $c_n$ | $n$ | $c_n$ |
|---:|---:|---:|---:|
| 1 | 0.000000000000 | 6 | −0.020663009369 |
| 2 | 0.000000000000 | 7 | −0.013188716669 |
| 3 | −0.011584328208 | 8 | −0.007518446236 |
| 4 | −0.027178915962 | 9 | −0.003542017611 |
| 5 | −0.027729182039 | 10 | −0.000784228414 |

### References cited in the scan (p. 197)

1. Abramowitz, M. and Stegun, I. A. (1965). *Handbook of Mathematical Functions*. Dover.
2. Bailey, W. N. (1935). *Generalized Hypergeometric Series*. Cambridge University Press. Reprinted by Stechert–Hafner, 1964.
3. Cifarelli, D. M. (1975). Contributi intorno ad un test per l’omogeneità tra due campioni. *G. Econom. Ann. Econ.* (N.S.) **34**, 233–249.
4. Johnson, B. McK. and Killeen, T. (1983). An explicit formula for the c.d.f. of the $L_1$ norm of the Brownian bridge. *Ann. Probab.* **11**, 807–808.
5. Kac, M. (1946). On the average of a certain Wiener functional and a related limit theorem in calculus or probability. *Trans. Amer. Math. Soc.* **59**, 401–414.
6. Kac, M. (1979). Autobiographical note. In *Probability, Number Theory, and Statistical Physics. Selected Papers*, ix–xxiii. MIT Press.
7. Miller, J. C. P. (1946). *The Airy Integral*. Cambridge University Press.
8. Nasarow, N. (1931). Über die Entwicklung einer beliebigen Funktion nach Laguerreschen Polynomen. *Math. Z.* **33**, 481–487.
9. Rice, S. O. (1982). The integral of the absolute value of the pinned Wiener process—Calculation of its probability density by numerical integration. *Ann. Probab.* **10**, 240–243.
10. Sansone, G. (1959). *Orthogonal Functions*. Interscience.
11. Shepp, L. A. (1982). On the integral of the absolute value of the pinned Wiener process. *Ann. Probab.* **10**, 234–239. Acknowledgement of priority, **19**, 1397 (1991).
12. Slater, L. J. (1950). *Confluent Hypergeometric Functions*. Cambridge University Press.
13. Takács, L. (1992). Random walk processes and their various applications. In *Probability Theory and Applications. Essays to the Memory of József Mogyoródi*, 1–32. Kluwer. Listed as forthcoming.
14. Uspensky, J. V. (1927). On the development of arbitrary functions in series of Hermite’s and Laguerre’s polynomials. *Ann. Math.* **28**, 593–619.
15. Wolfram, S. (1991). *Mathematica, A System for Doing Mathematics by Computer*, 2nd ed. Addison-Wesley.
16. Zolotarev, V. M. (1986). *One-dimensional Stable Distributions*. American Mathematical Society.
