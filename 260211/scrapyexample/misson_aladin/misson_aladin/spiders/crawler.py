import scrapy
from misson_aladin.items import MissonAladinItem


class CrawlerSpider(scrapy.Spider):
    name = "crawler"
    allowed_domains = ["aladin.co.kr"]
    start_urls = ["https://www.aladin.co.kr/shop/wbrowse.aspx?CID=336&start=we_header"]

    def parse(self, response):
        urls = self. start_urls