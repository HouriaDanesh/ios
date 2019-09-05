
import UIKit

class TopStoriesTableViewController: UITableViewController{
    
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
        
        var filePath : String {
            let manager = NSFileManager.defaultManager()
            let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
            return url.URLByAppendingPathComponent("objectsArray").path!
        }
        self.pathToFile = filePath
        let emptyList = [ArticleShort]()
        let listOfarticles = NSKeyedUnarchiver.unarchiveObjectWithFile(self.pathToFile) as? [ArticleShort]
        
        if listOfarticles == nil {
            
            NSKeyedArchiver.archiveRootObject(emptyList, toFile: pathToFile)
        }
        loadDataFromJSON()
    }
    
    static let saveArticles = "SAVED_ARTICLES"
    var articles = [String]()
    var pathToFile = String()
    
    
    
    func loadDataFromJSON() -> Void{
        indicator.startAnimating()
        
        
        let downloadSession = NSURLSessionConfiguration.defaultSessionConfiguration()
        let prefs = NSUserDefaults.standardUserDefaults()
        let apiKey = prefs.stringForKey(ArticleTableViewController.topStoriesApiKey)
        
        
        if apiKey != nil{
            let urlApi = NSURL(string: "http://api.nytimes.com/svc/topstories/v1/home.json?api-key=" + apiKey!)
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
                        
                        //implement media
                        var media = [String]()
                        let mediaLinkJSONArray = tempObject["multimedia"]
                        
                        for(_, mediaObject) in mediaLinkJSONArray{
                            if mediaObject["type"] == "image" {
                                
                                media.append(mediaObject["url"].stringValue)
                                
                            }
                            
                        }
                        
            
                        let tempArticle = Article(headline: headline, leadParagraph: paragraph, media: media, webURL: webUrl, section: section, relatedUrlList: nil)
                        
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
                    
                    //self.dictionary = tempArticleLis
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            myDataTask.resume()
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //good one
        let d = [String] (dictionary.keys) [section]
        return d
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dictionary.keys.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = [String] (dictionary.keys)[section]
        let articleList = dictionary[key]!
        let numberOfRows = articleList.count
        
        
        
        
        return numberOfRows
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndetifier  = "TopStoriesTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIndetifier, forIndexPath: indexPath) as! TopStoriesTableViewCell
        
        
        let d = [String] (dictionary.keys) [indexPath.section]
        
        
        let article: NSArray = dictionary[d]!
        // let articlell = article[indexPath.row]
        
        let articletemp: Article = article.objectAtIndex(indexPath.row) as! Article
        
        
        if(articletemp.media.count > 0){
            let thumbnailUrl: String = articletemp.media[0]
            if let url = NSURL(string: thumbnailUrl) {
                if let data = NSData(contentsOfURL: url) {
                    cell.thumbnail.image = UIImage(data: data)
                }
            }
        }
        
   
        cell.headline.text = articletemp.headline
        

        
        
        
        indicator.stopAnimating()
        
        return cell
    }
    
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let save = UITableViewRowAction(style: .Destructive, title: "Save") { (action, indexPath) in
            
            //      let indexPath = tableView.indexPathForSelectedRow!
            let d = [String] (self.dictionary.keys) [indexPath.section]
            let _ = indexPath.row
            let article: NSArray = self.dictionary[d]!
            let iiii: Article = article.objectAtIndex(indexPath.row) as! Article

            
            
            
            
            
            
            let articleToSave = ArticleShort(headline: iiii.headline, url: iiii.webURL)
            
            var listOfarticles = NSKeyedUnarchiver.unarchiveObjectWithFile(self.pathToFile) as? [ArticleShort]
            
            if listOfarticles!.count < 1 {
                var tempList = [ArticleShort]()
                tempList.append(articleToSave)
              
                NSKeyedArchiver.archiveRootObject(tempList, toFile: self.pathToFile)
             
                
            }else {
                
           
                
                
                
                var isSaved = false
                for indexedArticle in listOfarticles!{
                    
                    if indexedArticle.headline == articleToSave.headline{
                        isSaved = true
                        break
                    }
                }
                if isSaved == false{
                    listOfarticles!.append(articleToSave)
                    NSKeyedArchiver.archiveRootObject(listOfarticles!, toFile: self.pathToFile)
                    
                }
                
          
            }
            
            
            
        }
        
        
        
        
        
        return [save]
    }
    

    
    
    // if tableView is set in attribute inspector with selection to multiple Selection it should work.
    
    // Just set it back in deselect
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
