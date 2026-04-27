from itemadapter import ItemAdapter
from scrapy.exceptions import DropItem
from ssgmisson.items import SsgmissonItem


class SsgmissonPipeline:
    def process_item(self, item, spider):
        a = SsgmissonItem()

        title = (a.get("title")).sprip()
        discount = (a.get("discount"))
        price = (a.get("price"))
        url = (a.get("url")).sprip()

        if not title : 
            raise DropItem("Missing title")

        return item
