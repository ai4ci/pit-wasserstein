i_prob_pred = interfacer::iface(
  location = numeric ~ "the location parameter is the estimator mean or median (i.e. the central estimate)",
  scale = numeric ~ "the scale parameter is the stated estimator uncertainty (i.e. the sharpness)",
  dist = character + default("norm") ~ "the estimator distribution name (e.g. norm) parameterised by location and scale",
  .groups = ~ dist + .
)

i_single_true_value = interfacer::iface(
  true_value = numeric ~ "the true value",
  true_value = numeric ~ "the true value",
  link = character + default("identity") ~ "a transformation that puts the quantity being estimated on a linear scale",
  .groups = ~ link + .
)

i_comparison = interfacer::iface(
  i_single_true_value,
  i_prob_pred,
  calibration = numeric ~ "the calibration as determined by the SD of the probabilistic prediction (sharpness) / the SD of the true values distribution, overconfident is <1, and conservative is >1 ",
  .groups = ~ dist + link + calibration + .
)

i_sim_setup = interfacer::iface(
  true_value = numeric + default(0) ~ "the true value being estimated",
  estimator_dist = character + default("norm") ~ "the estimator distribution name (e.g. norm) parameterised by location (true_value+bias) and scale (sharpness)",
  bias_dist = character + default("norm") ~ "the distribution name of the estimator generation error function",
  bias_location = numeric + default(0) ~ "the location of the estimator generation error function, this is the true bias / mu_e",
  bias_scale = numeric + default(1) ~ "the scale of the estimator generation error function, this is the true uncertainty of the estimator / sigma_e",
  sharpness_dist = character + default("lnorm4") ~ "the distribution of the stated uncertainty of the estimator",
  sharpness_location = numeric + default(1) ~ "the location of the stated uncertainty of the estimator / sigma_s", # this is sigma_s
  sharpness_scale = numeric + default(0) ~ "the scale of the stated uncertainty of the estimator, determines how consistent the stated uncertainty is realtive to the true uncertainty / kappa, ",
)

i_sim_config = interfacer::iface(
  samples = integer ~ "The number of estimators simulated",
  link = character + default("identity") ~ "a transformation that puts the quantity being estimated on a linear scale",
  i_sim_setup
)

i_sim_plot = interfacer::iface(
  bias_quantile = numeric + default(0.5) ~ "The quantile of bias of the plotted prediction",
  sharpness_quantile = numeric + default(0.5) ~ "The quantile of sharpness of the plotted prediction",
  i_sim_setup
)
