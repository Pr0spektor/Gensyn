# Gensyn — Qwen2.5-0.5B GRPO experiment

**Status: experimental artifact, not a validated model.** This repository documents a single
GRPO run and points at the published weights. There is no training code here — the artifact is
the Hugging Face repository below.

**Artifact:** [TonyStern/Qwen2.5-0.5B-Instruct-Gensyn-Swarm-eager_pouncing_trout](https://huggingface.co/TonyStern/Qwen2.5-0.5B-Instruct-Gensyn-Swarm-eager_pouncing_trout)
pinned at revision `12e2029fcbffeccdff38721ded74e4f2a9cada6c` (last modified 2025-04-18).

## What the run was

- A **multi-node DeepSpeed ZeRO** run (`runs/gsm8k/multinode/...`), not a local single-machine
  run as the earlier one-line README implied.
- **75 optimizer steps**, 19 logged points, 5.38 epochs over **53 prompts**.
- GRPO with 2 generations per prompt, batch 2 × gradient accumulation 4, lr 1e-6, bf16,
  `save_steps=25`.

## What it is not

- **No evaluation.** `do_eval=false`, no `eval_loss` in any log entry, no held-out benchmark,
  no generation samples.
- **The reward trend is not statistically significant.** Slope +0.0015/step, SE 0.0018,
  t = 0.84, two-sided permutation p = 0.41 over 19 points.
- **82% of the reward is proxy terms.** Question-recreation (0.278) and XML-count (0.196) of a
  0.575 mean reward; `soft_format` and `cumulative_reward_2` are identically zero.
- **The published checkpoint is step 25 of 75**, and its DeepSpeed model-states file contains
  metadata only — all 290 `data/*` tensor entries are zero-length, so it cannot be consolidated.

Reconciled numbers: [metrics.json](metrics.json) and [docs/METRICS.md](docs/METRICS.md).

## Security notice

`training_args.bin` in the artifact contains a serialized `push_to_hub_token`. It is **expired**
(the Hub returns 401 for it), but the same mechanism will leak a live token on the next run, and
the file is a pickle loaded through `torch.load`, which makes a substituted file an arbitrary
code-execution vector for anyone calling `GRPOConfig.load()`.

To remove it from history: revoke the token first, then run
[`tools/purge_hf_history.sh`](tools/purge_hf_history.sh). Deleting the file from the current tree
is not enough — it remains downloadable by commit SHA.

## Licence

Apache-2.0 — see [LICENSE](LICENSE) and [NOTICE](NOTICE).

Base model: [Gensyn/Qwen2.5-0.5B-Instruct](https://huggingface.co/Gensyn/Qwen2.5-0.5B-Instruct)
(Apache-2.0), itself derived from Qwen2.5-0.5B-Instruct (Apache-2.0).

Not affiliated with, or endorsed by, Gensyn unless separately stated.
