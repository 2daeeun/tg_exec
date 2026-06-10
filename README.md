# tg_exec.sh
명령어를 실행하고 그 결과(종료 코드, 실행 시간, 출력)를 텔레그램으로 보내주는 스크립트입니다.

## 설정
스크립트 상단의 두 값을 본인 것으로 채웁니다.

```bash
TG_TOKEN="봇_토큰"
TG_CHAT_ID="챗_ID"
```

## 사용법
```bash
# 예시
tg ./build.sh --release
```

명령이 끝나면 텔레그램으로 결과가 전송됩니다.

## 전역 명령어로 만들기
스크립트가 올라가 있는 URL에서 바로 받아 `tg` 라는 이름의 전역 명령어로 설치합니다.  
(설치 파일 이름이 곧 명령어 이름입니다. 다른 이름을 원하면 `/usr/local/bin/tg` 부분만 바꾸면 됩니다.)

```bash
sudo wget -O /usr/local/bin/tg https://raw.githubusercontent.com/2daeeun/tg_exec/refs/heads/main/tg_exec.sh
sudo chmod +x /usr/local/bin/tg
```

이제 어느 디렉토리에서든 `tg <명령어>` 를 실행할 수 있습니다.

다운로드 후 스크립트 상단의 `TG_TOKEN`, `TG_CHAT_ID` 값을 본인 것으로 채워야 합니다.

```bash
sudo nvim /usr/local/bin/tg
```
