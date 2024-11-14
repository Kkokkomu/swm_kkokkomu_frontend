# dev_app_release_note 파일 이름 설정
FILE="dev_app_release_note.txt"

# 사용자에게 dev_app_release_note 입력 요청
echo "변경사항을 입력하세요 (종료하려면 Ctrl+D를 누르세요):"

# 사용자 입력을 파일에 저장
cat > "$FILE"

echo "변경사항이 $FILE에 저장되었습니다."

# fastlane을 이용한 dev_app_distribution 실행
cd android
echo "안드로이드 dev 앱 배포 시작"
bundle exec fastlane dev_app_distribution
cd ../ios
echo "iOS dev 앱 배포 시작"
bundle exec fastlane dev_testflight
