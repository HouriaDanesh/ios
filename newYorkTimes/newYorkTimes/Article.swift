
import Foundation

class Article{
    var headline = String()
    var leadParagraph = String()
    var media = [String]()
    var webURL = String()
    var section = String()
    
    
    
    
    var relatedURL = [RelatedUrl]()
    
    init(headline: String, leadParagraph: String, media: [String], webURL: String){
        self.headline = headline
        self.leadParagraph = leadParagraph
        self.media = media
        self.webURL = webURL
        
    }
    init(headline: String, leadParagraph: String, media: [String], webURL: String, section: String, relatedUrlList: [RelatedUrl]?){
        self.headline = headline
        self.leadParagraph = leadParagraph
        self.media = media
        self.webURL = webURL
        self.section = section
        if relatedUrlList != nil{
            self.relatedURL = relatedUrlList!
        }
        
        
    }
}

class RelatedUrl{
    var url = String()
    var url_text = String()
    
    init(url: String, url_txt: String){
        self.url = url
        self.url_text = url_txt
    }
    
}

class ArticleShort: NSObject, NSCoding{
    var headline: String
    var url: String
    
    init(headline: String, url: String){
        
        self.headline = headline
        self.url = url
    }
    
    required convenience init(coder decoder: NSCoder){
        let headline = decoder.decodeObjectForKey("headline") as! String
        let url = decoder.decodeObjectForKey("url") as! String
        
        self.init(headline: headline, url: url)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.headline, forKey: "headline")
        aCoder.encodeObject(self.url, forKey: "url")
    }
}
