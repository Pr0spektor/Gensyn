#!/usr/bin/env bash
# Remove training_args.bin from a Hugging Face repository *history*.
#
# The file contains a serialized push_to_hub_token (expired when this was written) and is a
# pickle loaded by torch.load. Deleting it from the current tree is not enough: it stays in
# history and remains downloadable by commit SHA.
#
# Requirements: git, git-filter-repo (pip install git-filter-repo), a WRITE token.
# Revoke the leaked token BEFORE running this.
#
# Usage:
#   export HF_TOKEN=hf_xxxxxxxx        # write token; never commit it
#   ./tools/purge_hf_history.sh
set -euo pipefail

REPO="${HF_REPO:-TonyStern/Qwen2.5-0.5B-Instruct-Gensyn-Swarm-eager_pouncing_trout}"
FILE="${TARGET_FILE:-training_args.bin}"

: "${HF_TOKEN:?set HF_TOKEN to a write token}"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo "Cloning ${REPO} ..."
git clone "https://user:${HF_TOKEN}@huggingface.co/${REPO}" "$WORK/repo"
cd "$WORK/repo"

echo "Rewriting history without ${FILE} ..."
git filter-repo --path "$FILE" --invert-paths --force

git remote add origin "https://user:${HF_TOKEN}@huggingface.co/${REPO}"
git push --force origin HEAD:main

cat <<'MSG'

History rewritten and force-pushed.

Two follow-ups that the script cannot do for you:

1. Old objects may stay reachable by SHA until the Hub garbage-collects them. Check with
   curl -I https://huggingface.co/<repo>/resolve/<old-sha>/training_args.bin
   If that still returns 200, ask Hugging Face support to purge the repository storage,
   or delete and re-create the repository.
2. Set `push_to_hub_token=None` (or use `hf auth login`) in future runs, and add a secret
   scanner to the publishing pipeline so a token cannot be serialized again.

MSG
