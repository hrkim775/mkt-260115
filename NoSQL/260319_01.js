use nosql

show collections
db.users.find()

/*
MongoDB Aggregation Framework 문법
빅데이터는 병렬작업을 통해 시간 단축을 해야한다
이런 병렬작업에 효과적인 문법

해야할 작업을 미리 그룹화 해야하고 파이프라인이라는 이름을 사용해서 그룹화한 작업물들을 연결시켜야한다
-> python의 scrapy처럼!
*/