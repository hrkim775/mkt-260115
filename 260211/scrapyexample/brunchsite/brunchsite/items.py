import scrapy


class BrunchsiteItem(scrapy.Item):
    rank = scrapy.Field()
    title = scrapy.Field()
