#!/bin/bash

nohup solana-faucet --keypair faucet.json >logs/faucet.log 2>&1 &

nohup agave-validator \
  --no-os-network-limits-test \
  --no-wait-for-vote-to-start-leader \
  --full-snapshot-interval-slots 200 \
  --identity id.json \
  --vote-account vote.json \
  --ledger ledger \
  --log logs/solana-validator.log \
  --gossip-host 192.168.0.101 \
  --gossip-port 8001 \
  --rpc-port 8899 \
  --rpc-faucet-address 127.0.0.1:9900 \
  --full-rpc-api \
  --allow-private-addr