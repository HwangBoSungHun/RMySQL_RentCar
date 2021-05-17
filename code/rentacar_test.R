rm(list=ls())
source('rentacar.R')

############################################################
# rentacar.R에서 dbConnect()의 password 바꿔줘야함!!!!!!!!!#
############################################################

drivers <- as.data.frame(read_csv('drivers.csv'))  
rent <- as.data.frame(read_csv('rent.csv'))
rent_comp <- as.data.frame(read_csv('rent_comp.csv')) 
repair <-  as.data.frame(read_csv('repair.csv'))
repair_shop <-  as.data.frame(read_csv('repair_shop.csv'))
cars <-  as.data.frame(read_csv('cars.csv'))

# (1) 데이터 초기화 기능 ##########################################################################################
# init_sql(mydata_name, mydata): sql에 mydata의 insert하는 함수
init_sql('drivers', drivers)
init_sql('rent_comp', rent_comp)
init_sql('repair_shop', repair_shop)
init_sql('cars', cars)
init_sql('rent', rent)
init_sql('repair', repair)
###################################################################################################################

# (2) 데이터 출력 기능 ############################################################################################
# print_sql(mydata_name, col_name): mydata_name에 해당하는 릴레이션을 col_name의 오름차순으로 출력
print_sql('rent_comp', 'rent_comp_name') 
print_sql('drivers', 'dr_name')
print_sql('repair_shop', 'shop_name')
print_sql('rent', 'rent_start_date')
print_sql('repair', 'rep_date')
print_sql('cars', 'car_id')
###################################################################################################################

# (3) 특정 렌터카 정보를 삭제하는 기능 ############################################################################
# delete_car(렌터카의 등록 ID, 렌터카 업체 이름)
dbGetQuery(con, 'select * from cars;') # 삭제하기 전
delete_car(1, 'GoGo') # GoGo(rent_comp_id = 6) 소속의 차 중, car_id = 1인 차량 삭제
dbGetQuery(con, 'select * from cars;') # [cars]에서 car_id = 1인 차량이 삭제된 것을 확인할 수 있음
dbGetQuery(con, 'select * from rent') # [rent]에서 car_id = 1인 차량의 car_id와 rent_comp_id가 NA인 것을 확인할 수 있음
dbGetQuery(con, 'select * from repair') # [repair]에서 car_id = 1인 차량의 car_id와 rent_comp_id가 NA인 것을 확인할 수 있음
###################################################################################################################

# (4) 특정 고객의 정보를 수정하는 기능 ############################################################################
# modify_driver(운전면허번호, col_name, value): 운전면허번호에 해당하는 row의 col_name의 값을 value로 수정. 
dbGetQuery(con, 'select * from drivers where driver_license = \'12-10-239956-23\';') # 바뀌기 전
modify_driver('12-10-239956-23', 'dr_email', 'hong!!!@gmail.com')
dbGetQuery(con, 'select * from drivers where driver_license = \'12-10-239956-23\';') # 바뀐 후 
###################################################################################################################

# (5) 특정 정비업소의 정보를 추가하는 기능  #######################################################################
# add_repair_shop(정비소ID, 정비소이름, 정비소주소, 정비소전화번호, 담당자이름, 담당자이메일)
dbGetQuery(con, 'select * from repair_shop') # 수정하기 전
add_repair_shop(8,'Koala', 'Song-am-ri Yangyang-eup Yangyang-gun Gangwon-do 223-1', '033-671-8275', 'Lee SK','kiki@naver.com') 
dbGetQuery(con, 'select * from repair_shop') # 'Koala'라는 정비업소의 정보가 추가된 것을 확인할 수 있다
# dbSendQuery(con, 'delete from repair_shop where shop_id = 8')
###################################################################################################################

# (6) 대여 기간 연장 가능 #########################################################################################
# lengthen_due(): 'Kang Juyoung 고객만 대여기간을 5일 연장. 기타청구내역 '기간연장', 기타청구요금 50000원
lengthen_due_result_query <- 'select * from rent 
                              where rent_id in (
select r.rent_id 
from rent r, drivers d 
where r.driver_license = d.driver_license 
and d.dr_name = \'Kang Juyoung\');'

dbGetQuery(con, lengthen_due_result_query) # 수정하기 전
lengthen_due('Kang Juyoung') # 'Kang Juyoung' 고객의 대여기간 5일 연장. 
dbGetQuery(con, lengthen_due_result_query) # 수정 후 대여기간이 연장된 것을 확인할 수 있다.
###################################################################################################################

# (7) 렌터카 대여 회사 삭제 기능 ##################################################################################
# delete_rent_comp(): 'Oreum'의 정보 삭제
dbGetQuery(con, 'select * from rent_comp;') # 'Oreum' 삭제 전
delete_rent_comp('Oreum')
dbGetQuery(con, 'select * from rent_comp;') # 'Oreum' 삭제 후 [rent_comp]에서 'Oreum' 정보 삭제
dbGetQuery(con, 'select * from cars;') # 'Oreum' 삭제 후 [cars]에서 '오름렌터카' 소속의 차량 정보 삭제
dbGetQuery(con, 'select * from rent;') # 'Oreum' 삭제 후 [rent]에서 car_id('Oreum' 소속의 차량)와 rent_comp_id('Oreum') NA로 변경 
dbGetQuery(con, 'select * from repair;') # 'Oreum' 삭제 후 [repair]에서 car_id('Oreum' 소속의 차량)와 rent_comp_id('Oreum') NA로 변경 
###################################################################################################################

# (8) 특정 기간의 렌터카 내역 출력 가능 ###########################################################################
# print_drivers_november(): 2018년 11월 렌터카를 대여한 모든 고객의 이름과 주소, 전화번호 출력(여러 번 렌트 했더라도 한 번만 출력)
print_drivers_november()
###################################################################################################################

# (9) 주소에 따른 정비소 출력 기능 ################################################################################
# print_repair_shop(도시명): 해당 도시에 위치한 렌터카 정비소의 모든 정보 출력
dbGetQuery(con, 'select * from repair_shop;') # 전체 repair_shop 목록
print_repair_shop('Seoul') # Seoul에 위치한 repair_shop
print_repair_shop('Gyeonggi') # Gyeonggi에 위치한 repair_shop
print_repair_shop('Seocho') # Seocho에 위치한 repair_shop
###################################################################################################################

# (10) 특정 렌터카 출력 기능 ######################################################################################
# print_cars_2010_5people(): 렌터카 승차 인원이 5명 이상이고 렌터카 등록일자가 2010년식인 렌터카의 렌터카 번호, 이름, 대여 가격 출력
print_cars_2010_5people()
###################################################################################################################

# (11) 렌터카 대여 내역 통계 기능 #################################################################################
# november_top3(): 2018년 11월에 렌트를 가장 많이 한 고객 top3의 대여 횟수, 바차트(고객 이름 별 대여 횟수)
november_top3()
###################################################################################################################
