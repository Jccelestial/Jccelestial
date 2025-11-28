#!/usr/bin/env bash
set -euo pipefail

# create-and-push-repo.sh
# Helper script to create a GitHub repository (using 'gh') and push this local project to it.
# Requirements: 'gh' (GitHub CLI), 'git' installed and authenticated (gh auth login), user logged in to gh.

usage() {
  cat <<EOF
Usage: $0 [--name <repo-name>] [--visibility public|private] [--owner <username-or-org>]

Creates a new GitHub repository using 'gh', adjusts the 'origin' remote, and pushes the current branch.
If the 'origin' remote exists, the script will offer to rename or replace it.
EOF
}

REPO_NAME=""
VISIBILITY="private"
OWNER=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --name) REPO_NAME="$2"; shift 2;;
    --visibility) VISIBILITY="$2"; shift 2;;
    --owner) OWNER="$2"; shift 2;;
    --help|-h) usage; exit 0;;
    *) echo "Unknown argument: $1"; usage; exit 1;;
  esac
done

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI is required. Install: https://cli.github.com/"
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "git is required. Please install git."
  exit 1
fi

if [ -z "$REPO_NAME" ]; then
  read -r -p "Enter a repository name (e.g. parsu-admin-dashboard): " REPO_NAME
fi

if [ -z "$OWNER" ]; then
  read -r -p "Enter the GitHub owner (username or org; default is your account): " OWNER
fi

if [ -z "$OWNER" ]; then
  # By default, gh repo create will use the authenticated user if owner omitted
  CREATE_OWNER_ARG=""
else
  CREATE_OWNER_ARG="--owner $OWNER"
fi

echo "Creating repository '$REPO_NAME' (visibility: $VISIBILITY) under owner: ${OWNER:-<default>}"

# Create the repo via GH CLI
if gh repo view "$REPO_NAME" >/dev/null 2>&1; then
  echo "Repository already exists on GitHub; aborting creation. If you want to use or replace the remote, handle manually."
  exit 1
fi

if [ "$VISIBILITY" != "public" ] && [ "$VISIBILITY" != "private" ]; then
  echo "Visibility must be 'public' or 'private'"
  exit 1
fi

echo "Running 'gh repo create'..."
gh repo create "$REPO_NAME" $CREATE_OWNER_ARG --$VISIBILITY --source=. --remote=origin --push

echo "Repository created and pushed as 'origin' successfully."

echo "If you had an existing remote, it was replaced with the new origin. Use 'git remote -v' to confirm."

echo "Done."
