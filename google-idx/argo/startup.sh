#!/usr/bin/env sh

# ===============================
# Cloudflare Argo 配置
# ===============================
ARGO_TOKEN=

# ===============================
# 哪吒 v0 探针配置
# ===============================
NEZHA_SERVER="nazha.kkkk.hidns.co"  # v0 面板域名
NEZHA_PORT="443"                     # v0 Agent 端口
NEZHA_KEY="OEXrjQqQcPe3c855cu"      # v0 Agent Key

# ===============================
# 启动 cloudflared 隧道
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
    --protocol http2 run --token "$ARGO_TOKEN" \
    > $PWD/argo.log 2>&1 &
fi

# ===============================
# 启动 哪吒 v0 探针
# ===============================
if [ -n "$NEZHA_SERVER" ] && [ -n "$NEZHA_KEY" ]; then
  echo "[INFO] Starting Nezha v0 Agent..."

  nohup $PWD/nezha-agent \
    -s ${NEZHA_SERVER}:${NEZHA_PORT} \
    -p ${NEZHA_KEY} \
    --insecure \
    > $PWD/nezha.log 2>&1 &
else
  echo "[WARN] NEZHA_SERVER or NEZHA_KEY not set, skipping Nezha Agent"
fi
