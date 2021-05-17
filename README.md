# RMySQL_RentCar
'데이터베이스 원리 및 응용' 수업의 프로젝트(2018.11.26 ~ 2018.12.19)  
## 1. 파일 설명  
### (1) csv 파일    
- cars.csv: 자동차에 대한 정보
- drivers.csv: 렌터카를 이용한 사람에 대한 정보
- rent_comp.csv: 렌터카 업체에 관한 정보
- rent.csv: 렌트에 관한 정보
- repair_shop.csv: 정비소 업체에 관한 정보
- repair.csv: 수리에 관한 정보

### (2) sql 파일
- hbsh_2014002542.sql: MySQL 에서 사용할 테이블 정의

### (3) R 파일
- rentacar.R: 필요한 함수 정의
- rentacar_test.R: rentacar.R 에서 정의한 함수들이 제대로 동작하는지 확인하기 위해 테스트한 파일 (혹시 함수의 실행 방법과 같은 구체적인 동작이 궁금하실 때 보시면 좋을 거 같습니다)

## 2. 코드 설명
### [1] 데이터 초기화 기능
~~~R
# init_sql(mydata_name, mydata): sql에 mydata를 insert하는 함수
init_sql <- function (mydata_name, mydata){
  name <- names(mydata) # mydata의 열들의 이름을 저장
  name_length <- length(name) # 열 수 저장
  # "INSERT INTO rent (drid, cid, rentdate) VALUES(22, 106, '2018-02-11');“와 같은 query를 만드는 과정
  query1 <- paste('insert into', mydata_name, '(') # query1에서는 "INSERT INTO rent ("까지의 문자열
  
  for (i in 1:(name_length - 1)){
    query1 <- paste0(query1, name[i], sep = ',')
  }
  query1 <- paste0(query1, name[name_length], ') values(')
  
  for (j in 1:nrow(mydata)){
    query2 <- query1 
    for (k in 1:(name_length - 1)){
      # 변수형이 숫자일 때는 그대로 입력하고 문자형일 때는 따옴표로 감싸야한다.
      if (is.numeric(mydata[,k])){
        query2 <- paste0(query2, mydata[j,k], sep = ',')
      }
      else{
        query2 <- paste0(query2, '\'',mydata[j,k],'\',')
      }
    }
    if (is.numeric(mydata[,name_length])){
      query2 <- paste0(query2, mydata[j,name_length], ');')
    }
    else{
      query2 <- paste0(query2, '\'',mydata[j,name_length],'\');')
    }
    
    query2 <- gsub('\'NA\'', 'NA' ,query2)
    query2 <- gsub('NA', 'null' ,query2)
    # print(query2)
    rsInsert <- dbSendQuery(con, query2) # query를 sql에 보낸다.
  }
}
~~~
