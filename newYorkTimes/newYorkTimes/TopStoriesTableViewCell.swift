
import UIKit

class TopStoriesTableViewCell: UITableViewCell {
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var savedIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }

}
