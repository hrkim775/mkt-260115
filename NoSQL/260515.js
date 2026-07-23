use data_lab

db.brands.insertMany([
    {brand_name: "Nike", category: "sports", sales: 120000},
    {brand_name: "Adidass", category: "sports", sales: 90000},
    {brand_name: "Musinsa", category: "fashion", sales: 150000},
])

db.brands.find()