#!/usr/bin/env bash

solana -u http://192.168.0.101:8899 airdrop 500 id.json
solana -u http://192.168.0.101:8899 create-vote-account --allow-unsafe-authorized-withdrawer vote.json id.json id.json -k id.json
solana -u http://192.168.0.101:8899 create-stake-account stake.json 1.00228288 -k id.json
solana -u http://192.168.0.101:8899 delegate-stake stake.json vote.json --force -k id.json

nohup agave-validator \
  --no-os-network-limits-test \
  --identity id.json \
  --vote-account vote.json \
  --entrypoint 192.168.0.101:8001 \
  --rpc-faucet-address 192.168.0.101:9900 \
  --gossip-port 8001 \
  --rpc-port 8899 \
  --ledger ledger \
  --log logs/solana-validator.log \
  --full-rpc-api \
  --allow-private-addr
