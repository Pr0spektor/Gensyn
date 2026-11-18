---
license: apache-2.0
base_model: Gensyn/Qwen2.5-0.5B-Instruct
language:
  - en
tags:
  - grpo
  - trl
  - experimental
---

# Qwen2.5-0.5B-Instruct — GRPO experiment

This is an **experimental checkpoint**, not a validated model. It continues GRPO training from
`Gensyn/Qwen2.5-0.5B-Instruct` for 75 optimizer steps.

## Training

- 53 prompts, 5.38 epochs, 75 steps
- GRPO, 2 generations per prompt, batch 2 × grad-accum 4, lr 1e-6, bf16
- Multi-node DeepSpeed ZeRO

## Evaluation

**None.** No held-out benchmark was run, no eval loss was logged. The reward trend over the run
is not statistically significant (slope +0.0015/step, SE 0.0018, permutation p = 0.41), and 82%
of the reward comes from question-recreation and XML-format terms rather than answer correctness.
Do not treat this checkpoint as an improvement on the base model without evaluating it.

## Checkpoint

This repository publishes step 25 of 75. The DeepSpeed model-states file contains metadata only
(zero-length tensor entries), so it cannot be consolidated with the bundled `zero_to_fp32.py`.

## Licence

Apache-2.0. Derived from `Gensyn/Qwen2.5-0.5B-Instruct` (Apache-2.0) and Qwen2.5-0.5B-Instruct.
See the NOTICE in the GitHub repository for attribution and the changes made.
