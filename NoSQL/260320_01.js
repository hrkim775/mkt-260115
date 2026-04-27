use sample_mflix


// $project: 기존 데이터에서 필드명을 수정 및 변경하거나, 새로운 필드를 생성, 특정 필드만 취합해서 가져올 때 사용
// 반드시 기억해야할 것은 _id는 $project 연산자를 사용핳 때, 기본값으로 항상 따라다닌다

db.movies.aggregate ([
   {$project: {_id: 0, title: 1, year: 1}}, // 0은 특정 필드를 출력하지 않겠다는 뜻
   {$limit: 5}
])


// $concat: 특정 문자열 필드들을 연결해서 새로운 문자열을 생성할 때 사용
// $concat 뒤에는 []가 온다
db.movies.aggregate ([
    {
        $project: {_id: 0, titile: 1, year: 1, releasedIn: {$concat: ["$title", " (", {$toString:"$year"}, ")"]} // $concat은 문자열만 연결할수 있기 때문에 형변환해주는 것
        }
     },
    {$limit: 10},
    {$sort: {year: 1}}
])


// $lookup -> NoSQL기반의 JOIN의 느낌을 흉내낼 수 있다
// 서로 다른 컬렉션의 값을 연결시켜주는 기능
db.comments.find().limit(10) // movie_id
db.movies.find().limit(10) // _id



db.comments.aggregate([
    {
        $lookup: 
            {
                from: "movies", 
                localField: "movie_id",
                foreignField: "_id", 
                as: "movie"
             }
     }
])


db.users.find()
db.comments.find()

db.users.aggregate ([
    {
        $lookup: {
            from: "comments",
            localField: "email",
            foreignField: "email",
            as: "user_comments"
        }
    },
    {$match: {movie: {$ne: []}}}
])



// $limit(n) : 몇 개까지 데이터 문서를 보여줄것이냐
// $skip(n): 몇 개까지 건너뛴 상테로 데이터 문서를 보여줄  것인가

db.movies.aggregate([
    {$skip: 2},
    {$limit: 10},
    {$sort: {year: 1}}
])


db.movies.aggregate ([
    {$match: {runtime: {$gte: 100}}},
    {$sort: {runtime: -1}},
    {$skip: 2}
])


// $facet: 파이프라인의 진행과정을 최대한 비동기형태의 느낌으로 실행할 수 있도록 하기 위한 목적
// 복수의 상이한 업무를 병렬방식으로 진행하고자 할 때, 사용하는 문법
db.movies.aggregate([
    {$facet: {
        movieCountByYear: [
        {$group: {_id: "$year", count: {$sum: 1}}}
        ],
        maxRatingByYear: [
            {$group: {_id: "$year", maxRating: {$max: "$imdb.rating"}}}
        ]
    }}
])



// $redact: 데이터 문서상에서 어떤 조건 혹은 규칙에 따라 무언가를 실행
// 기존 연산자들은 $를 한번만 사용했는데 $$를 사용한 이유는 시스템변수이기 때문이다
// KEEP, PRUNE은 MongoDB가 기존에 가지고 있는 기본 문법 체계안에 있는 것이라 자체적으로 만든게 아니라 차용한것이기 때문에 그 것을 식별하기 위해 사용
db.movies.aggregate ([
    {
        $redact: {
            $cond: {
                if: {$gte: ["$imdb.rating", 7]},
                then: "$$KEEP",
                else: "$$PRUNE"
            }
        }
    }
])





