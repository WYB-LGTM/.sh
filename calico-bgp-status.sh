#!/bin/bash
# calico-bgp-status - 查看 Calico BGP 邻居状态
# 背景：Calico v3.33 起 calico-node 使用统一二进制 /usr/bin/calico（calico component felix ...），
#       不再是 calico-node 进程名，导致 calicoctl node status 的进程检测失效，误报
#       "Calico process is not running."。本脚本直接进 Pod 查询 bird socket，结果可靠。
# 用法：calico-bgp-status            # 所有节点
#       calico-bgp-status master1.magedu.com   # 指定节点
set -u
NS="${NS:-kube-system}"
SELECTOR="-l k8s-app=calico-node"
[ "$#" -ge 1 ] && SELECTOR="$SELECTOR --field-selector spec.nodeName=$1"

LIST=$(kubectl -n "$NS" get pod $SELECTOR -o jsonpath='{range .items[*]}{.metadata.name} {.spec.nodeName}{"\n"}{end}' 2>&1)
if [ -z "$LIST" ]; then
  echo "未找到 calico-node Pod (namespace=$NS)" >&2
  exit 1
fi

rc_all=0
while read -r POD NODE; do
  [ -z "$POD" ] && continue
  echo "===== $NODE ($POD) ====="
  OUT=$(kubectl -n "$NS" exec "$POD" -c calico-node -- birdcl -s /var/run/calico/bird.ctl show protocols 2>&1)
  echo "$OUT" | sed -n '1p; / BGP /p'
  DOWN=$(echo "$OUT" | grep ' BGP ' | grep -vc 'Established')
  TOTAL=$(echo "$OUT" | grep -c ' BGP ')
  if [ "$DOWN" -gt 0 ]; then
    echo ">>> 警告：$DOWN/$TOTAL 个 BGP 邻居未 Established"
    rc_all=1
  fi
done <<< "$LIST"
exit $rc_all
