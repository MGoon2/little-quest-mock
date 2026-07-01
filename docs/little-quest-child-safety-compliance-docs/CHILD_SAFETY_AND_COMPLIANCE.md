# Little Quest — 아동 안전·개인정보·위치·AI 준수 설계 문서

> 문서 목적: Little Quest의 국내 MVP 출시 전, 아동 대상 서비스로서 반드시 반영해야 할 개인정보·위치정보·사진·AI·결제·운영 정책을 제품/개발 문서에 반영하기 위한 기준 문서다.
> 주의: 이 문서는 개발·기획 체크리스트이며 법률 자문이 아니다. 출시 전 개인정보/위치정보/아동 서비스 전문 법무 검토가 필요하다.

---

## 1. Little Quest의 준수 리스크 요약

Little Quest는 일반 교육 앱이 아니라 다음 요소가 동시에 포함된다.

- 아동 사용 가능성
- 사진 촬영/업로드
- 사진 기반 AI 분석
- 위치정보/GPS/지도 핀
- 생년월일/프로필/관찰 기록
- 카드 수집/게임화
- 구독/유료 기능 가능성
- 가족/보호자 사용 가능성

따라서 MVP부터 아래 원칙을 기본값으로 둔다.

1. 만 14세 미만 아동은 보호자 동의 없이는 계정을 만들 수 없다.
2. 사진은 AI 전송 전에 압축·리사이즈·메타데이터 제거를 거친다.
3. 정확한 위치는 기본 공개하지 않는다.
4. 아이 화면에서 직접 결제를 유도하지 않는다.
5. 광고 SDK는 MVP에 넣지 않는다.
6. 보호자가 아이 데이터 열람·수정·삭제·동의 철회를 할 수 있어야 한다.
7. AI 결과는 교육용 참고 정보이며 틀릴 수 있음을 고지한다.
8. 아이에게 위험 행동을 유도하는 문구를 금지한다.

---

## 2. 회원가입과 연령 분기

### 2.1 생년월일 입력은 필수

회원가입 단계에서 생년월일을 입력받아 연령을 판단한다.

```text
회원가입
→ 생년월일 입력
→ 만 14세 이상: 일반 가입 진행
→ 만 14세 미만: 보호자 동의 플로우 진입
```

### 2.2 만 14세 미만 보호자 동의

만 14세 미만 사용자의 개인정보를 수집·이용하려면 보호자 동의가 필요하다.

MVP 플로우:

```text
생년월일 입력
→ 만 14세 미만 판단
→ 보호자 동의 필요 화면
→ 보호자 이메일 또는 휴대폰 입력
→ 보호자 인증/동의
→ 동의 완료 후 아이 계정 생성 또는 사용 허용
```

### 2.3 보호자 동의 전 제한

보호자 동의가 완료되기 전에는 아래 기능을 막는다.

- 사진 업로드
- 위치 저장
- AI 분석
- 카드 생성
- 지도 핀 생성
- 구독/결제
- 외부 공유

허용 가능 기능:

- 앱 소개 보기
- 샘플 카드 보기
- 보호자 동의 요청 재전송
- 로그인/로그아웃

---

## 3. 동의 항목 분리

회원가입에서 하나의 통합 체크박스로 처리하지 않는다. 최소한 다음 동의를 분리한다.

### 3.1 필수 동의

- 서비스 이용약관
- 개인정보 수집·이용 동의
- 만 14세 미만 보호자 동의
- 사진 업로드 및 분석 동의
- AI 분석을 위한 외부 처리 동의
- 위치정보 수집·이용 동의
  단, 위치 기능을 사용하지 않는 기본 서비스가 가능하다면 위치 동의는 기능 사용 시점에 별도 요청할 수 있다.

### 3.2 선택 동의

- 마케팅/이벤트 알림
- 푸시 알림
- 연구/품질 개선 목적의 비식별 데이터 사용
- 공개 공유 기능 사용

MVP에서는 마케팅 동의와 공개 공유 기능을 제외하거나 비활성화하는 것을 권장한다.

---

## 4. 위치정보 정책

Little Quest는 지도 핀, 탐험 기록, 위치 기반 퀘스트를 다룬다. 따라서 위치정보 정책을 명확히 둔다.

### 4.1 권한 요청 시점

앱 실행 직후 위치 권한을 요청하지 않는다. 위치가 필요한 시점에 요청한다.

```text
사진 촬영/업로드
→ 위치 기록을 함께 남길까요?
→ 권한 요청
```

### 4.2 위치 권한 거부 시 대체 플로우

위치 권한을 거부해도 앱의 핵심 기능이 완전히 막히면 안 된다.

