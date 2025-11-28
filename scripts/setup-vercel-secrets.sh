#!/usr/bin/env bash
# Helper script to set GitHub repository secrets for the Vercel GitHub Action.
# Requires the GitHub CLI (gh) authenticated and installed.

set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI 'gh' not found. Install: https://cli.github.com/"
  exit 1
fi

read -r -p "Enter Vercel token (VERCEL_TOKEN): " -s VERCEL_TOKEN
echo
read -r -p "Enter Vercel org ID (VERCEL_ORG_ID): " VERCEL_ORG_ID
read -r -p "Enter Vercel project ID (VERCEL_PROJECT_ID): " VERCEL_PROJECT_ID

echo "Setting secrets via gh CLI..."

gh secret set VERCEL_TOKEN --body "$VERCEL_TOKEN"
gh secret set VERCEL_ORG_ID --body "$VERCEL_ORG_ID"
gh secret set VERCEL_PROJECT_ID --body "$VERCEL_PROJECT_ID"

echo "Secrets set. To verify, run 'gh secret list'."

echo "Done."
