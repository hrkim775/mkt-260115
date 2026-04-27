use  sample_mflix

show collections
/*
해당 데이터는 다양한 영화 관련 정보가 포함되어있는 DB
5개의 컬렉션으로 구성되어있다
*/

db.movies.find().limit(3)
/*
_id : 영화의 고유 식별 id
plot : 영화 줄거리 (요약)
genres : 영화 장르 (배열의 형태)
runtime : 영화 상영 시간 (분)
cast : 영화 출연 배우 (배열의 형태)
num_mflix_comments : 영화 댓글 갯수
title : 영화 제목
fullplot : 영화 줄거리 (풀버전)
countries : 어떤 나라에서 제작한 영화
directors : 영화 감독
rated : 영화 관람 등급
awards : 수상 실적
lastupdated : 가장 최근 업데이트가 된 날짜
year : 개봉연도
imdb : 영화별 평점, 투표수, 고유 id
type : 매체 타입 (영화, 드라마)
tomatoes : 
poster : 경로
languages : 영화의 언어 
writers : 작가
*/



/*
라이브러리와 프레임워크
- 라이브러리, 프레임워크 모두 원본 대상이 있다 (참조하는 오리지널 개체가 존재)
- 오리지널 개체를 기반으로 무언가를 만든다

A -> 라이브러리
-오리지널 개체 의존성 기반
1+1=2 이런식으로 있던 것을 활용해서 자신들의 문법을 만든다

A -> 프레임워크
-오리지널 개체를 참조한다
2*1=2 오리지널 개체에 사용할 수 있는 독창적인 문법체계를 만든다
오리지널 안에서 사용할 수 있는 형태이긴 하나, 새로운 문법

예) 배열안에 값을 추가하는 push() -> $push 이렇게 만듬

단점)
처음 학습할때 프레임워크만의 문법 특징, 알고리즘을 익히는데 어렵다

장점)
문법 체계를 이해하면 편해진다
*/

db.movise.find(
    {year:1995}
)


/*
$match : 특정 조건에 해당되는 값을 조회하려고 할 때 사용
$group : 특정 값을 기준으로 요소들을 그룹화하고자 할 때 사용
$project : 특정 그룹요소의 값을 수정, 업데이트 하고자 할 때 사용
$sum : 특정 그룹요소들의 전체 합계를 구하고자 할 때 사용
$avg : 특정 그룹요소들의 전체 평균을 구하고자 할 때 사용
$push : 찾아오려고 하는 값들을 취합해서 하나의 배열 안에 값을 추가하는 역할
*/


// $match : 특정 조건에 해당되는 값을 조회하려고 할 때 사용
db.movise.aggregate([
    {$match: {year:1995}}
    ])
    
// {}는 하나의 파이프라인이다
// $만 아무런 기능이 없어서 연산자로 사용할 수 있다


db.comments.find()


// $group : 특정 값을 기준으로 요소들을 그룹화하고자 할 때 사용
db.comments.aggregate([
    {
        $group: {
            _id: "$movie_id",
            commentCount: { $sum: 1 }
        }
    },
    {
        $project: {
            year: "$_id",
            commentCount: 1,
            _id: 0
        }
    }
])

db.movies.aggregate([
    {
        $group: {
            _id: "$year",
            runtime: {$avg: "$runtime"}
        }
    }
    ])
    
    db.movies.aggregate([
        {
            $group: {
                _id: "$year",
                sumruntime: {$sum: 1}
            }
        }
 ])
 
 /*
 random : 위에서 작성한 코드 구문과 무관하게 랜덤값으로 나온다
 정렬이 되지 않으면 랜덤하게 값이 나옴
 */
 
 db.movies.find().limit(10)
 // sample_mflix-movise-imdb-[rating, votes, id]
 // 일반적인 객체지향 프로그래밍 언어 -> 부모 + 자식요소를 표시할때 온점을 쓴다
 // $imdb.rating
 
 
 // 연도별 평균 평점
 db.movies.aggregate([
     {
         $group: {
             _id: "$year",
             avergeRating: {$avg: "$imdb.rating"}
         }
     }
 ])
 
 db.movies.aggregate([
     {
        $group: {
        _id: "$year",
        minRating : {$min: "$imdb.rating"},
        maxRating : {$max: "$imdb.rating"} 
     }
     }
 ])
 
 
 // $push : 찾아오려고 하는 값들을 취합해서 하나의 배열 안에 값을 추가하는 역할
 db.movies.aggregate([
     {
         $group: {
             _id: "$year",
             titles: {$push: "$title"}
         }
     }
 ])
 
 // $addToSet : 중복 값을 혀용하지 않는 연산자
  db.movies.aggregate([
      {
          $group: {
              _id: "$year",
              genres: {$addToSet: "$genres"}
          }
      }
  ])
  