```text
위치 권한 허용
→ 발견 장소 저장
→ 지도 핀 생성
→ 위치 기반 퀘스트 참여 가능

위치 권한 거부
→ 사진 분석 가능
→ 카드 생성 가능
→ 지도 핀 없음
→ 위치 기반 퀘스트 제한
```

### 4.3 위치 표시 수준

정확한 좌표는 기본적으로 공개하지 않는다.

```text
내부 저장: 정확 좌표
사용자 개인 화면: 공원/장소명 또는 동/구 수준
공유 화면: 시/구 수준 또는 위치 숨김
```

### 4.4 위험 장소 처리

아래 위치는 지도 공개 또는 공유에서 숨긴다.

- 집
- 학교
- 학원
- 병원
- 아동이 자주 머무는 사적 장소
- 인구가 적어 특정 가능성이 높은 장소

MVP 기준 구현:

1. 위치를 공개 공유하지 않는다.
2. 개인 화면에서도 정확 좌표 대신 장소명/행정동 수준으로 표시한다.
3. 보호자 모드에서 정확 위치 표시 여부를 제어한다.

---

## 5. 사진 업로드·이미지 처리 정책

사진은 민감한 정보가 섞일 수 있으므로 별도 파이프라인을 둔다.

### 5.1 원본과 AI 전송본 분리

```text
원본 이미지
→ 사용자 기록 보존용
→ Object Storage 저장
→ 접근 권한 제한

AI 입력 이미지
→ 리사이즈
→ 압축
→ EXIF 제거
→ 얼굴/민감정보 감지 후 전송 여부 결정
```

### 5.2 EXIF/GPS 처리

- AI 전송용 이미지는 EXIF를 제거한다.
- 위치정보는 이미지 파일에 포함하지 않고 별도 필드로 저장한다.
- 원본 이미지의 EXIF 보존 여부는 보호자/사용자에게 고지한다.
- 가능하면 원본 저장 시에도 GPS EXIF를 제거하고, 위치정보는 DB에 별도 저장한다.

### 5.3 얼굴·사람 감지

사진에 사람 얼굴이 포함될 수 있다.

MVP 권장 정책:

```text
사람/얼굴 감지
→ 사용자에게 경고
→ 자연물/사물만 보이게 다시 찍도록 안내
→ 보호자 모드 또는 명시적 확인 없이 AI 분석 진행 금지
```

문구 예시:

```text
사진에 사람이 보이는 것 같아요.
개인정보 보호를 위해 자연물만 보이게 다시 찍어주세요.
```

### 5.4 민감 정보 감지

아래 항목이 감지되면 경고 또는 차단한다.

- 사람 얼굴
- 자동차 번호판
- 집 내부
- 학교 이름/학원 이름
- 주소/우편물/명찰
- 병원/진료 정보
- 신분증/문서

---

## 6. AI 분석 정책

Little Quest는 사진을 AI로 분석해 카드와 백과사전 설명을 만든다. AI 결과는 틀릴 수 있으므로 고지와 검증 정책이 필요하다.

### 6.1 AI 고지

카드 상세 또는 분석 결과 화면에 다음 문구를 둔다.

```text
AI가 사진을 분석해 만든 교육용 정보예요.
중요한 정보는 보호자와 함께 확인해 주세요.
```

### 6.2 위험 행동 유도 금지

AI 생성 문구에서 다음 표현을 금지한다.

- 먹어보세요
- 만져보세요
- 잡아보세요
- 가까이 다가가세요
- 집에 가져가세요
- 혼자 확인해보세요

권장 표현:

- 멀리서 관찰해요
- 만지지 않고 사진으로 기록해요
- 모르는 식물은 보호자와 함께 확인해요
- 위험해 보이면 가까이 가지 않아요

### 6.3 출처 기반 검증

카드 상세 정보 생성 시 가능한 출처 기반 검증을 수행한다.

출처 후보:

- Wikipedia/Wikidata
- GBIF
- iNaturalist
- 국가유산청/국가유산포털
- TourAPI
- 공공데이터포털
- 검증 가능한 백과사전/공공기관 자료

Claim 상태:

```text
confirmed
probable
uncertain
contradicted
insufficient
```

UI 반영:

- confirmed/probable: 일반 표시
- uncertain/insufficient: “확실하지 않아요” 표시
- contradicted: 카드 생성 보류 또는 보호자 확인 필요

### 6.4 AI 외부 처리 동의

AI 분석에 외부 API를 사용한다면 다음을 고지한다.

- 어떤 목적으로 전송하는지
- 어떤 데이터가 전송되는지
- 원본이 아닌 압축/메타데이터 제거 이미지가 전송되는지
- 분석 결과가 서비스 개선에 사용되는지
- 저장 기간
- 삭제 요청 방법

---

## 7. 보호자 모드

Little Quest는 아이 모드와 보호자 모드를 분리한다.

### 7.1 아이 모드

