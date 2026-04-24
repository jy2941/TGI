mat   <- readMat("matrix_1.mat")
R <- mat$R
m <- mat$m
n <- mat$n
size <- mat$size
rm(mat)

nRuns    <- 10
sample_n <- 500
# Ground truth (1-based, fixed)
true_X  <- 1:40
false_X <- 41:450
true_Y  <- 1:90
false_Y <- 91:550

compute_metrics <- function(detected_X, detected_Y) {
  TP_X  <- length(intersect(detected_X, true_X))
  TN_X  <- length(setdiff(false_X,      detected_X))
  TPR_X <- TP_X / 40
  TNR_X <- TN_X / 410
  TP_Y  <- length(intersect(detected_Y, true_Y))
  TN_Y  <- length(setdiff(false_Y,      detected_Y))
  TPR_Y <- TP_Y / 90
  TNR_Y <- TN_Y / 460
  list(TPR = (TPR_X + TPR_Y) / 2,
       TNR = (TNR_X + TNR_Y) / 2)
}

TPR_JIVE   <- numeric(nRuns); TNR_JIVE   <- numeric(nRuns)
TPR_DIABLO <- numeric(nRuns); TNR_DIABLO <- numeric(nRuns)

# ============================================================
# 100 runs
# ============================================================
for (run in 1:nRuns) {
  set.seed(run)
  
  # Generate data same as MATLAB: mvnrnd(mu, R, sample_n)
  data  <- MASS::mvrnorm(n = sample_n, mu = rep(0, size), Sigma = R)
  X_run <- data[, 1:m]            # 500 x 450
  Y_run <- data[, (m+1):(m+n)]    # 500 x 550
  
  # ----------------------------------------------------------
  # JIVE
  # ----------------------------------------------------------
  jive_fit <- jive(list(t(X_run), t(Y_run)),   # features x samples
                   rankJ    = 2,
                   rankA    = c(2, 2),
                   method   = "given",
                   maxiter  = 10
                   )
  
  load_X  <- jive_fit$joint[[1]]   # 450 x rankJ
  load_Y  <- jive_fit$joint[[2]]   # 550 x rankJ
  
  score_X <- rowSums(load_X^2)
  score_Y <- rowSums(load_Y^2)
  
  det_X_JIVE <- which(score_X > mean(score_X) + sd(score_X))
  det_Y_JIVE <- which(score_Y > mean(score_Y) + sd(score_Y))
  
  m_JIVE        <- compute_metrics(det_X_JIVE, det_Y_JIVE)
  TPR_JIVE[run] <- m_JIVE$TPR
  TNR_JIVE[run] <- m_JIVE$TNR
  
  # ----------------------------------------------------------
  # DIABLO
  # ----------------------------------------------------------
  dummy_Y    <- factor(rep(c("A","B"), each = sample_n / 2))
  design     <- matrix(0.5, 2, 2, dimnames = list(c("X","Y"), c("X","Y")))
  diag(design) <- 0
  
  diablo_fit <- block.splsda(X      = list(X = X_run, Y = Y_run),
                             Y      = dummy_Y,
                             ncomp  = 2,
                             design = design,
                             keepX  = list(X = c(50, 50),
                                           Y = c(90, 90)))
  
  sel_X <- unique(unlist(lapply(1:2, function(comp)
    selectVar(diablo_fit, block = "X", comp = comp)$X$name)))
  sel_Y <- unique(unlist(lapply(1:2, function(comp)
    selectVar(diablo_fit, block = "Y", comp = comp)$Y$name)))
  
  det_X_DIABLO <- as.integer(gsub("[^0-9]", "", sel_X))
  det_Y_DIABLO <- as.integer(gsub("[^0-9]", "", sel_Y))
  
  m_DIABLO        <- compute_metrics(det_X_DIABLO, det_Y_DIABLO)
  TPR_DIABLO[run] <- m_DIABLO$TPR
  TNR_DIABLO[run] <- m_DIABLO$TNR
  
  cat(sprintf("Run %2d | JIVE TPR=%.3f TNR=%.3f | DIABLO TPR=%.3f TNR=%.3f\n",
              run, TPR_JIVE[run], TNR_JIVE[run],
              TPR_DIABLO[run], TNR_DIABLO[run]))
}
