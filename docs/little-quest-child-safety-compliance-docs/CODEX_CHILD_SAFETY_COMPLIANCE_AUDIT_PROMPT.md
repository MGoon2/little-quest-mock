# Codex Prompt — Little Quest 아동 안전·개인정보 준수 점검

아래 지시를 그대로 수행해라.

## 역할

너는 Little Quest 앱 저장소의 아동 안전, 개인정보, 위치정보, 사진/AI 처리, 결제/구독, 앱스토어 심사 준비 상태를 점검하는 코드/문서 감사자다.

## 목표

`docs/CHILD_SAFETY_AND_COMPLIANCE.md` 문서를 기준으로 현재 앱과 문서가 어디까지 준수되어 있는지 확인하고, 누락된 항목을 개발 가능한 작업 목록으로 정리하라.

## 절대 원칙

- 임의로 목데이터를 만들지 마라.
- 실제 구현이 없는데 있다고 판단하지 마라.
- 문서에만 있고 코드에 없으면 “문서만 있음”으로 표시하라.
- 코드에만 있고 문서에 없으면 “코드만 있음”으로 표시하라.
- 불확실하면 “확인 필요”로 표시하라.
- 법률 판단을 단정하지 말고 구현/문서 관점의 준수 준비 상태로 평가하라.
- 외부 API나 실제 인증 발송을 임의로 실행하지 마라.
- 기존 동작을 깨지 말고, 우선 분석 리포트와 작업 계획을 생성하라.

---

## 1. 먼저 읽을 문서

다음 문서가 있으면 모두 읽어라.

```text
docs/CHILD_SAFETY_AND_COMPLIANCE.md
docs/PRD.md
docs/MVP.md
docs/USER_FLOW.md
docs/DATA_MODEL.md
docs/AI_PIPELINE.md
docs/IMAGE_PROCESSING_PIPELINE.md
docs/GPS_PRIVACY_POLICY.md
docs/BUSINESS_MODEL.md
docs/SYSTEM_PROMPTS.md
docs/TESTING_AND_BUGFIX_LOOP.md
docs/CODEX_GOAL.md
```

없으면 없는 문서를 목록화하라.

---

## 2. 점검할 코드 영역

저장소 구조에 맞게 다음 영역을 찾아라.

```text
Flutter mobile app
Next.js web/admin
Backend API
Database schema/migrations
Auth module
Image upload/processing module
AI/LLM provider module
Map/location module
Payment/subscription module
Privacy/account deletion module
Terms/consent screens
```

경로가 다르면 실제 경로를 기록하라.

---

## 3. 준수 상태 분류

각 항목을 아래 상태 중 하나로 표시하라.

```text
COMPLIANT
PARTIAL
DOCUMENT_ONLY
CODE_ONLY
MISSING
NOT_APPLICABLE
NEEDS_REVIEW
```

정의:

```text
COMPLIANT
- 문서와 코드 모두 요구사항을 충족한다.

PARTIAL
- 일부만 구현되어 있다.

DOCUMENT_ONLY
- 문서에는 있으나 코드 구현이 없다.

CODE_ONLY
- 코드에는 있으나 문서화되어 있지 않다.

MISSING
- 문서와 코드 모두 없다.

NOT_APPLICABLE
- 현재 MVP 범위에서 적용 대상이 아니다. 단, 이유를 적어라.

NEEDS_REVIEW
- 법무/정책/스토어 심사 판단이 필요하거나 구현 의도가 불명확하다.
```

---

## 4. 반드시 점검할 항목

### 4.1 회원가입/연령/보호자 동의

점검 항목:

- 생년월일 입력이 있는가?
- 만 14세 미만 판단 로직이 있는가?
- 만 14세 미만이면 보호자 동의 플로우로 분기하는가?
- 보호자 동의 전 사진 업로드/AI 분석/위치 저장이 막히는가?
- 보호자 이메일 또는 휴대폰 인증 구조가 있는가?
- 보호자 동의 상태가 DB에 저장되는가?
- 보호자 동의 철회 기능이 있는가?

확인할 키워드:

```text
birth
birthday
birthDate
age
under14
guardian
parent
consent
legalRepresentative
minor
child
```

---

### 4.2 동의 항목

점검 항목:

- 서비스 이용약관 동의가 있는가?
- 개인정보 수집·이용 동의가 있는가?
- 사진/AI 분석 동의가 있는가?
- 위치정보 수집·이용 동의가 있는가?
- 마케팅/푸시 동의가 선택 동의로 분리되어 있는가?
- 동의 버전이 저장되는가?
- 동의 일시가 저장되는가?
- 동의 철회가 가능한가?

