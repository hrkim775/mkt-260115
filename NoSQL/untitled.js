// 현재 나의 계정 속 데이터베이스 조회
show dbs

// 특정 데이터베이스 선택.사용
use datamkt
use admin

// 쿼리문 실행
// ctrl + enter | ctrl + shift + enter

// 현재 데이터베이스 안에 컬렉션 조회
show collections

// 현재 데이터베이스 안에 특정 컬렉션안에 데이터 찾기
// 객체지향 프로그래밍 언어의 경우, 부모루트 > 자녀루트로 이동 (.)
db.test.find()

// 데이터베이스 상태정보 확인
db.stats()

// 데이터베이스 안에 컬렉션을 삭제
db.test.drop()

// 데이터베이스 자체를 삭제
db.dropDatabase()

// 계정 내 특정 데이터베이스 사용
use nosql02

// 특정 데이터베이스 안에서 컬렉션 생성
db.createCollection("test")
// db.test.drop() = db.dropDatabase()

// size 단위 : 1바이트 = 8비트 / 1킬로 바이트(KB), 컴퓨터 2진수, 2^10 = 1024
db.createCollection("log", {
  capped: true, size: 5242880, max: 5000
})

// 데이터베이스 > 컬렉션 조회
show collections

// 현재 컬렉션이 capped 옵션설정 여부조회
db.log.isCapped()
db.test.isCapped()

// 컬렉션 이름 변경
db.log.renameCollection("test02")

/* 
String : 문자열 = "david"
Integer : 정수 = 양의정수, 음의정수 = 32비트 / 64비트 = 4바이트, 8바이
Boolean : 논리형 = true, false
Double : 부동소수점을 가지고 있는 데이터타입 = 4.5 3.8 0.34
Arrays : 배열 ["a", "b", "c"]
Object : 객체 {city: "Seoul"}
Null : 비어있는 Null 값을 정의하기 위한 타입 = 결측치 
ObjectId : 문서를 식별할 수 있도록해주는 ID
Date : 날짜 데이터를 정의할 수 있는 타입
*/

// NoSQL 기반, CRUD : Create, Read, Update, Delete

use nosql02
db.createCollection("users")

// 생성된 컬렉션에 값을 1개씩 입력하고자 할 때
db.users.insertOne(
  {subject: "mongodb", author: "david", views: 50}
)

// 입력된 값을 조회하고자 할 때
db.users.find()

// 생성된 컬렉션에 여러개의 값을 동시에 삽입하고자 할 때
db.users.insertMany(
  [
    {subject: "coffee", author: "xyz", views: 50},
    {subject: "Coffee Shopping", author: "efg", views: 100},
    {subject: "Baking a cake", author: "abc", views: 5},
    {subject: "baking", author: "def", views: 9},
    {subject: "Cafe Leche", author: "ziz", views: 200},
    {subject: "coffee and cream", author: "iop", views: 130},
    {subject: "Cafe in", author: "qwe", views: 80},
    {subject: "coffees", author: "ghj", views: 10}
  ]
)

db.users.find()

db.users.drop()

db.createCollection("users",{
  capped:true, size:5242880, max:5000
})

db.users.find()
db.stats()

db.users.insertMany(
  [
    {name:"David", age:25, address:"서울시"},
    {name:"Dave", age:45, address:"경기도"},
    {name:"Andy", age:50, hobby: "골프", address:"경기도"},
    {name:"Kate", age:35, address:"수원시"},
    {name:"Brown", age:6}
  ]
)

// 최초에 스키마 설정 시, name, age, address = not null
db.users.find()
// SELECT * FROM users;
db.users.find({}, {name: 1, address: 1})
// SELECT _id, name, address FROM users;
db.users.find({}, {name: 1, address: 1, _id: 0})
// SELECT name, address FROM users;
db.users.find({address: "서울시"})
// SELECT * FROM users WHERE address = "서울시"

db.users.find({address: "서울시"},{name: 1, address: 1, _id: 0})
// SELECT name, address FROM users WHERE address = "서울시"

db.users.find()
db.users.find(
  {name: "Dave"},
  {name: 1, age: 1, address: 1}
)

// 비교연산자를 활용한 조회
db.users.find(
  {age: {$gt: 25}}
)

db.users.find(
  {age: {$lt: 25}}
)

db.users.find(
  {age: {$lt: 25, $lte: 50}}
)

db.users.find(
  {age: {$gt: 25, $lte: 50}}
)
// SELECT * FROM users WHERE age > 25 AND age <= 50;
db.users.find(
  {age: {$in: [45, 50]}}
)
// SELECT * FROM users WHERE age IN (45, 50)
db.users.find(
  {age: {$ne: 35}}
)
// SELECT * FROM users WHERE age != 35
/*
$gt : 초과 >
$gte : 이상 >=
$lt : 미만 <
$lte : 이하 <=
$eq : 같음 =
$ne : 다름 != <>
*/

// , => 논리연산자 and


