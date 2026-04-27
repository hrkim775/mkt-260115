import scrapy


class MissonAladinItem(scrapy.Item):
   title = scrapy.Field() 
   writer = scrapy.Field() 
   publisher = scrapy.Field() 
   price = scrapy.Field() 
   point = scrapy.Field() 
   url = scrapy.Field() 
