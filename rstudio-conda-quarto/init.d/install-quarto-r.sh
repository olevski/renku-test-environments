#!/usr/bin/env bash
set -euox pipefail
Rscript -e 'install.packages("quarto", repos="https://cloud.r-project.org")' || echo "Failed to install"
