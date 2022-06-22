
snapshot:
	@aria2c -x16 https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car

init:
	@lily init --repo=.lily --config=config.toml --import-snapshot minimal_finality_stateroots_latest.car
	@lily daemon --repo=.lily --config=config.toml

daemon:
	@lily daemon --repo=.lily --config=config.toml

run-test:
	@lily job run --storage=CSV --window=30s --tasks="blocks" walk --from=1919860 --to=1919868 notify --queue="Notifier1"
	@lily job run --storage=CSV tipset-worker --queue="Worker1"
	@watch lily job list