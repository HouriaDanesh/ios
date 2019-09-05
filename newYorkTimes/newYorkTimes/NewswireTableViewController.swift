import UIKit

class NewswireTableViewController: UITableViewController {
    
    
    let indicator = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var dictionary = [String: [Article]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(65, 0.0, 0.0, 0.0)
        indicator.color = UIColor .blackColor()
        indicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        loadDataFromJSON()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func loadDataFromJSON() -> Void{
        
        indicator.startAnimating()
        
        
        let downloadSession = NSURLSessionConfiguration.defaultSessionConfiguration()
        let prefs = NSUserDefaults.standardUserDefaults()
        let apiKey = prefs.stringForKey(ArticleTableViewController.newswireApiKey)
        
        
        if apiKey != nil{
            let urlApi = NSURL(string: "http://api.nytimes.com/svc/news/v3/content/all/all.json?api-key=" + apiKey!)
            let userDataSession = NSURLSession(configuration: downloadSession, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
            
            let myDataTask = userDataSession.dataTaskWithURL(urlApi!){(data, response, error) -> Void in
                
                if error == nil{
                    
                    let userDataJSON = JSON(data: data!)["results"]
                    var tempArticleLis = [Article]()
                    for(_, tempObject) in userDataJSON{
                        let headline = tempObject[]["title"].stringValue
                        let paragraph = tempObject[]["abstract"].stringValue
                        let webUrl = tempObject[]["url"].stringValue
                        let section = tempObject["section"].stringValue
                        
                        var media = [String]()
                        let mediaLinkJSONArray = tempObject["multimedia"]
                      
                        for(_, mediaObject) in mediaLinkJSONArray{
                            if mediaObject["type"] == "image" {
                                
                                media.append(mediaObject["url"].stringValue)
                                
                        }
                            
                        }
                    
                        var relatedUrlList = [RelatedUrl]()
                        let relatedUrlListJSONArray = tempObject["related_urls"]
                        for(_, urlObject) in relatedUrlListJSONArray{
                            let url = urlObject["url"].stringValue
                            let text = urlObject["suggested_link_text"].stringValue
                            relatedUrlList.append(RelatedUrl(url: url, url_txt: text))
                        }
                        
                        
                        let tempArticle = Article(headline: headline, leadParagraph: paragraph, media: media, webURL: webUrl, section: section, relatedUrlList: relatedUrlList)
                        
                        tempArticleLis.append(tempArticle)
                        
                        
                    }
                    var sectionedArray = [Article]()
                    
                    var section = String()
                    for var i = 0; i < tempArticleLis.count; i++ {
                        
                        
                        section = tempArticleLis[i].section
                        
                        for article in tempArticleLis {
                            if section == article.section{
                                sectionedArray.append(article)
                                
                            }
                        }
                        self.dictionary[section] = sectionedArray
                        sectionedArray = [Article]()
                    }
                    
                    self.tableView.reloadData()
                }
            }
            myDataTask.resume()
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let d = [String] (dictionary.keys) [section]
        return d
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
           return dictionary.keys.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = [String] (dictionary.keys)[section]
        let articleList = dictionary[key]!
        let numberOfRows = articleList.count
        return numberOfRows
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIndetifier  = "NewswireTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIndetifier, forIndexPath: indexPath) as! NewswireTableViewCell
        
        
        let d = [String] (dictionary.keys) [indexPath.section]
        let article: NSArray = dictionary[d]!
        let iiii: Article = article.objectAtIndex(indexPath.row) as! Article
               if(iiii.media.count > 0){
            let thumbnailUrl: String = iiii.media[0]
            if let url = NSURL(string: thumbnailUrl) {
                if let data = NSData(contentsOfURL: url) {
                    cell.thumbnailPic.image = UIImage(data: data)
                }
            }
        }
        
        cell.headline.text = iiii.headline
        indicator.stopAnimating()
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
            let newswireInDetail = segue.destinationViewController as! NewsWireInDetailViewController
            if let selectedArticle = sender as? NewswireTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedArticle)!
                
                let d = [String] (dictionary.keys) [indexPath.section]
                let article: NSArray = dictionary[d]!
                let iiii: Article = article.objectAtIndex(indexPath.row) as! Article
                newswireInDetail.newswire = iiii
                
            }
        
    }

    
}
