#!/usr/bin/env sh

# ===============================
# Cloudflare Argo 配置
# ===============================
ARGO_TOKEN=

# ===============================
# 哪吒监控配置（与 Node.js 版本语义一致）
# ===============================
NEZHA_SERVER="nazha.kkkk.hidns.co"   # v1: nz.abc.com:8008 | v0: nz.abc.com
NEZHA_PORT="443"       # v1 留空 | v0 填 443 / 5555 等
NEZHA_KEY="ZEE79y8zOazCJnT623"         # v1: NZ_CLIENT_SECRET | v0: Agent Key


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

  if [ -n "$NEZHA_PORT" ]; then
    # ---------- 哪吒 v0 ----------
    nohup $PWD/nezha-agent \
      -s ${NEZHA_SERVER}:${NEZHA_PORT} \
      -p ${NEZHA_KEY} \
      --tls \
      > $PWD/nezha.log 2>&1 &
  else
    # ---------- 哪吒 v1 ----------
    nohup $PWD/nezha-agent \
      -s ${NEZHA_SERVER} \
      -p ${NEZHA_KEY} \
      > $PWD/nezha.log 2>&1 &
  fi
else
  echo "[WARN] NEZHA_SERVER or NEZHA_KEY not set, skip Nezha Agent"
fi
