#!/usr/bin/env bash
set -e

# Run with Bahmni EMR
export RUN_WITH_BAHMNI_EMR=true
export EIP_TEST_ORDER_TYPE_UUID=f8ae333e-9d1a-423e-a6a8-c3a0687ebcf2
echo "$INFO Setting RUN_WITH_BAHMNI_EMR=true..."
echo "→ RUN_WITH_BAHMNI_EMR=$RUN_WITH_BAHMNI_EMR"
echo "→ EIP_TEST_ORDER_TYPE_UUID=$EIP_TEST_ORDER_TYPE_UUID"

source start.sh
