CREATE TABLE MEMBER (
    ID VARCHAR2(50) PRIMARY KEY,       -- 사용자 ID (기본 키)
    PWD VARCHAR2(100),        -- 비밀번호
    NAME VARCHAR2(100) NOT NULL,       -- 이름
    TEL VARCHAR2(150),                  -- 전화번호
    ADDRESS VARCHAR2(150),             -- 주소
    signupRoute VARCHAR2(150),  -- 가입 일자
    gender VARCHAR2(50),                    -- 성별 (예: M/F)
    kakaoid VARCHAR2(50),              -- 카카오 ID
    registration_date DATE,            -- 등록 일자
    mail VARCHAR2(100),                -- 이메일 주소
    birth DATE                         -- 생년월일
);
