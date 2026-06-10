#!/usr/bin/env bash
set -u

# telegram bot 설정
# TG_TOKEN="${TG_TOKEN:-}"
# TG_CHAT_ID="${TG_CHAT_ID:-}"
TG_TOKEN="8710_봇_토큰_nlrbFJ"
TG_CHAT_ID="829_예시_쳇_ID_83120"

if [ -z "$TG_TOKEN" ] || [ -z "$TG_CHAT_ID" ]; then
  echo "TG_TOKEN 또는 TG_CHAT_ID가 비어 있습니다."
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "사용법: $0 <command> [args...]"
  exit 1
fi

HOSTNAME_STR="$(hostname)"
WORKDIR_STR="$(pwd)"
START_TS="$(date +%s)"

TMP_OUT="$(mktemp /tmp/tgcmd.XXXXXX.log)"
trap 'rm -f "$TMP_OUT"' EXIT

CMD_STR="$*"

# 명령 실행 및 출력 저장
"$@" >"$TMP_OUT" 2>&1
RC=$?

END_TS="$(date +%s)"
DURATION=$((END_TS - START_TS))

# 너무 긴 출력은 텔레그램 메시지 길이 제한 때문에 잘라서 보냄
MAX_CHARS=3000
OUTPUT_CONTENT="$(cat "$TMP_OUT")"
OUTPUT_LEN="${#OUTPUT_CONTENT}"

if [ "$OUTPUT_LEN" -gt "$MAX_CHARS" ]; then
  OUTPUT_CONTENT="$(tail -c "$MAX_CHARS" "$TMP_OUT")"
  OUTPUT_CONTENT="[출력이 길어서 마지막 ${MAX_CHARS}자만 전송]\n${OUTPUT_CONTENT}"
fi

MESSAGE="$(
  cat <<EOF
[$HOSTNAME_STR] 명령 종료

cmd: $CMD_STR
rc: $RC
time: ${DURATION}s
pwd: $WORKDIR_STR

----- output -----
$OUTPUT_CONTENT
EOF
)"

curl -sS -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
  -d chat_id="$TG_CHAT_ID" \
  --data-urlencode text="$MESSAGE" >/dev/null

exit "$RC"
