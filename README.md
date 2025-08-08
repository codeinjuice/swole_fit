# Swolfit 🏋️‍♂️

운동 정보를 탐색하고 관리할 수 있는 Flutter 기반 모바일 앱입니다.

## 맛보기
<img src="https://github.com/user-attachments/assets/18035a5f-572f-4a8e-848e-db8409010033">

## 주요 기능

### 🎯 BodyPart 기반 운동 탐색
- 10개 신체 부위별 운동 분류 (back, cardio, chest, lower arms, lower legs, neck, shoulders, upper arms, upper legs, waist)
- 직관적인 그리드 레이아웃과 부위별 아이콘
- 계층적 네비게이션 구조

### 📱 탭 기반 인터페이스
- **Workouts**: 운동 탐색 및 상세 정보
- **Routines**: 운동 루틴 관리 (개발 예정)
- **Calendar**: 운동 일정 관리 (개발 예정)
- **Settings**: 앱 설정 (개발 예정)

### 🖼️ 운동 상세 정보
- 운동명, 타겟 부위, 장비 정보
- GIF 애니메이션 표시
- 따라하기 쉬운 운동 이미지 (1080p)
- 세련된 카드 기반 UI

## 기술 스택

- **Framework**: Flutter 3.32.8
- **Language**: Dart
- **API**: ExerciseDB (RapidAPI)
- **Platform**: iOS, Android

## API 엔드포인트

ExerciseDB API를 활용한 7개 엔드포인트:
- 모든 운동 목록
- 운동 부위 목록
- 특정 운동 정보
- 신체 부위 목록
- 신체 부위별 운동 목록
- 운동 이미지 (720p)

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── pages/                    # 페이지 컴포넌트
│   ├── workouts_page.dart    # 운동 탐색 페이지
│   ├── routines_page.dart    # 루틴 페이지
│   ├── calendar_page.dart    # 캘린더 페이지
│   └── settings_page.dart    # 설정 페이지
└── services/                 # API 서비스
    └── exercise_api_service.dart
```

## 설치 및 실행

1. Flutter 환경 설정
```bash
flutter doctor
```

2. 의존성 설치
```bash
flutter pub get
```

3. 앱 실행
```bash
flutter run
```

## 개발 환경

- **OS**: macOS 15.4.1
- **IDE**: VS Code / Android Studio
- **Simulator**: iPhone 16 Plus (iOS 18.4)

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

---

**Swolfit** - 당신의 운동 여정을 더욱 스마트하게! 💪
