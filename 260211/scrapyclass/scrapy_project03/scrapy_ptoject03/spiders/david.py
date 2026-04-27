import scrapy
from scrapy import item
from scrapy_ptoject03.items import ScrapyPtoject03Item


class DavidSpider(scrapy.Spider):
    name = "david"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io"]

    def parse(self, response):
        categories = response.css("a.text-dark::text").getall()
        for category in categories :
            item = ScrapyPtoject03Item()
            item["category"] = category
            yield item
