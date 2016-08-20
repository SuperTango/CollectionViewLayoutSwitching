import UIKit

class SwipeLayout: UICollectionViewLayout {

    let Y_OFFSET: CGFloat = 10
    let SIZE_SHRINKAGE: CGFloat = 25
    let MAX_NUMBER_SHOWN = 3
    private let debug = false
    var attributesArrayCache = [UICollectionViewLayoutAttributes]()

    var startingItemIndex = 0

    var indexPathsToAnimate = [NSIndexPath]()

//    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
//        dlog("prepareForCollectionViewUpdtes: UpdateItems: \(updateItems)")
//        super.prepareForCollectionViewUpdates(updateItems)
//        indexPathsToAnimate.removeAll()
//
//        for updateItem in updateItems {
//            switch (updateItem.updateAction) {
//            case UICollectionUpdateAction.Insert:
//                indexPathsToAnimate.append(updateItem.indexPathAfterUpdate!)
//            case UICollectionUpdateAction.Delete:
//                indexPathsToAnimate.append(updateItem.indexPathBeforeUpdate!)
//            case UICollectionUpdateAction.Move:
//                indexPathsToAnimate.append(updateItem.indexPathBeforeUpdate!)
//                indexPathsToAnimate.append(updateItem.indexPathAfterUpdate!)
//            default:
//                NSLog("unhandled case: \(updateItem)")
//            }
//        }
//    }
//
//    override func finalizeCollectionViewUpdates() {
//        dlog("finalize updates");
//        super.finalizeCollectionViewUpdates()
//        self.indexPathsToAnimate.removeAll()
//    }

    override func prepareLayout() {
        super.prepareLayout()
        dlog("prepareLayout called")
        if (attributesArrayCache.count == 0) {
            let collectionFrame = self.collectionView!.frame
            let initialWidth: CGFloat = collectionFrame.width * 0.6

            let numItems = MAX_NUMBER_SHOWN
            if (numItems > 0) {
                for index in (0 ..< numItems ) {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)

                    let width: CGFloat = initialWidth - (CGFloat(index) * SIZE_SHRINKAGE)
                    let height: CGFloat = width
                    let x = (collectionFrame.width / 2) - width / 2
                    let y = collectionFrame.height - initialWidth - (CGFloat(index) * Y_OFFSET) - 180

                    attributes.frame = CGRect(x: x, y: y, width: width, height: height)
                    attributes.zIndex = 20 - index
                    attributesArrayCache.append(attributes)
                    dlog("  Setting cache value for.  index: \(index), width: \(width), height: \(height), x: \(x), y: \(y), center: \(attributes.center) cache size: \(attributesArrayCache.count)")
                }
            }
        }
    }

    override func initialLayoutAttributesForAppearingItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        dlog("initialLayoutAttributesForAppearingItemAtIndexPath: indexPath: \(indexPath.item)")
        let attributes = self.layoutAttributesForItemAtIndexPath(indexPath)
        for (index, value) in self.indexPathsToAnimate.enumerate() {
            if (value == indexPath) {
                let newAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                newAttributes.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                newAttributes.zIndex = 20 - indexPath.row
                dlog("initialLayoutAttributesForAppearingItemAtIndexPath creating new attributes")
                self.indexPathsToAnimate.removeAtIndex(index)
                return newAttributes
            }
        }
        dlog ("initialLayoutAttributesForAppearingItemAtIndexPath returning existing attributes")
        return attributes
    }

    override func finalLayoutAttributesForDisappearingItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        dlog("finalLayoutAttributesForDisappearingItemAtIndexPath: indexPath: \(indexPath.item)")
        let attributes = self.layoutAttributesForItemAtIndexPath(indexPath)
        for (index, value) in self.indexPathsToAnimate.enumerate() {
            if (value == indexPath) {
                let newAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                if (attributes == nil) {
                    dlog("finalLayoutAttributesForDisappearingItemAtIndexPath: returning new attributes with CGRectZero Frame")
                    newAttributes.frame = CGRectZero
                } else {
                    dlog("  finalLayoutAttributesForDisappearingItemAtIndexPath: returning new attributes frame defined")
                    newAttributes.frame = CGRect(x: attributes!.frame.origin.x, y: 700, width: attributes!.frame.width, height: attributes!.frame.height)
                }
                newAttributes.zIndex = 100
                self.indexPathsToAnimate.removeAtIndex(index)

                return newAttributes
            }
        }
        dlog("  finalLayoutAttributesForDisappearingItemAtIndexPath: existing attributes")
        return attributes
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        let numberOfItemsInSection = self.collectionView!.numberOfItemsInSection(0)
        for count in 0 ..< attributesArrayCache.count {
            if ((CGRectIntersectsRect(attributesArrayCache[count].frame, rect)) && (count < numberOfItemsInSection)){
                layoutAttributes.append(attributesArrayCache[count])
            }
        }
        dlog("layoutAttributesForElementsInRect: rect: \(rect)")
        for attributes in layoutAttributes {
            dlog("  attributes: \(attributes)")
        }
        return layoutAttributes
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let swipeItemCount = indexPath.row - startingItemIndex
        if swipeItemCount >= self.attributesArrayCache.count {
            let newAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            var x: CGFloat = 0
            var y: CGFloat = 0
            if (attributesArrayCache.count > 0) {
                x = attributesArrayCache[0].center.x
                y = attributesArrayCache[0].center.y
            }
            newAttributes.frame = CGRect(x: x, y: y, width: 0, height: 0)
            newAttributes.zIndex = 20 - swipeItemCount
            NSLog("    layoutAttributesForItemAtIndexPath: indexPath: \(indexPath.row), swipeItemCount: \(swipeItemCount), swipeItemCount > cache Count, returning attrs w 0 frame")
            return newAttributes
        } else if (swipeItemCount < 0) {
            let newAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            var x: CGFloat = 0
            var y: CGFloat = 0
            if (attributesArrayCache.count > 0) {
                x = attributesArrayCache[0].center.x
                y = attributesArrayCache[0].center.y
            }
            newAttributes.frame = CGRect(x: x, y: y, width: 0, height: 0)
            newAttributes.zIndex = 20 // - swipeItemCount
            NSLog("    layoutAttributesForItemAtIndexPath: indexPath: \(indexPath.row), swipeItemCount: \(swipeItemCount), swipeItemCount < 0, returning: attrs w/ 0 frame")
            return newAttributes
        } else {

            NSLog("    layoutAttributesForItemAtIndexPath: indexPath.row: \(indexPath.row), swipeItemCount: \(swipeItemCount), swipeItemCount valid, returning cached value")
            let layoutAttributes = self.attributesArrayCache[swipeItemCount]
//            dlog("  layoutAttributesForItemAtIndexPath: indexPath: \(indexPath.row - startingItemIndex), returning cached value: \(layoutAttributes)")
            return layoutAttributes
        }
    }

    override func collectionViewContentSize() -> CGSize {
        return self.collectionView!.frame.size
    }

    private func dlog(message: String) {
        if (debug) {
            NSLog(message)
        }
    }
}
