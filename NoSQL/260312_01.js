// 단문주석 표시법 
/*복문주석 표시법*/


// 현재 나의 계정 속 데이터베이스 조회
show dbs

// 특정 데이터베이스 선택 및 사용
use datamkt
use admin

// 쿼리문 실행
// ctrl + enter 단문실행 | ctrl + shift + enter 복문실행

// 현재 데이터베이스 안에 컬렉션 조회하기
show collections

// 현재 데이터베이스 안에 특정 컬렉션 안에 데이터 찾기
// 객체지향 프로그래밍 언어의 경우, 부모루트 -> 자녀루트로 이동할때 (.)을 쓴다
db.test.find()


// 데이터베이스 상태정보 확인
db.stats()

// 데이터베이스 안에 컬렉션을 삭제
db.test.drop()

// 데이터베이스 자체를 삭제
db.dropDatabase()

// 계정 내 특정 데이터베이스 사용
use nosql

// 특정 데이터베이스 안에서 컬렉션 생성
db.createCollection("test")
// db.test.drop() = db.dropDatabase()


// 컬렉션에 조건을 주는 방법
// 사이즈의 단위는 : 1바이트 = 8비트 / 설정된 5242880(5메가 바이트)가 넘어가면 앞에서부터 데이터를 지운다
db.createCollection("log", {
    capped: true, size: 5242880, max: 5000
})


// 현재 컬렉션이 capped 옵션 설정이 되어있는지 조회
db.log.isCapped()
db.test.isCapped()


// 컬렉션 이름 변경
db.log.renameCollection("test02")



/*
MySQL과 다르게 스키마가 없어서 데이터를 넣을때 타입을 설정하는 것이 매우 중요하다

String : 문자열 = "David"
Interger : 정수 = 양의 정수, 음의 정수 = 32비트 / 64비트 = 4바이트, 8바이트
Boolean : 논리형 = true, false
Double : 부동소수점을 가지고 있는 데이터타입 = 4.5 / 0.34
Arrays : 배열(파이썬에서 리스트) = ["a", "b", "c"]
Object : 객체(파이썬에서 딕셔너리 / 이게 가장 중요하다) = {city: "seoul"}
Null : 비어있는 Null 값을 정의하기 위한 타입 = 결측치
ObjectId : 문서를 식별할 수 있도록 해주는 ID
Date : 날짜 데이터를 정의할 수 있는 타입
*/

// NoSQL 기반, CRUD : Create, Read, Update, Delete를 기준으로 학습한다

use nosql
db.createCollection("uesrs")


// 생성된 컬렉션에 값을 1개씩 입력할 때 사용
db.uesrs.insertOne(
    {subject: "mongodb", author: "david", views: 50}
)

// 입력된 값을 조회하는 방법
db.uesrs.find()


// 생성된 컬렉션에 여러개의 값을 동시에 삽입하고자 할 때
db.uesrs.insertMany(
    [
        {subject: "coffee", author: "dh", views: 51},
        {subject: "coffee shopping", author: "dk", views: 100},
        {subject: "baking", author: "skdhk", views: 5},
        {subject: "cake", author: "sjdml", views: 200},
        {subject: "cream", author: "dusruf", views: 130},
        {subject: "cafe in", author: "rhfl", views: 754},
        {subject: "cafe", author: "dnfl", views: 357},
        {subject: "coffees", author: "skfk", views: 9},
        {subject: "mongodb", author: "akstp", views: 5444},
        {subject: "baking", author: "rlaQkd", views: 8483},
        {subject: "cakeeeee", author: "rlazhd", views: 52}
        
    ]
)
    

db.uesrs.drop()


db.createCollection("users",{
    capped: true, size:5242880, max:5000
})

db.stats()

db.uesrs.insertMany(
    [
        {name:"kim", age:25, address:"서울"},
        {name:"lee", age:29, address:"중곡"},
        {name:"bbang", age:2, hobby: "뛰뛰", address:"구리"},
        {name:"kong", age:11, address:"딸기원"},
        {name:"bum", age:14}
    
    ]
)
// 최초에 스키마 설정시 not null을 설정했다면 이 값이 못 들어왔을테지만, nosql은 스키마가 없기 때문에 가능하다


db.uesrs.find()
// = SELECT * FROM users;

db.uesrs.find({}, {name: 1, address:1})
// SELECT name,  address FROM users;

db.uesrs.find({}, {name: 1, address:1, _id: 0})
// SELECT name,  address FROM users;
// 기본적으로 _id 값은 필수로 찾아오기 때문에 그 값을 빼고 싶으면 _id: 0를 써야한다

db.uesrs.find({address: "서울"})
// SELECT * FROM users WHERE adress = "서울";

db.uesrs.find({address: "서울"}, {name: 1, address:1, _id: 0})
// SELECT name,  address FROM users WHERE adress = "서울";

db.uesrs.find()
db.uesrs.find(
    {name: "lee"},
    {name: 1, age:1, address:1}
)




/*
$gt : 초과 >
$gte : 이상 >=
$lt : 미만 <
$lte : 이하 <=
$eq : 같음 =
$ne : 다름 !=, <>

$in : 또는
$or : 또는 |

*/


// 비교연산자를 활용한 조회
// 초과되는 값
db.uesrs.find(
    {age:{$gt: 25}}
)


// 미만인 값
db.uesrs.find(
    {age:{$lt: 25}}
)


// 논리연산자
// ,는 논리연산자로 and를 뜻한다
db.uesrs.find(
    {age:{$lt: 25, $lt: 14}}
)

db.uesrs.find(
    {age: {$gt: 2, $lte: 25}}
)
//  SELECT * FROM users WHERE age > 22 AND age <= 29;



db.uesrs.find(
    {age: {$in: [45, 50]}}
)
// SELECT * FROM users WHERE age IN (45, 50)



db.uesrs.find(
    {age: {$ne: 25}}
)
// SELECT * FROM users WHERE age <> 25



db.uesrs.find(
    {age: {$eq: 25, $eq: 29}}
)
// 25이면서 29인 숫자를 찾아오라고 했는데 그런 숫자는 존재하지 않음
// 그러나 이런 말도 안되는것도 에러를 내지 않고 마지막에 해당되는 것만 찾아와서 무엇이 에러인지조차 알기 어려울 때가있다


db.uesrs.find(
    {
        $or: [
            {age: {$eq: 25}},
            {age: {$eq: 29}}
        ]
    }
)




db.uesrs.find(
    {age: {$nin: 25}}
)

db.uesrs.find(
    {age: {$ne: 25}}
)
// SELECT * FROM users WHERE age NOT IN (25) 
// 두개 다 같은 값을 가지고 오지만, 첫번째 구문은 복수의 값으로 비교가 가능하고, 두번째 구문은 단일값만 비교한다



// age가 20보다 큰 name만 출력
db.uesrs.find(
    {age: {$gt: 20}},
    {name: 1}
)


// age가 2이고, address가 구리인 값의 name만 출력
db.uesrs.find(
    {age: 2, address: "구리"},
    {name: 1, _id: 0}
)

db.uesrs.find(
    {age: {$eq: 2}, address: "구리"},
    {name: 1, _id: 0}
)


//age가 25보다 작은 name과 age 출력
db.uesrs.find(
    {age: {$lt: 25}},
    {name: 1, age:1}
)

