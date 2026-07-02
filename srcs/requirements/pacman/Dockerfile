FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    git python3 python3-pip \
    xvfb x11vnc novnc websockify \
    fonts-dejavu-core libxrender1 libxext6 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --break-system-packages --no-cache-dir uv

RUN git clone https://github.com/Emanuelee00/Pacman.git /pacman
WORKDIR /pacman
RUN uv sync --python 3.13

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 6080

ENTRYPOINT ["/entrypoint.sh"]
