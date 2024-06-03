// DB 데이터
- DB 데이터 폴더 참고
- 오라클 사용


// 프로젝트 실행 전 경로 설정 필요
- 각각의 파일을 열어 경로 설정 코드 수정 필요

1. src/main/java/com/ezen/haha/mypage/MypageController.java
- pythonScriptPath(product_visual.py 실행 파일 경로)


2. src/main/java/com/ezen/haha/product/ProductController.java
- imagepath(이미지 저장 경로)
- pythonScriptPath(product_visual.py 실행 파일 경로)


3. src/main/java/com/ezen/haha/qna/QnaController.java
- imagepath(이미지 저장 경로)


4. src/main/webapp/resources/python/product_visual.py
- oracledb.init_oracle_client(오라클 인스턴트 클라이언트 경로)
- relative_image_dir(시각화 이미지 저장 경로)