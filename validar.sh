#!/usr/bin/env bash
# Valida o cluster e salva as evidencias em evidencias/05-validacao.log
cd "$(dirname "$0")/ansible" || exit 1
mkdir -p ../evidencias

{
  for cmd in \
    "kubectl get nodes -o wide" \
    "kubectl get pods -A" \
    "kubectl get svc -A" \
    "kubectl get deployment" \
    "kubectl get pods -o wide" \
    "kubectl get svc"; do
    echo "### $cmd"
    ansible control_plane -a "$cmd" | tail -n +2
    echo
  done

  echo "### Teste do NGINX via NodePort 30080 (6 requisicoes)"
  ansible control_plane -m shell \
    -a 'for i in 1 2 3 4 5 6; do curl -s --max-time 5 http://localhost:30080 | grep -o "Pod: [a-z0-9-]*"; done' | tail -n +2
} | tee ../evidencias/05-validacao.log