확인할 키워드:

```text
terms
privacy
policy
consent
agreement
locationConsent
aiConsent
photoConsent
marketingConsent
pushConsent
consentVersion
```

---

### 4.3 위치정보/GPS

점검 항목:

- 위치 권한 요청이 기능 사용 시점에 발생하는가?
- 위치 권한 거부 시 카드 생성이 가능한가?
- 위치 권한 거부 시 지도 핀/위치 퀘스트만 제한되는가?
- 정확 좌표가 기본 공개되지 않는가?
- 공유 화면에서 위치가 숨김 또는 시/구 수준으로 처리되는가?
- 위치 기록 삭제 기능이 있는가?
- 위험 장소 처리 정책이 구현되어 있는가?

확인할 키워드:

```text
location
gps
latitude
longitude
geohash
map
pin
permission
place
district
privacyLocation
```

---

### 4.4 사진 업로드/이미지 처리

점검 항목:

- 원본 이미지와 AI 전송용 이미지가 분리되는가?
- AI 전송 이미지는 리사이즈되는가?
- AI 전송 이미지는 압축되는가?
- EXIF가 제거되는가?
- GPS EXIF가 제거 또는 DB 분리 저장되는가?
- 얼굴/사람 감지 시 경고 또는 차단하는가?
- 자동차 번호판/문서/주소 등 민감정보 대응이 있는가?
- 이미지 삭제 시 Object Storage 파일도 삭제되는가?

확인할 키워드:

```text
image
upload
original
thumbnail
resize
compress
exif
metadata
face
person
blur
redact
objectStorage
R2
deleteImage
```

---

### 4.5 AI/LLM 분석

점검 항목:

- AI 분석 전 동의 상태를 확인하는가?
- 외부 AI API로 원본 이미지가 아닌 압축본만 전송하는가?
- AI 결과에 교육용 참고 고지가 있는가?
- 위험 행동 유도 문구를 금지하는 프롬프트가 있는가?
- 출처 기반 검증 파이프라인이 있는가?
- Claim 상태가 저장되는가?
- hallucination/uncertain/insufficient 처리 정책이 있는가?
- AI 실패 시 사용자 UX가 있는가?

확인할 키워드:

```text
llm
ai
vision
analysis
prompt
safety
claim
evidence
verified
hallucination
source
wikipedia
wikidata
gbif
inat
unsafe
```

---

### 4.6 보호자 모드

점검 항목:

- 보호자 모드 화면이 있는가?
- 보호자 모드 진입 전 보호자 확인이 있는가?
- 보호자가 아이 프로필을 관리할 수 있는가?
- 보호자가 사진/카드/위치 기록을 삭제할 수 있는가?
- 보호자가 동의를 철회할 수 있는가?
- 보호자가 결제/구독을 관리할 수 있는가?

확인할 키워드:

```text
guardian
parent
parentMode
guardianMode
family
childProfile
manageChild
parentGate
```

---

### 4.7 데이터 삭제/동의 철회

점검 항목:

- 계정 삭제 기능이 있는가?
- 아이 프로필 삭제 기능이 있는가?
- 사진 삭제 기능이 있는가?
- 위치 기록 삭제 기능이 있는가?
- 카드 삭제 기능이 있는가?
- 동의 철회 기능이 있는가?
- 삭제 작업이 Object Storage와 DB를 모두 처리하는가?
- 삭제 작업 로그/상태가 있는가?

확인할 키워드:

```text
delete
deletion
erase
withdraw
revoke
privacyRequest
deleteAccount
deleteProfile
deleteLocation
deleteCard
deletionJob
```

---

### 4.8 개인정보 수정 전 재인증

점검 항목:

- 개인정보 수정 전 계정 확인 화면이 있는가?
- 이메일 가입자는 비밀번호 확인을 요구하는가?
- SNS 가입자는 SNS 재인증을 요구하는가?
- 이메일+SNS 사용자는 확인 방법 선택이 가능한가?
- 재인증 유효 시간이 있는가?
- 민감정보 수정 API가 서버에서 재인증 시간을 검증하는가?

확인할 키워드:

```text
reauth
reauthentication
passwordVerify
accountVerification
socialVerification
reauthenticatedAt
sensitive
```

---

### 4.9 결제/구독

점검 항목:

