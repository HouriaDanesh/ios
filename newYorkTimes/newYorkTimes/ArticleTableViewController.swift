
import UIKit

class ArticleTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchArticle: UISearchBar!
    
    static let articleSearchApiKey = "ARTICLESEARCH"
    static let newswireApiKey = "NEWSWIREAPI"
    static let topStoriesApiKey = "TOPSTORIESAPIKEY"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(65, 0.0,0.0, 0.0)
              searchArticle.delegate = self
        
              let articleSearchApi = "1c8c8bc65c2cd31435f866a56c120a13:12:73706136"
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setObject(articleSearchApi, forKey: ArticleTableViewController.articleSearchApiKey)
              let newswireApi = "b06226be30902c62a1ad94db6f5bb4c2:2:73706136"
        prefs.setObject(newswireApi, forKey: ArticleTableViewController.newswireApiKey)
        
        let topStoriesApi = "fffb1d4819a3d43914f56a4801249a29:17:73706136"
        prefs.setObject(topStoriesApi, forKey: ArticleTableViewController.topStoriesApiKey)
        
        indicator.color = UIColor .blackColor()
        indicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        
       }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    
    
   
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    var articleList = [Article]()
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        
        indicator.startAnimating()
        
        
        let downloadSession = NSURLSessionConfiguration.defaultSessionConfiguration()
        let searchString = searchArticle.text!
        let prefs = NSUserDefaults.standardUserDefaults()
        let apiKey = prefs.stringForKey(ArticleTableViewController.articleSearchApiKey)
        
        
        if searchString.characters.count > 0 && apiKey != nil{
            let searchStringWithoutSpaces = searchString.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let urlApi = NSURL(string: "http://api.nytimes.com/svc/search/v2/articlesearch.json?fq=" + searchStringWithoutSpaces + "&sort=newest&api-key=" + apiKey!)
            
            
            let userDataSession = NSURLSession(configuration: downloadSession, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
            let myDataTask = userDataSession.dataTaskWithURL(urlApi!){(data, response, error) -> Void in
                
                if error == nil {
                    let userDataJSON = JSON(data: data!)
                    
                    let articleJSONArray = userDataJSON["response"]["docs"]
                    var tempArticleList = [Article]()
                    for (_, tempObject) in articleJSONArray{
                        
                        let headline = tempObject["headline"]["main"].stringValue
                        let leadParagraph = tempObject["lead_paragraph"].stringValue
                        let webUrl = tempObject["web_url"].stringValue
                        
                        
                        var media = [String]()
                        let mediaLinkJSONArray = tempObject["multimedia"]
                        for(_, mediaObject) in mediaLinkJSONArray{
                            if mediaObject["type"] == "image" {
                                media.append(mediaObject["url"].stringValue)
                                
                            }
                            
                        }
                        let tempArticle  = Article(headline: headline, leadParagraph: leadParagraph, media: media, webURL: webUrl)
                        tempArticleList.append(tempArticle)
                    }
                    self.articleList = tempArticleList
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            
            myDataTask.resume()
            
        }
        
        searchArticle.resignFirstResponder()
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return articleList.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ArticleTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ArticleTableViewCell
        
        let article = articleList[indexPath.row]
        cell.articleHeadline.text = article.headline
        
        indicator.stopAnimating()
        return cell
    }
        override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
                return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail"
        {
            let articlesInDetail = segue.destinationViewController as! SearchedArticleInDetailsViewController
            if let selectedArticle = sender as? ArticleTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedArticle)!
                let selectedArticle = self.articleList[indexPath.row]
                articlesInDetail.article = selectedArticle
                
            }
        }
        
    }
    
    
}
