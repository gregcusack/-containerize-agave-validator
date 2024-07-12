FROM ubuntu:22.04
RUN apt-get update && apt-get install -y iputils-ping curl vim && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash solana && \
    adduser solana sudo

USER solana
RUN mkdir -p /home/solana/logs
COPY --chown=solana:solana ./docker-config/validator /home/solana/
COPY --chown=solana:solana ./docker-build/validator/validator.sh /home/solana

COPY --chown=solana:solana ./target/release/agave-validator /home/solana/bin/
COPY --chown=solana:solana ./target/release/solana /home/solana/bin/
COPY --chown=solana:solana ./target/release/solana-faucet /home/solana/bin/
ENV PATH="/home/solana/bin:${PATH}"

WORKDIR /home/solana
CMD ["./validator.sh"]