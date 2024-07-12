# Dockerize a Solana Validator and Run a Mini Cluster

### Requirements
1) Docker installed on your system
2) A copy of Solana monorepo

## Steps

### Setup
#### Build desired solana version
```
cd solana
cargo build --release
```

#### Create subnet for cluster:
```
docker network create --driver=bridge --subnet=192.168.0.0/24 solana-cluster
```

### Bootstrap Validator
#### Setup docker configuration
```
# run from within solana repo
mkdir docker-config
cd docker-config
mkdir -p bootstrap/ledger
cd bootstrap
```

#### generate bootstrap accounts
Copy `bootstrap/generate-bootstrap-accounts.sh` and `bootstrap/create-genesis.sh` into `solana/docker-config/bootstrap/`
```
# run from within docker-config/bootstrap/
./generate-bootstrap-accounts.sh
```

#### Create genesis
```
# run from within docker-config/bootstrap/
./create-genesis.sh
```

#### Create Dockerfile
```
# run from within solana/ repo
mkdir docker-build
cd docker-build
mkdir bootstrap
cd bootstrap
```

Copy `bootstrap/Dockerfile` and `bootstrap/bootstrap-validator.sh` into `solana/docker-build/bootstrap/`

#### Build docker container
```
# run from solana/ repo
docker build -t <registry-name>/<container-name>:<tag> -f docker-build/bootstrap/Dockerfile .

# example:
docker build -t gregcusack/bootstrap-test:latest -f docker-build/bootstrap/Dockerfile .
```

#### Run docker container
```
docker run -it -d --name bootstrap --network=solana-cluster --ip=192.168.0.101 gregcusack/bootstrap-test:latest
```

#### Ensure container is running
```
docker ps -a
```

#### exec into container and get logs
```
# get container-id from command above
docker exec -it <container-id> /bin/bash
tail -f logs/solana-validator.log
```

### Standard Validator
#### Setup Standard Validator
```
# from solana/
cd docker-config
mkdir validator
cd validator
```

#### Generate Validator Accounts
Copy `validator/generate-validator-accounts.sh` into `solana/docker-config/validator/`
```
# run from within docker-config/bootstrap/
./generate-bootstrap-accounts.sh
```

#### Create Dockerfile
```
# from solana/
cd docker-build
mkdir validator
cd validator
```

#### Copy into Dockerfile
Copy `validator/Dockerfile` and `validator/validator.sh` into `solana/docker-build/validator/`

#### Build validator image
```
#run from solana/
docker build -t <registry-name>/<container-name>:<tag> -f docker-build/bootstrap/Dockerfile .

# example
docker build -t gregcusack/validator-test:latest -f docker-build/validator/Dockerfile .
```

#### Run Validator
```
docker run -it -d --name validator --network=solana-cluster --ip=192.168.0.102 gregcusack/validator-test:latest
```

#### Ensure container is running
```
docker ps -a
```

#### exec into container and get logs
```
# get container-id from command above
docker exec -it <container-id> /bin/bash
tail -f logs/solana-validator.log
```

#### Ensure containers are connected
```
# execute from within either container
solana -ul gossip
solana -ul validators
```

Note: may take some time for validator to catch up to the bootstrap. so may not see both validators in `solana -ul validators` immediately.

### Docker tips
1) Stop container:
```
docker stop <container-name>
```
2) Delete container name
```
docker rm <container-name>
```
3) If you need to push your container into a repo repository:
  - Ensure you have a docker repository setup. You should have a default one under your docker username
  - login to docker on the command line:
```
docker login
# follow username/password prompts
```
  - In this case, your docker image must be of the format: 
```
<registry-name>/<container-name>:<tag>
```
  - Build your docker container as above
  - Push it to your registry:
```
docker push <registry-name>/<container-name>:<tag>
```
