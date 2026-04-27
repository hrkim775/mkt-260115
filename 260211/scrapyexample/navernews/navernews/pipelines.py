from urllib.parse import urlencode
from itemadapter import ItemAdapter
from scrapy.exceptions import DropItem

class CleanValidatePipeline:
    def process_item(self, item, spider):
        title = item.get("title", "").strip()
        url = item.get("url", "").strip()

        if not title:
            raise DropItem("Missing title")
        if not url:
            raise DropItem("Missing url")

        item["title"] = title
        item["url"] = url

        return item

# class CleanValidatePipeline:
#     def process_item(self, item, spider):
#         item["title"] = item["title"].strip()
#         item["url"] = item["url"].strip()

#         if not title :
#             raise DropItem("Missing title")
#         if not url :
#             raise DropItem("Missing url")

#         a["title"] = title
#         a["url"] = url

#         return item
