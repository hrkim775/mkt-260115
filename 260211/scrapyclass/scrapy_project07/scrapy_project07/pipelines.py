from itemadapter import ItemAdapter


class LinkCompletionPipeline:
    def process_item(self, item, spider):
        base_url = "https://davelee-fun.github.io"

        if "link" in item :
            item["link"] = base_url + item["link"]
        else :
            item["link"] = ""
    
class Cleantitlepipeline :
    def process_item(self, item, spider) :
        if item["cartegory"] is None :
            item["cartegory"] = ""
        else :
            item["cartegory"] = item["cartegory"].replace(" 관련 상품 추천", "").strip()

        if item["title"] is None :
            item["title"] = ""
        else :
            item["title"] = item["title"].replace("상품명", "").strip()

        if item["name"] is None :
            item["name"] = ""
        else :
            item["name"] = item["name"].strip()

        if item["date"] is None :
            item["date"] = ""
        else :
            item["date"] = item["date"].strip()

        return item


