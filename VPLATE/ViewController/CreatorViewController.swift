
import UIKit
import SwiftyJSON
import Kingfisher
import PageMenu



enum  ClipType {
    case video, picture, text
}

struct TemplateInfo {
    let clipNum: Int
    let scene: [[Int : ClipInfo]]
}

struct ClipInfo {
    var index: Int = 0
    var type: ClipType = ClipType.picture
    var constraint: Double = 0.0
}



class CreatorViewController: ViewController, ViewControllerProtocol {
    @IBOutlet weak var sceneCollectionView: UICollectionView!
    @IBOutlet weak var sceneImageView: UIImageView!
    @IBOutlet weak var pageMenuView: UIView!
    
    static var requestData: [Any] = []
    var info: TemplateInfo?
    {
        didSet{
            if let num = self.info?.clipNum {
                CreatorViewController.requestData = Array(repeating: Any?.self, count: num)
            }
        }
    }
    // = Array(repeating: [Int:ClipInfo?].self, count: 3)
    
    
    var thumbnailImage: UIImage!
    var templateID: Int!
    var sceneURL: [String] = []
    var scenes: [[ClipInfo]] = [[ClipInfo]]()
    
    override func viewDidLoad() {
        
        //[95 - clipNum : 10
        //      scene : [1: .text(10), 2: .text(13)],
        //              [3: .video(6), 4: .text(9)],
        //              [5: .text(12), 6: .text(17)],
        //              [7: .video(6), 8: .text(9)],
        //              [9: .text(10), 10: .text(13)]]
        
        var sceneInfo: [ClipInfo] = []
        sceneInfo.append( ClipInfo(index: 1, type: .video, constraint: 10) )
        sceneInfo.append( ClipInfo(index: 2, type: .video, constraint: 13) )
        scenes.append(sceneInfo)
        sceneInfo.removeAll()
        sceneInfo.append(ClipInfo(index: 3, type: .video, constraint: 6))
        sceneInfo.append(ClipInfo(index: 4, type: .picture, constraint: 9))
        scenes.append(sceneInfo)
        sceneInfo.removeAll()
        sceneInfo.append(ClipInfo(index: 5, type: .picture, constraint: 12))
        sceneInfo.append(ClipInfo(index: 6, type: .picture, constraint: 17))
        scenes.append(sceneInfo)
        sceneInfo.removeAll()
        sceneInfo.append(ClipInfo(index: 6, type: .picture, constraint: 17))
        sceneInfo.append(ClipInfo(index: 8, type: .video, constraint: 9))
        scenes.append(sceneInfo)
        sceneInfo.removeAll()
        sceneInfo.append(ClipInfo(index: 9, type: .video, constraint: 10))
        sceneInfo.append(ClipInfo(index: 10, type: .video, constraint: 13))
        scenes.append(sceneInfo)
        sceneInfo.removeAll()
        
        super.viewDidLoad()
        self.navigationItem.title = TitleEnum.creator.rawValue
        setUpCollectionView(collectionView: sceneCollectionView, cell: SceneCollectionViewCell.self)
    
        
        sceneImageView.image = thumbnailImage
        fetchTemplateInform()
        if #available(iOS 10.0, *) {
            sceneCollectionView.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
        
        setUpPageMenu(index: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.sceneCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    var pageMenu: CAPSPageMenu?
    func setUpPageMenu(index: Int){
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1: EditorViewController = EditorViewController(nibName: EditorViewController.reuseIdentifier, bundle: nil)
        controller1.title = "VIDEO"
        controller1.parentNavigation = self.navigationController
        var scene = scenes[index].filter { (value) -> Bool in
            return value.type == ClipType.video ? true: false
        }
        controller1.editData = scene
        controller1.type = ClipType.video
        controllerArray.append(controller1)
        
        let controller2: EditorViewController = EditorViewController(nibName: EditorViewController.reuseIdentifier, bundle: nil)
        controller2.title = "PICTURE"
        controller2.parentNavigation = self.navigationController
        scene = scenes[index].filter { (value) -> Bool in
            return value.type == ClipType.picture ? true: false
        }
        controller2.editData = scene
        controller2.type = ClipType.picture
        controllerArray.append(controller2)
        
        
        let font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)!
        
        let menuHeight:CGFloat = super.view.frame.height * 0.05// 50.0
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor.black.withAlphaComponent(0.38) ),
            .menuItemFont(font),
            .menuHeight(menuHeight),
            .menuMargin(0),
            .menuItemWidth(100),
            .selectionIndicatorHeight(0),
            .bottomMenuHairlineColor(UIColor.white),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .selectedMenuItemLabelColor(UIColor.black),]
        
        
        // Initialize scroll menu
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray,
                                frame: CGRect(x: 0.0, y: 0.0, width: self.pageMenuView.frame.width, height: self.pageMenuView.frame.height),
                                pageMenuOptions: parameters)
        
        for subview in (pageMenu?.view.subviews)! {
            if let scroll = subview as? UIScrollView {
                scroll.isScrollEnabled = false
            }
        }
        self.pageMenuView.addSubview(pageMenu!.view)
    }
    
    func fetchTemplateInform() {
        TemplateListServiece.getTemplateList(url: "account/template/inform/scene/", method: .get, parameter: ["templateid" : templateID], header: Token.getToken()) { (response) in
            switch response {
            case .Success (let data):
                guard let data = data as? Data else {return}
                let dataJSON = JSON(data)
                let urls = dataJSON["data"].arrayValue
                self.sceneURL = urls.map({ (jsonData) -> String in
                    guard let jsonData = jsonData as JSON? else {return ""}
                    guard let url = jsonData.string else {return ""}
                    return url
                }).filter({ (str) -> Bool in
                    return str == "" ? false : true
                })
                self.sceneCollectionView.reloadData()                
            case .Failure(_):
                break
            }
        }
    }
}

extension CreatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.sceneCollectionView.cellForItem(at: indexPath) as! SceneCollectionViewCell
        cell.reload()
        self.sceneImageView.image = cell.imageView.image
        setUpPageMenu(index: indexPath.row)
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = self.sceneCollectionView.cellForItem(at: indexPath) as! SceneCollectionViewCell? {
            cell.reload()
        }
    }
}

extension CreatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sceneURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SceneCollectionViewCell.reuseIdentifier, for: indexPath) as! SceneCollectionViewCell
        cell.info = SceneInform(url: sceneURL[indexPath.row], sceneNum: indexPath.row + 1)
        cell.reload()
        return cell
    }
    
}

extension CreatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height * 16/9, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
