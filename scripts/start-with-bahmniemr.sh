#!/usr/bin/env bash
set -e

# Run with Bahmni EMR
export RUN_WITH_BAHMNI_EMR=true
echo "$INFO Setting RUN_WITH_BAHMNI_EMR=true..."
echo "→ RUN_WITH_BAHMNI_EMR=$RUN_WITH_BAHMNI_EMR"

source start.sh
