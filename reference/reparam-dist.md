# Re-parametrised distributions

Re-parametrised distributions

## Arguments

- n:

  number of observations

- x:

  vector of quantiles

- q:

  vector of quantiles

- p:

  vector of probabilities

- dist:

  the distribution name e.g.`lnorm`

- log:

  logical; if TRUE, probabilities p are given as log(p).

- log.p:

  logical; if TRUE, probabilities p are given as log(p).

- lower.tail:

  logical; if TRUE (default), probabilities are `P[X<=x]` otherwise
  `P[X>x]`.

- prob:

  the mean probability (vectorised)

- prob.0.5:

  the median probability (vectorised)

- kappa:

  a coefficient of variation (sd/mean). where 0 is no variability.

- mean:

  the mean value on the true scale (vectorised)

- median:

  the median value on the true scale (vectorised)

- sd:

  the standard deviation on the true scale (vectorised)

- ...:

  passed onto named functions
