import scrapy

class NavernewsItem(scrapy.Item):
    rank = scrapy.Field()
    query = scrapy.Field()
    title = scrapy.Field()
    url = scrapy.Field()