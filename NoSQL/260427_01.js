use wconcept_db_260423

show collections

db.blog_posts.find()

db.blog_posts.find(
    {},
    {
        _id: 0,
        brand_name: 1,
        title: 1,
        link: 1
    }
)

db.blog_posts.countDocuments() // 전체 문서 갯수 확인

db.blog_posts.find().limit(5)

db.blog_posts.find({
    brand_name: "아디다스"
})

db.blog_posts.find({
    title: /사랑/
})


db.blog_posts.find({
    description: /여름/
})

db.blog_posts.find({
    $or: [
        {title: /원피스/},
        {description: /여름/}
    ]
})


db.blog_posts.find({
    $or: [
        {title: /원피스/},
        {title: /여름/}
    ]
})


db.blog_posts.find({
        title: /원피스|여름/
})


db.blog_posts.find({
    brand_name: "휠라",
    title: /샌들/
})


db.blog_posts.find()


db.blog_posts.find({
    brand_name: {
        $in: ["모노로우", "레테라", "아디다스"]
    }
})


db.blog_posts.find({
    brand_name: {
        $ne: "우포스"
    }
})

db.blog_posts.find().sort({
    collected_at: -1 // 내림차순 정렬
})


db.blog_posts.find().sort({
    postdate: -1
})


db.blog_posts.find({
    postdate: {
        $gte: "20260423"
    }
})

db.blog_posts.findOne()


db.blog_posts.findOne({
    brand_name: "파사드패턴"
})


db.blog_posts.findOne({
    title: /여름/
})


// 매서드 체인기법
db.blog_posts.find().sort({postdate: -1}).limit(5)

db.blog_posts.find({
    brand_name: "아디다스"
})
.sort({postdate: -1})
.limit(5)


db.blog_posts.find({
    brand_name: "아디다스"
})
.sort({postdate: -1})
.skip(1)
.limit(3)


db.blog_posts.aggregate([
    {
        $group: {
            _id: "$brand_name", // $brand_name 각각의 행 안에 값을 센다
            blog_count: {$sum: 1}
        }
    },
    {
        $sort: {blog_count: -1}
    }
])

db.blog_posts.aggregate([
    {
        $match: {
            brand_name: "아디다스"
        }
    },
    {
        $group: {
            _id: "$brand_name",
            blog_count: {$sum: 1}
        }
    }
])


db.blog_posts.aggregate([
    {
        $match: {
            brand_name: {
                $in: [
                "아디다스",
                "파사드패턴",
                "레테라"
                ]
            }
        }
    },
    {
        $group: {
            _id: "$brand_name",
            blog_count: {$sum: 1}
        }
    }
])


db.blog_posts.aggregate([
    {
        $match: {
            title: /원피스/
        }
    },
    {
        $group: {
            _id: "$brand_name",
            summer_title_count: {$sum: 1} // 시즌 트렌드같은걸 파악하고자 할때
        }
    },
    {
        $sort: {summer_title_count: -1}
    }
])

db.blog_posts.aggregate([
    {
        $project: {
            _id: 0,
            brand: "$brand_name",
            blog_title: "$title",
            date: "$postdate"
        }
    },
    {
        $limit: 10
    }
])


db.blog_posts.aggregate([
    {
        $project: {
            _id: 0,
            brand_name: 1,
            title: 1,
            description_length: {$strLenCP: "$description"}
        }
    },
    {
        $sort: {description_length: -1}
    }
])


db.blog_posts.aggregate([
    {
        $match: {
            $or: [
                {title: /여름|무더위/},
                {description: /여름|무더위/}
            ]
        },
        {
            $project: {
                _id: 0,
                brand_name: 1,
                title: 1,
                description: 1,
                postdate: 1
            }
        }
    },
    {
        $limit: 10
    }
])