db.movies.find().limit(10)
  
 // $sort : 오름(1 = ASC) 및 내림차순(-1 = DESC) 정렬 
 // $sort의 삽입 순서는 공식처럼 정해져있는 것이 아니라, 파이프라인을 생성하는 연산자의 조합에 따라 복수 사용이 가능하며, 삽입순서로 유연하게 변경될 수 있다
 // $first : 0~9a~z : 순서 중 첫번째를 찾을 때 사용
 // $last : 0~9a~z : 순서 중 마지막번째를 찾을 때 사용
db.movies.aggregate ([
    {
        $sort:{"year": 1, "title": 1}
    },
    {
        $group: {
            _id: "$year",
            firstMovie : {$first: "$title"}, // 숫자가 있으면 숫자가 제일 먼저 나온다 그 후온 알파벳 순서
            lastMovie : {$last: "$title"}
        }
    },
        {
        $sort:{"_id": 1}
    }
])

// $avg : 평균값을 구하는 연산자
// $strLenCP : 문자열의 길이를 구하는 연산자
// $$toString : 문자열로 형변환을 시켜주는 연산자
db.movies.aggregate ([
    {
        $group: {
            _id: "$year",
            avgTitleLength: {$avg:{$strLenCP: {$toString:"$title"}}}
        }
    },
    {
        $sort: {_id: 1}
    }
])


// $gte : greater than equal : ~이상
//$count : 특정 조건 및 그룹화된 요소들의 전체 갯수를 집계할 수 있도록 해주는 연산자
db.movies.aggregate([
    {
        $match: {year:{$gte:2000}}
    },
    {
        $count: "movies_since_2000"
    }
])

// $limit : 출력해서 보고자하는 값의 제한설정을 하려고 할 때 사용
db.movies.aggregate([
    {
        $sort: {"year": 1, "title": 1}
    },
    {
        $limit: 5
    }
])


// $unwind : 특정 배열의 값을 개별적으로 풀어서 확인하고자 할 때 => unnest 기능이라고 부른다
db.movies.aggregate([
    {
        $unwind: "$genres"
    },
    {
        $limit: 5
    }
])


db.movies.aggregate([
    {
       $match: {"imdb.rating": {$ne:""}} 
    },
    {
        $sort: {"imdb.rating": -1}
    },
    {
        $limit: 3
    }
])

// 2000년 이후로 개봉된 영화의 수는 몇인지 조회 및 값 출력

db.movies.aggregate ([
    {
        $match: {year: {$gte: 2000}}
    },
    {
        $count: "movies_count"
    }
])

// 각 연도별로 개봉된 영화 수는 몇인지 조회 및 값 출력
db.movies.aggregate([
    {$group: {_id: "$year", count: {$sum: 1}}},
    {$sort: {count: -1}}
])


// 가장 많은 영화가 출시된 연도 조회 및 값 출력
db.movies.aggregate([
    {$group: {_id: "$year", count: {$sum: 1}}},
    {$sort: {count: -1}},
    {$limit: 1}
])


// 각 연도별 평균 영화 러닝타임을 조회 및 출력
db.movies.aggregate([
    {$group: {_id: "$year", avgRruntime: {$avg: "$runtime"}}},
    {$sort: {avgRruntime: -1}}
])


// 평균 러닝타임이 가장 긴 연도 조회 및 출력
db.movies.aggregate([
    {$group: {_id: "$year", avgRruntime: {$avg: "$runtime"}}},
    {$sort: {avgRruntime: -1}},
    {$limit: 1}
])

db.movies.find()

// 러닝타임이 가장 긴 영화를 찾아라

// 각 연도별 평균 영화 러닝타임을 조회 및 출력
db.movies.aggregate([
    {$sort: {runtime: -1}},
    {$limit: 1}
])


db.movies.aggregate([
    {$group: {_id: null, maxRuntime: {$max: "$runtime"}}}
])


// 각 영화장르별 평균 평점을 조회, 출력
db.movies.aggregate([
    {$unwind: "$genres"},
    {$group: {_id: "$genres", avg_rating: {$avg: "$imdb.rating"}}},
    {$sort: {avgRaing: -1}}
])


// 각 연도별 가장 먼저 출시된 영화의 제목

db.movies.find().limit(3)

db.movies.aggregate ([
    {$sort: {"year": 1, "released": 1}},
    {$group: {_id: "$year", firstMovie: {$first: "$title"}}}, // 그룹에 대한 정렬을 하고 싶으면 출력을 위한 정렬을 다시 해줘야한다
    {$sort: {_id: 1}}
])


db.movies.aggregate([
    {$unwind: "$genres"},
    {$group: {_id: "$year", uniqueGenres: {$addToSet: "$genres"}}},
    {$sort: {_id: 1}}
])