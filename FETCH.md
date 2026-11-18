# Fetching the artifact

The weights live on Hugging Face, not in this repository:

```bash
git clone https://huggingface.co/TonyStern/Qwen2.5-0.5B-Instruct-Gensyn-Swarm-eager_pouncing_trout
```

Pinned revision: `12e2029fcbffeccdff38721ded74e4f2a9cada6c` (2025-04-18).

To pin it explicitly:

```bash
git clone https://huggingface.co/TonyStern/Qwen2.5-0.5B-Instruct-Gensyn-Swarm-eager_pouncing_trout
cd Qwen2.5-0.5B-Instruct-Gensyn-Swarm-eager_pouncing_trout
git checkout 12e2029fcbffeccdff38721ded74e4f2a9cada6c
```

Note: the artifact contains `training_args.bin` with a serialized (expired) token — see the
security section of the README before loading it.
