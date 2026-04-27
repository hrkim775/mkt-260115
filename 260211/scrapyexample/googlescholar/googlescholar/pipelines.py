from itemadapter import ItemAdapter
from scrapy.exceptions import DropItem


class GooglescholarPipeline:
    def process_item(self, item, spider):
        a = ItemAdapter()

        title = (a.get("title")).strip()
        query = (a.get("query")).strip()
        rank = (a.get("rank"))

        if not title :
            raise DropItem("Missing title")

        a["title"] = title
        a["query"] = query
        a["rank"] = rank
        
        return item
