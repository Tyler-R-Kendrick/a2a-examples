# a2a-examples

This repository contains a minimal example showing how simple Python agents can
be discovered automatically and orchestrated from a main process.

## Running

After installing Python 3.12, run the `main.py` script:

```bash
python3 main.py
```

The orchestrator will discover agents defined in the `agents/` package and run
them sequentially.


## Development

Install development dependencies and run the checks used in CI:

```bash
pip install flake8 build pytest pytest-asyncio
pip install -e .
flake8 .
python -m build
pytest
```
