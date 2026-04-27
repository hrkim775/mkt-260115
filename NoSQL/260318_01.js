use nosql02

show collections

db.users.find()

// 논리 연산 문법
// $and : AND 조건문
// $or : OR 조건문
// $not : NOT 조건 : 반드시 조건 하나를 부정하는 경우에만 사용가능!
// $not + $or = $nor : OR + NOT

db.users.find(
  {$and:[{address:"서울시"}, {age:25}]}
)

db.users.find(
  {address:"서울시", age:25}
)
// SELECT * FROM users WHERE address = "서울" AND age = 25;

db.users.find(
  {$or:[{address:"서울시"}, {age:45}]}
)

db.users.find(
  {age: {$eq:25}}
)

db.users.find(
  {age: {$not:{$eq:25} } }
)

db.users.find(
  {$not:[{address:"경기"}, {age:45}]}
)

db.users.find(
  {$nor: [{address: "경기도"}, {age:45}]}
)

// name이 Brown 이거나, age가 35인 데이터를 조회.출력

db.users.find(
  {$or: [{name: "Brown"}, {age: {$eq:35}}]}
)
// 단일 연산 구문안에서는 $eq 거의 무방하

db.users.find(
  {age: {$not:45}}
)

db.users.find(
  {age: {$not:{$eq:45}}}
)

db.users.find(
  {age: {$ne:45}}
)

// $eq = 동치, 동일함 의미하는 연산, 거의 대부분 생략하는 경우 많
// 정규표현식 = 특정 문자 내 원하는 문자열을 추출해서 가져오려고 할 때
// regular expression
// re

db.users.find()

db.users.find({name: "Da"})

// 정규표현
db.users.find({name: {$regex:/Da/}})
db.users.find({name: /^Da/})

db.users.find({name: {$regex:/^Da/}})
// 캐럿 => 일반패턴 ~으로 시작!! // [^] => not

// 정렬관련 문법
// SQL => ORDER BY ASC(default) | DESC

db.users.find(
  {address:"경기도"}
).sort({age:-1})
// 1은 오름차순정렬, -1은 내림차순정렬
// true, false => 0, 1

// 문서갯수 카운트
db.users.find().count()
// SELECT COUNT(*) FROM users;

// 실제 해당 컬럼 내 존재하는 값만 찾아오겠다. 결측치의 값을 배제
db.users.find(
  {address: {$exists:true}}
)

db.users.find(
  {address: {$exists:false}}
)

// 정석 문법
db.users.find(
  {address: {$exists:true}}
).count()

// 고전 문법
db.users.count(
  {address: {$exists:true}}
)

// 중복되는 값을 1번만 조회,출력
// SQL = DISTINCT
// 범주형 (남.녀, 10, 20, 30 등 그룹이 가능한 데이터) <-> 수치형 (1, 2, 3~)

db.users.find()
db.users.distinct("address")
db.users.distinct("address", {age: {$gte:30}})

// SELECT COUNT(DISTINCT address) FROM users;
db.users.distinct("address").length

// 전체데이터를 조회하기에 너무 부담되는 경우, 리미트 함수
// SELECT * FROM users LIMIT 10;
db.users.find().limit(2)

db.users.find()

db.users.insertMany([
  {name: "유진", age: 25, hobbies: ["독서", "영화", "요리"]},
  {name: "동현", age: 30, hobbies: ["축구", "음악", "영화"]},
  {name: "혜진", age: 35, hobbies: ["요리", "여행", "독서"]}
])

db.users.find()

// 단일값으로 구성된 경우 VS 배열형태를 띄고 있는 경우!
// $all => 모든 값이 존재하는 경우
// $in => 여러 값 가운데 일치하는 값 1개만이라도 존재한다면 찾아옴!
// $nin => 여러 값 중 어떤 값도 일치하지 않는 데이터를 찾아옴!
db.users.find({hobbies: {$all:["축구", "음악"]}})
db.users.find({hobbies: {$in:["축구", "요리"]}})
db.users.find({hobbies: {$nin:["축구", "요리"]}})

// C : db.createCollection("test")
// R : find, limit, count, dinstint, $eq, $lt...

db.users.find()

// 조건이 매칭되는 최초 데이터 1개만 변경
db.users.updateOne(
  {age: {$gt: 25}}, {$set: {address: "서울시"}}
)

// 조건이 매칭되는 모든 데이터를 변경
db.users.updateMany(
  {age: {$gt: 25}}, {$set: {address: "서울시"}}
)

db.users.find({address: "서울시"})

db.users.updateMany(
  {address: "서울시"}, {$inc: {age: 3}}
)

db.users.updateMany(
  {address: "서울시"}, {$inc: {age: -3}}
)

//age가 40보다 큰 데이터의 address를 "수원시"로 변경하기

db.users.updateMany(
  {age: {$gt: 40}}, {$set: {address: "수원시"}}
)

db.users.find(
  {address: "수원시"}
)

db.users.updateOne(
  {name: "유진"}, {$set: {age: 26}}
)

db.users.find({name: "유진"})

db.users.find({name: "동현2세"})

db.users.updateOne(
  {name: "동현"},
  {$set: {name: "동현2세", age: 31}}
)
// $unset : 특정 컬럼 제거
db.users.updateOne(
  {name: "유진"},
  {$unset: {age: 1}}
)

db.users.find()

// upsert : update + insert합성 기능 : 업데이트 대상을 먼저찾고, 없으면 추가
db.users.updateOne(
  {name: "민준"},
  {$set: {name: "민준", age: 22, hobbies:["음악", "여행"]}},
  {upsert:true}
)

db.users.find()

// updateOne | updateMany를 활용해서 기존 값을 수정.변경 가능 (unnesting)

db.users.updateOne(
  {name: "유진"},
  {$push: {hobbies: "운동"}}
)
// $set : overwrite (덮어쓰기) 기능
// $push : 기존 값에 추가하기 기능 (배열 > 값을 추가할 때)
// 반드시 추가하려고 하는 대상 배열의 형태 띄고있을 때에만 가능
db.users.find({name: "유진"})

db.users.updateOne(
  {name: "유진"},
  {$pull: {hobbies: "운동"}}
)

// C
// R
// U
// D

db.users.find()
db.users.deleteOne(
  {address: "서울시"}
)
db.users.deleteMany(
  {address: "서울시"}
)

db.users.drop()
db.users.deleteMany({})

db.users.find()

// 어떤 주제, 문제 발견, 해결 목표, 데이터 수집
// 패턴 및 규칙을 가지고 있는 형태의 데이터 : MySQL
// 일반적인 패턴과 규칙 x

// Python + MySQL
// Python + MongoDB 

use ecommerce

db.teddyproducts.find()








