import scrapy
import time
import csv

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.keys import Keys 
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager


from brunchsite.items import BrunchsiteItem



class CrawlerSpider(scrapy.Spider):
    name = "crawler"
    allowed_domains = ["brunch.co.kr"]
    start_urls = ["https://brunch.co.kr"]

    def __init__(self):
        service = Service(ChromeDriverManager().install())
        options = Options()

        options.add_argument("--disable-dev-shm-usage")
        options.add_argument("--window-size=1920,1080")
        options.add_argument("--start-maximized")
        options.add_argument("--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36")
        options.add_argument("--lang=ko_KR")
        options.add_argument("--no-sandbox")

        self.driver = webdriver.Chrome(service=service, options=options)

    def parse(self, response):
        try :
            self.driver.get(response.url)
            time.sleep(2)

            elements = self.driver.find_elements(
                By.CSS_SELECTOR, "li.embla__slide.svelte-117s9qv strong.tit_subject") 

            for i, el in enumerate(elements, 1):
                item = BrunchsiteItem()
                item["rank"] = i
                item["title"] = el.text
                yield item

        except Exception as e :
            self.logger.error(f"크롤링 에러 발생 : {e}", exc_info=True)
        finally :
            self.driver.quit()
