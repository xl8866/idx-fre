#!/usr/bin/env sh

# ===============================
# Cloudflare Argo 配置
# ===============================
ARGO_TOKEN=""

# ===============================
# 哪吒监控配置（哪吒 v0）
# ===============================
NEZHA_SERVER="nazha.kkkk.hidns.co"
NEZHA_PORT="443"
NEZHA_KEY="OEXrjQqQcPe3c855cu"


# ===============================
# 启动 cloudflared
# ===============================
if [ -z "$ARGO_TOKEN" ]; then
  nohup $PWD/cloudflared tunnel \
    --no-autoupdate \
    --edge-ip-version auto \
    --protocol http2 \
    --url http://localhost:8090 \
    > $PWD/argo.log 2>&1 &
else
  nohup $PWD/cloudflared tunnel \
    --no-autoupdate \
    --edge-ip-version auto \
    --protocol http2 \
    run --token "$ARGO_TOKEN" \
    > $PWD/argo.log 2>&1 &
fi


# ===============================
# 启动 哪吒探针
# ===============================
if [ -n "$NEZHA_SERVER" ] && [ -n "$NEZHA_KEY" ]; then
  echo "[INFO] Starting Nezha Agent..."

  nohup $PWD/nezha-agent \
    -s ${NEZHA_SERVER}:${NEZHA_PORT} \
    -p ${NEZHA_KEY} \
    --tls \
    > $PWD/nezha.log 2>&1 &
else
  echo "[WARN] NEZHA_SERVER or NEZHA_KEY not set, skip Nezha Agent"
fi