- 사진 촬영
- 카드 보기
- 퀘스트 참여
- 관찰 메모
- 쉬운 설명 보기

### 7.2 보호자 모드

- 아이 프로필 관리
- 개인정보 열람/수정
- 사진/카드 삭제
- 위치 기록 삭제
- 동의 내역 확인
- 동의 철회
- 계정 삭제
- 구독/결제 관리
- 공개/공유 기능 제어
- 알림/푸시 관리

### 7.3 보호자 게이트

보호자 모드 진입 전 보호자 확인을 한다.

가능한 방식:

- 보호자 비밀번호
- SNS 재인증
- 이메일 인증
- 생체 인증은 보조 수단으로만 사용

---

## 8. 데이터 삭제·동의 철회

사용자와 보호자가 언제든지 데이터를 삭제하거나 동의를 철회할 수 있어야 한다.

### 8.1 삭제 가능한 데이터

- 계정
- 아이 프로필
- 사진 원본
- AI 입력 이미지
- 카드
- 관찰 기록
- 위치 기록
- 지도 핀
- 메모
- 퀘스트 기록
- 좋아요/즐겨찾기
- 구독 관련 앱 내부 데이터

### 8.2 삭제 처리 정책

```text
삭제 요청
→ 즉시 비활성화/노출 중단
→ 백그라운드 삭제 작업 생성
→ Object Storage 이미지 삭제
→ DB 레코드 삭제 또는 익명화
→ 검색/캐시/분석 데이터 정리
→ 완료 로그 저장
```

### 8.3 동의 철회 시 처리

```text
위치정보 동의 철회
→ 이후 위치 저장 중지
→ 기존 위치 기록 삭제 여부 선택 제공

사진/AI 분석 동의 철회
→ 이후 AI 분석 중지
→ 기존 AI 입력 이미지 삭제 여부 선택 제공

마케팅 동의 철회
→ 마케팅/이벤트 알림 중지
```

---

## 9. 결제·구독·BM 정책

아이 화면에서 직접 결제를 유도하지 않는다.

### 9.1 결제 접근

```text
아이 모드
→ 업그레이드 직접 결제 금지
→ “부모님에게 요청하기”만 표시

보호자 모드
→ 플랜 비교
→ 결제
→ 해지/환불 안내
```

### 9.2 결제 상품

가능한 BM:

- 카드 생성 한도
- 지도 기록 슬롯
- 디지털 바인더
- 월간 탐험 리포트
- PDF 다운로드
- 실물 카드팩/포토북
- Family 플랜

### 9.3 환불·해지 안내

문서화할 항목:

- 월 구독 해지 시점
- 남은 기간 이용 가능 여부
- 사용량 기반 환불 정책
- 구매 크레딧 환불 정책
- PDF/실물 상품 환불 제한
- 다운그레이드 시 기존 카드/홀로/슬롯 처리

---

## 10. 광고·분석 SDK 정책

MVP에서는 광고 SDK를 사용하지 않는다.

### 10.1 금지

- 맞춤형 광고 SDK
- 행동 기반 광고
- 아동 타게팅 광고
- 불필요한 제3자 추적 SDK
- SNS 공유 추적 SDK
- 리타겟팅 SDK

### 10.2 제한적 허용

운영에 필요한 최소 분석/크래시 도구만 검토한다.

허용 전 확인:

- 수집 데이터
- 제3자 전송 여부
- 개인 식별 가능성
- 아동 데이터 처리 여부
- App Store / Google Play 정책
- 개인정보처리방침 반영 여부

---

## 11. App Store / Google Play 심사 준비

### 11.1 공통

- 개인정보처리방침 URL
- 위치정보 이용약관 또는 위치정보 처리 고지
- 앱 내 권한 요청 사유
- Data Safety / Privacy Nutrition Label 정확성
- 제3자 SDK 목록
- AI 외부 처리 고지
- 아동 대상 여부/연령 등급 정합성

### 11.2 Apple Kids Category 검토

Kids Category로 제출할 경우 특히 조심한다.

- 제3자 광고 금지 또는 매우 제한
- 제3자 분석 금지 또는 매우 제한
- 아동 개인정보 제3자 전송 제한
- 부모 게이트 필요
- 외부 링크/결제/상거래 흐름 주의

### 11.3 Google Play Families 정책 검토

Google Play에서도 가족/아동 대상 여부, 광고 SDK, 데이터 안전 섹션, 권한 사용 사유를 정합성 있게 작성해야 한다.

---

## 12. UI/UX에 반영할 필수 화면

MVP 기획에 다음 화면을 추가한다.

