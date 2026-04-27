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

