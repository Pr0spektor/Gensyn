# Metrics — what the artifact actually reports

Source: `all_results.json`, `trainer_state.json` and `training_args.bin` at revision
`12e2029fcbffeccdff38721ded74e4f2a9cada6c`. Recomputed independently from the raw logs.

## Training

| Field | Published | Reconciled |
|---|---|---|
| Optimizer steps | 75 | 75 (`trainer_state.global_step`) |
| Logged points | — | 19 |
| Epochs | — | 5.377 |
| Dataset size | `train_samples = 53` | 53 prompts |
| Steps per second | 0.046 | 75 / 1630.47 s = 0.046 ✓ |
| Samples per second | 0.368 | **0.368 uses 600 presentations, not 53** |
| Train loss | 2.64e-4 | final logged value |

The samples-per-second field is internally inconsistent: `53 / 1630.47 = 0.0325`, while
`600 / 1630.47 = 0.368`. 600 is 75 steps × 8 (batch 2 × grad-accum 4), i.e. sample
*presentations*. Two fields of the same eight-line file use different denominators.

`train_results.json` is byte-identical to `all_results.json` (same SHA-256), so it is a duplicate
rather than a separate result set.

## Reward

| Quantity | Value |
|---|---|
| Mean reward (19 points) | 0.5751 |
| First / last | 0.3797 / 0.5112 |
| OLS slope | +0.00151 per step |
| Standard error | 0.00179 |
| t statistic | 0.84 |
| Permutation p (two-sided, 20k shuffles) | 0.41 |
| Significant at 5% | **No** |

Component means:

| Component | Mean | Share of reward |
|---|---|---|
| question_recreation | 0.2775 | 48% |
| xmlcount | 0.1964 | 34% |
| consensus | 0.0516 | 9% |
| final_correctness | 0.0369 | 6% |
| concensus_correctness | 0.0099 | 2% |
| strict_format | 0.0028 | 0.5% |
| soft_format | 0.0000 | 0% |
| cumulative_reward_2 | 0.0000 | 0% |

Question recreation and XML formatting account for 82% of the objective; answer correctness is
6%. Two of eight components are constant zero, so the effective objective is six terms, not
eight.

## Evaluation

None. `do_eval=false`, `best_metric=null`, and no log entry contains `eval_loss`. The only
performance number in the artifact is a training loss, which is not a quality measure.

## Checkpoint

`latest` points at `global_step25` while the run reached step 75. The published
`zero_pp_rank_0_mp_rank_00_model_states.pt` has 294 entries totalling 78,077 uncompressed bytes,
of which **0 bytes** are tensor payload: every `data/*` entry is zero-length. The 5.9 GB
optimizer-state shard cannot be consolidated without them.

## What would make these numbers meaningful

1. Evaluate base and fine-tune on the GSM8K test split (or whatever the prompt set implies),
   reporting n, mean and a confidence interval, plus raw generations.
2. Publish the final step, or state that the artifact is an intermediate checkpoint.
3. Report correctness separately from format, and drop the two always-zero components.
4. Use more than 2 generations per prompt: GRPO normalises advantages within a group, and a
   group of 2 estimates the standard deviation from two points.