- 아이 화면에서 직접 결제 버튼을 노출하지 않는가?
- 부모 모드에서만 결제/업그레이드가 가능한가?
- “부모님에게 요청하기” 플로우가 있는가?
- 구독 해지/환불/다운그레이드 정책 문서가 있는가?
- 기존 카드/홀로/슬롯의 다운그레이드 처리 정책이 있는가?

확인할 키워드:

```text
payment
subscription
billing
plan
plus
family
upgrade
purchase
refund
downgrade
parentRequest
```

---

### 4.10 광고/분석 SDK

점검 항목:

- 광고 SDK가 없는가?
- 아동 대상 맞춤형 광고가 없는가?
- 불필요한 제3자 추적 SDK가 없는가?
- 분석/크래시 SDK가 있다면 수집 데이터가 문서화되어 있는가?
- App Store/Google Play 개인정보 라벨에 반영할 목록이 있는가?

확인할 키워드:

```text
ad
ads
admob
firebase
analytics
crashlytics
tracking
sdk
thirdParty
privacyLabel
```

---

## 5. 산출물

아래 파일을 생성하라.

```text
docs/audit/CHILD_SAFETY_COMPLIANCE_AUDIT.md
docs/audit/CHILD_SAFETY_COMPLIANCE_TASKS.md
docs/audit/CHILD_SAFETY_COMPLIANCE_MATRIX.csv
```

### 5.1 CHILD_SAFETY_COMPLIANCE_AUDIT.md 형식

다음 구조로 작성하라.

```md
# Little Quest 아동 안전·개인정보 준수 감사 리포트

## 1. 요약

- 전체 상태:
- Critical 누락:
- High 누락:
- MVP 출시 전 반드시 해결할 항목:

## 2. 문서 존재 여부

| 문서 | 존재 여부 | 비고 |
|---|---:|---|

## 3. 코드 영역 탐색 결과

| 영역 | 경로 | 비고 |
|---|---|---|

## 4. 항목별 점검 결과

| 영역 | 항목 | 상태 | 근거 파일 | 설명 |
|---|---|---|---|---|

## 5. Critical 이슈

## 6. High 이슈

## 7. Medium 이슈

## 8. 법무/정책 검토 필요 항목

## 9. MVP 출시 전 권장 순서
```

### 5.2 CHILD_SAFETY_COMPLIANCE_TASKS.md 형식

```md
# Little Quest 아동 안전·개인정보 준수 작업 목록

## Phase 0 — 출시 차단 이슈

- [ ] 작업명
  - 상태:
  - 근거:
  - 구현 위치:
  - 완료 기준:

## Phase 1 — MVP 필수

## Phase 2 — 출시 안정화

## Phase 3 — Post-MVP
```

### 5.3 CSV 매트릭스 형식

컬럼:

```csv
area,item,status,doc_reference,code_reference,severity,recommended_action
```

severity 값:

```text
Critical
High
Medium
Low
Review
```

---

## 6. 우선순위 기준

Critical:

- 만 14세 미만 보호자 동의 없음
- 개인정보 수집·이용 동의 없음
- 위치정보 동의/권한/삭제 정책 없음
- 사진/AI 분석 동의 없음
- 계정 삭제/데이터 삭제 없음
- 민감정보 수정 전 재인증 없음
- 아이 대상 직접 결제 유도
- 광고/추적 SDK 사용

High:

- AI 고지 없음
- 사진 EXIF 제거 없음
- 원본과 AI 전송본 분리 없음
- 얼굴/사람 감지 대응 없음
- 보호자 모드 없음
- 위치 공개 수준 제어 없음

Medium:

- 아이용 쉬운 개인정보 안내 없음
- 데이터 내보내기 없음
- 푸시 동의 분리 없음
- App Store/Google Play 라벨 문서 없음

Low:

- 문구 개선
- UI 안내 강화
- 문서 중복 정리

Review:

- 법무 검토 필요
- 스토어 심사 검토 필요
- 기술 선택 미확정

---

## 7. 마지막 응답 형식

작업을 마친 뒤 사용자에게 다음만 보고하라.

```text
아동 안전·개인정보 준수 점검을 완료했습니다.

생성한 문서:
- docs/audit/CHILD_SAFETY_COMPLIANCE_AUDIT.md
- docs/audit/CHILD_SAFETY_COMPLIANCE_TASKS.md
- docs/audit/CHILD_SAFETY_COMPLIANCE_MATRIX.csv

요약:
- Critical: N건
- High: N건
- Medium: N건
- Review: N건

MVP 출시 전 가장 먼저 처리할 항목:
1. ...
2. ...
3. ...
```

코드를 임의로 수정하지 말고, 먼저 감사 문서만 생성하라.
