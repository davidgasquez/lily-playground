IMAGE_NAME=davidgasquez/lily-playground:latest

build:
	docker build -t $(IMAGE_NAME) .

dev: build
	docker run -it -u vscode --rm -v $(PWD):/workspace/ $(IMAGE_NAME)

push:
	docker push $(IMAGE_NAME)

get-latest-snapshot:
	@aria2c -x16 https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car

init:
	@lily init --repo=.lily --config=config.toml --import-snapshot minimal_finality_stateroots_latest.car

daemon:
	@lily daemon --repo=.lily --config=config.toml

clean:
	@rm -rf .lily/ *.car
	@sudo rm -rf .redis .timescaledb
