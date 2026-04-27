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

from ssgmisson.items import SsgmissonItem


class CrawlerSpider(scrapy.Spider):
    name = "crawler"
    allowed_domains = ["www.ssg.com"]
    start_urls = ["https://www.ssg.com"]

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

    def start_requests(self):
        url = "https://www.ssg.com"
        yield scrapy.Request(url, callback=self.parse)

    def parse(self, response):
        try :
            self.driver.get(response.url)
            time.sleep(2)

            shinsegaemall_tab = self.driver.find_element(By.XPATH, "//a[contains(@class, 'gnb_mall_link') and contains(text(), '신세계몰')]")
            shinsegaemall_tab.click()
            time.sleep(2)

            ssgspecial_tab = self.driver.find_element(By.XPATH, "//a[contains(@class, 'menu_lnk') and contains(text(), '쓱-특가')]") 
            ssgspecial_tab.click()
            time.sleep(2)

            food_button = self.driver.find_element(By.XPATH, "//button[@data-index='8']") 
            food_button.click()
            time.sleep(2)

        try : 
            a = card.find_element(By.CSS_SELECTOR, "a[href]")
            url = a.get_attribute("href")
        except :
            continue
            
        try : # 상품명 찾아오기
            name = card.find_element(By.CSS_SELECTOR, "p.chakra-text.css-19bfb2a").text.strip()
            name = clean_text(name)
        except :
            name = ""

        saleAndprice = card.find_element(By.CSS_SELECTOR, "div.chakra-stack.css-ffjhre")

        try : 
            discount = saleAndprice.find_element(By.CSS_SELECTOR, "em.css-aywnvu").text.strip()
            discount = clean_text(discount).replace("할인율", "").strip()
        except :
            discount = ""
        try : 
            price = saleAndprice.find_element(By.CSS_SELECTOR, "em.css-1oiygnj").text.strip()
            price = clean_text(price).replace("판매가격", "").strip()
        except :
            price = ""

        if url in seen_urls :
            continue








