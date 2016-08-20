import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    enum Mode {
        case Table
        case Swipe
    }
    var colors = [
        UIColor.redColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.magentaColor(),
        UIColor.purpleColor(),
        UIColor.brownColor(),
        UIColor.lightGrayColor(),
        UIColor.redColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.magentaColor(),
        UIColor.purpleColor(),
        UIColor.brownColor(),
        UIColor.lightGrayColor(),
        UIColor.redColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.magentaColor(),
        UIColor.purpleColor(),
        UIColor.brownColor(),
        UIColor.lightGrayColor(),
        UIColor.redColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.magentaColor(),
        UIColor.purpleColor(),
        UIColor.brownColor(),
        UIColor.lightGrayColor(),
        UIColor.redColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.magentaColor(),
        UIColor.purpleColor(),
        UIColor.brownColor(),
        UIColor.lightGrayColor()
    ]
    var tableLayout = UICollectionViewFlowLayout()
    var swipeLayout = SwipeLayout()
    var mode = Mode.Table

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.backgroundView = UIView(frame: CGRectZero)
        self.collectionView.remembersLastFocusedIndexPath = true
    }

    override func viewDidAppear(animated: Bool) {
        let tableViewCellSize = CGSize(width: self.collectionView.bounds.width, height: 50)
        self.tableLayout.itemSize = tableViewCellSize
        self.collectionView.collectionViewLayout = tableLayout
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = String(indexPath.item)
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("index Path chosen: \(indexPath)")
        self.swipeLayout.startingItemIndex = indexPath.item
        changeLayoutTapped(self)
    }

    @IBAction func changeLayoutTapped(sender: AnyObject) {
        if (self.collectionView.collectionViewLayout == tableLayout) {
            self.collectionView.setCollectionViewLayout(swipeLayout, animated: true)
            self.mode = Mode.Swipe
        } else {
            self.collectionView.setCollectionViewLayout(tableLayout, animated: true)
            self.mode = Mode.Table

        }
    }
}