1. 생년월일 입력 화면
2. 만 14세 미만 안내 화면
3. 보호자 동의 요청 화면
4. 보호자 이메일/휴대폰 인증 화면
5. 보호자 동의 완료 화면
6. 개인정보 수집·이용 동의 화면
7. 위치정보 수집·이용 동의 화면
8. 사진/AI 분석 동의 화면
9. 아이용 쉬운 개인정보 안내 화면
10. 보호자 모드 진입 화면
11. 보호자 관리 대시보드
12. 위치 기록 삭제 화면
13. 사진/카드 삭제 화면
14. 계정 삭제 화면
15. AI 결과 주의 안내 컴포넌트
16. 위치 권한 거부 대체 안내 화면
17. 결제 부모 게이트 화면

---

## 13. API/백엔드 요구사항

### 13.1 재인증

민감정보 수정 전 계정 확인을 요구한다.

```text
이메일 가입자
→ 비밀번호 확인

SNS 가입자
→ SNS 재인증

이메일 + SNS 연결 사용자
→ 가능한 방식 중 선택
```

재인증 유효 시간:

```text
10분
```

민감 API는 서버에서 `reauthenticated_at`을 검증한다.

### 13.2 보호자 동의 API

필요 API:

```text
POST /api/guardian-consents/request
POST /api/guardian-consents/verify
GET  /api/guardian-consents/status
POST /api/guardian-consents/revoke
```

### 13.3 데이터 삭제 API

필요 API:

```text
POST /api/privacy/delete-account
POST /api/privacy/delete-profile
POST /api/privacy/delete-image
POST /api/privacy/delete-location-records
POST /api/privacy/revoke-consent
GET  /api/privacy/export
```

### 13.4 위치 권한 상태

```text
location_permission_status
location_consent_status
location_precision_mode
```

위치 표시 수준:

```text
exact
place
district
hidden
```

기본값:

```text
private: place
shared: hidden
```

---

## 14. 데이터 모델 추가 제안

### 14.1 guardian_consents

```sql
CREATE TABLE guardian_consents (
  id UUID PRIMARY KEY,
  child_user_id UUID NOT NULL,
  guardian_email TEXT,
  guardian_phone TEXT,
  status TEXT NOT NULL,
  consent_version TEXT NOT NULL,
  consented_at TIMESTAMPTZ,
  revoked_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 14.2 user_consents

```sql
CREATE TABLE user_consents (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  consent_type TEXT NOT NULL,
  consent_version TEXT NOT NULL,
  status TEXT NOT NULL,
  consented_at TIMESTAMPTZ,
  revoked_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 14.3 privacy_deletion_jobs

```sql
CREATE TABLE privacy_deletion_jobs (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  target_type TEXT NOT NULL,
  target_id UUID,
  status TEXT NOT NULL,
  requested_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  failure_reason TEXT
);
```

### 14.4 reauthentication_sessions

```sql
CREATE TABLE reauthentication_sessions (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  method TEXT NOT NULL,
  reauthenticated_at TIMESTAMPTZ NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

---

## 15. MVP 준수 체크리스트

### 반드시 구현

- [ ] 생년월일 기반 만 14세 미만 분기
- [ ] 보호자 동의 플로우
- [ ] 개인정보 수집·이용 동의 분리
- [ ] 사진/AI 분석 동의 분리
- [ ] 위치정보 동의 또는 기능 사용 시 위치 권한 안내
- [ ] AI 전송 이미지 리사이즈/압축/EXIF 제거
- [ ] 얼굴/사람 감지 시 경고 또는 차단
- [ ] 위치 권한 거부 시 카드 생성 가능
- [ ] 정확 위치 기본 비공개
- [ ] 계정/사진/위치/카드 삭제 기능
- [ ] 개인정보 수정 전 재인증
- [ ] 아이 화면 직접 결제 금지
- [ ] 광고 SDK 미사용
- [ ] AI 결과 주의 문구
- [ ] 위험 행동 유도 문구 금지

### 강력 추천

- [ ] 보호자 모드
- [ ] 아이용 쉬운 개인정보 안내
- [ ] 위치 흐림 처리 설정
- [ ] 데이터 내보내기
- [ ] 푸시 알림 동의 분리
- [ ] 제3자 SDK 목록 문서화
- [ ] App Store / Google Play 데이터 처리 항목 사전 정리

---

## 16. 문서 반영 대상

다음 기존 문서에 이 내용을 반영한다.

- PRD.md
- USER_FLOW.md
- MVP.md
- DATA_MODEL.md
- AI_PIPELINE.md
- IMAGE_PROCESSING_PIPELINE.md
- GPS_PRIVACY_POLICY.md
- BUSINESS_MODEL.md
- SYSTEM_PROMPTS.md
- TESTING_AND_BUGFIX_LOOP.md
- CODEX_GOAL.md

새 문서로 본 파일을 추가한다.

```text
docs/CHILD_SAFETY_AND_COMPLIANCE.md
```
