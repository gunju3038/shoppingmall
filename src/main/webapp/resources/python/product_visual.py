from matplotlib import pyplot as plt
from matplotlib.ticker import MaxNLocator

import numpy as np
import sys
import json
import os
import oracledb
import pandas as pd

#한글 지정
plt.rcParams['font.family'] ='Malgun Gothic'
plt.rcParams['axes.unicode_minus'] =False

#클라이언트 오라클
oracledb.init_oracle_client(lib_dir=r"C:\visual\python\oracle\instantclient_11_2")
connect = oracledb.connect(user='ezen', password='12345',dsn='localhost')
c=connect.cursor() #오라클 DB 쿼리문 c에 저장

# JSON 형식으로 데이터 읽기
data = sys.stdin.readline()
data_json = json.loads(data)

# 초기화
age_groups = {'10~19': 0, '20~29': 0, '30~39': 0, '40~49': 0, '50~59': 0, '60 이상': 0}

# 데이터 처리
ageList = data_json["ages"]
for age_str in ageList:
    age = int(age_str)
    # 나이에 따라 카운트 증가
    if age > 10 and age < 20:
        age_groups['10~19'] += 1
    elif age < 30:
        age_groups['20~29'] += 1
    elif age < 40:
        age_groups['30~39'] += 1
    elif age < 50:
        age_groups['40~49'] += 1
    elif age < 60:
        age_groups['50~59'] += 1
    else:
        age_groups['60 이상'] += 1

# 그래프 생성
age_ranges = list(age_groups.keys())
age_counts = list(age_groups.values())

index = np.arange(len(age_ranges))

plt.bar(index, age_counts)

# 색상 설정
colors = ['#ff9999', '#ffcc99', '#ffff99', '#ccff99', '#99ccff', '#c2c2f0']

# 그래프 생성
plt.bar(index, age_counts, color=colors[:len(age_counts)])

# y축 레이블을 정수로만 표시하도록 설정
plt.gca().yaxis.set_major_locator(MaxNLocator(integer=True))


# 축 및 제목 설정
plt.xlabel('나이 분포')
plt.ylabel('구입 인원 수 (명)')
plt.title('나이에 따른 구매량')
plt.xticks(index, age_ranges)

# 이미지 파일명 설정(상품번호(snum) 이름 뒤에 붙이기)
image_file = f"product_visual_{data_json['snum']}.png"

# 이미지 저장 경로 설정 (절대 경로)
relative_image_dir = "C:\\이젠디지탈12\\spring\\shoppingmall-master\\src\\main\\webapp\\resources\\python_image"
image_path = os.path.join(relative_image_dir, image_file)

# 디렉토리가 존재하지 않을 경우 생성
if not os.path.exists(relative_image_dir):
    os.makedirs(relative_image_dir, exist_ok=True)

# 이미지 파일이 이미 존재하는지 확인하고, 있다면 삭제
if os.path.exists(image_path):
    os.remove(image_path)
    
# 그래프를 이미지로 저장
plt.savefig(image_path)
plt.close()

# DB에 저장(update)
update_query = f"update visual set visual_image='{image_file}' where snum={data_json['snum']}"
c.execute(update_query)
connect.commit()
