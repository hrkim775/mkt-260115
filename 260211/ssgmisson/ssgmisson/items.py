import scrapy


class SsgmissonItem(scrapy.Item):
    title = scrapy.Field()
    discount = scrapy.Field()
    price = scrapy.Field()
    url = scrapy.Field()
