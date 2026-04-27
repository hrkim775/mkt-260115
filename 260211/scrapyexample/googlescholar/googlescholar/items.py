import scrapy


class GooglescholarItem(scrapy.Item):
    query = scrapy.Field()
    rank = scrapy.Field()
    title = scrapy.Field()
