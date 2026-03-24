@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
echo ================================
echo  GitHub Folder Uploader
echo ================================
set /p folder="업로드할 폴더 전체 경로를 입력하세요: "
if not exist "!folder!" (
  echo ERROR: 폴더가 존재하지 않습니다.
  pause
  exit /b
)
cd /d "!folder!"
set /p repo="GitHub 원격 URL을 입력하세요 (예: https://github.com/user/repo.git): "
if not exist ".git" (
  git init
  echo Git 리포지토리 초기화 완료.
  ) else (
  echo 이미 Git 리포지토리가 초기화되어 있습니다.
)
git remote remove origin >nul 2>&1
git remote add origin !repo!
git add .
set /p msg="커밋 메시지를 입력하세요: "
git commit -m "!msg!" >nul 2>&1
if errorlevel 1 (
  echo 이미 커밋된 변경 사항이 없습니다.
  ) else (
  echo 커밋 완료.
)
git branch -M main
echo.
echo ================================
echo 원격 리포지토리에 이미 내용이 있는 경우 충돌이 발생할 수 있습니다.
echo 1. 강제 푸시 (기존 내용 덮어쓰기)
echo 2. 안전하게 pull 후 병합
echo 3. 취소
set /p choice="선택하세요 [1/2/3]: "
if "!choice!"=="1" (
  git push -u origin main --force
  echo 강제 푸시 완료.
  ) else if "!choice!"=="2" (
  git pull origin main --rebase
  if errorlevel 1 (
    echo 충돌 발생 수동으로 해결 후 'git rebase --continue' 실행 필요.
    ) else (
    git push -u origin main
    echo 안전 푸시 완료.
  )
  ) else (
  echo 작업 취소.
)
echo ================================
echo 작업 완료.
pause
