
import scrapy, json

class DictionarySpider(scrapy.Spider):
    name = "dictionary_spider"
    start_urls = ['https://www.dictionary.com/e/word-of-the-day/']
    
    def parse(self, response):
        SET_SELECTOR = 'div[data-is-latest-post="true"] .otd-item-headword'
        
        for dictionary_set in response.css(SET_SELECTOR):
            
            # Word
            word_of_the_day = dictionary_set.css('.otd-item-headword__word h1 ::text').extract_first(),
            # Pro
            pronounciation = dictionary_set.css('.otd-item-headword__pronunciation div a.otd-item-headword__pronunciation-audio ::attr(href)').extract_first()
            # Type
            verb_adj_or_noun = dictionary_set.css('.otd-item-headword__pos-blocks span.luna-pos ::text').extract_first()
            # Def
            definition = dictionary_set.css('.otd-item-headword__pos-blocks p:nth-child(2) ::text').extract_first()

            return {
                'word_of_the_day': word_of_the_day[0] if len(word_of_the_day) > 0 else '',
                'pronounciation': pronounciation,
                'word_type': verb_adj_or_noun,
                'definition': definition,
            }
