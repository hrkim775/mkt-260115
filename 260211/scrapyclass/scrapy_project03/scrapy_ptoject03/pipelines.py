# from nt import replace
# from time import process_time
# from itemadapter import ItemAdapter
# from scrapy.exceptions import DropItem


# class CleanCategoryPipeline :
#     def process_item(self, item, spider):
#         item["Category"] = item["Category"].strip()
#         return item

# class SetPipeline :
#     def __init__(self) :
#         self.categories_seen = set()

#     def process_item(self, item, spider) :
#         if item["Category"] in self.categories_seen :
#             raise DropItem("Duplicate item found: %s" % item)
#         else :
#             self.categories_seen.add(item["Category"])
#             return item 

# class RemovePhrasePipeline :
#     def process_item(self, item, spider) :
#         item["Category"] = item["Category"].replace(" 관련 상품 추천", "")
#         return item

from itemadapter import ItemAdapter
from scrapy.exceptions import DropItem

class CleanCategoryPipeline :
    def process_item(self, item, spider):
        item["category"] = item["category"].strip()
        return item

class SetPipeline :
    def __init__(self) :
        self.categories_seen = set()

    def process_item(self, item, spider) :
        if item["category"] in self.categories_seen :
            raise DropItem("Duplicate item found: %s" % item)
        else :
            self.categories_seen.add(item["category"])
            return item

class RemovePhrasePipeline :
    def process_item(self, item, spider) :
        item["category"] = item["category"].replace(" 관련 상품 추천", "")
        return item