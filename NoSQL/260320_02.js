// 각 영화의 제목과 해당 영화에 달린 댓글을 조회해서 출력해주세요
db.movies.find().limit(10)
db.comments.find().limit(10)

db.movies.aggregate([
    {
        $lookup : {
            from: "comments",
            localField: "_id",
            foreignField: "movie_id",
            as: "movie_comments"
        }
    },
    {
        $project: {
            _id: 0,
            title: 1,
            movie_comments: 1
        }
    },
    {$match: {movie_comments: {$ne: []}}}
])

db.movies.aggregate([
    {$sort: {"year": 1, "imdb.rating": -1}},
    {$group: {
        _id: "$year", 
        title: {$first: "$title"},
        topRating: {$first: "$imdb.rating"}
        }
    },
    {$project: {_id: 0, year: "$_id", title: "$title", topRating: "$topRating"}},
    {$sort: {year: 1}}
])



// 장르별 영화 갯수 조회, 출력
db.movies.aggregate ([
    {$unwind: "$genres"},
    {$group: {_id: "$genres", count: {$sum: 1}}},
    {$sort: {count: -1}},
    {$project: {_id: 0, genres: "$_id", movieCount: "$count"}}
])



// 장르별 평균 러닝타임이 가장 긴 장르와 그 장르의 평균 러닝타임 출력하기

db.movies.find().limit(10)
db.movies.aggregate([
    {$unwind: "$genres"},
    {$group: {_id: "$genres", avgRuntime: {$avg: "$runtime"}}},
    {$sort: {avgRuntime: -1}},
    {$limit: 1},
    {$project: {_id: 0, genres: "$_id", avgRuntime: "$avgRuntime"}}
])


// 각 영화의 제목과 해당 영화에 댓글을 남긴 사용자들을 조회해서 같이 출력해주세요
db.movies.find().limit(10)
db.comments.find().limit(10)

db.movies.aggregate([
    {
        $lookup : {
            from: "comments",
            localField: "_id",
            foreignField: "movie_id",
            as: "movie_comments"
        }
    },
    {$match: {movie_comments: {$ne: []}}},
    {$project: {_id: 0, title: 1,  user: "$movie_comments.name"}}
])

use test
db.users.find()
