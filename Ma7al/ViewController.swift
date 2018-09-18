//
//  ViewController.swift
//  Ma7al
//
//  Created by Mustafa on 9/14/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CHTCollectionViewWaterfallLayout


class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CHTCollectionViewDelegateWaterfallLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var refresher:UIRefreshControl!
    private var firstRefresh = false
    
    
    //collection view datasource array
    private var postsArray = [Post]()
    private var postHeightArray = [CGFloat]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        setupView()
        setupCollectionView()
        
        loadData {
            if !self.firstRefresh {
               self.postsArray = self.postsArray.sorted(by: {$0.timeStamp > $1.timeStamp})
                self.collectionView.reloadData()
                
            }
            self.firstRefresh = true
        
        }
    }
    
    
    
    //MARK:-pull to refresh controll
    @objc private func refresh(sender:AnyObject)
    {
        
        postsArray.removeAll()
        var refreshCheak = true
        loadData {
            if refreshCheak {
                self.postsArray = self.postsArray.sorted(by: {$0.timeStamp > $1.timeStamp})
                self.collectionView.reloadData()
                self.refresher.endRefreshing()
                ref.removeAllObservers()
            }
            refreshCheak = false
        }
        
        
    }
    
    
    //MARK:-collection view datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postsArray.count
    }
    
    //MARK:-collection view delagete
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PostsCollectionViewCell
        print("hi")
        let post = postsArray[indexPath.row]
        
        cell.configureCell(post:post)
        
        cell.tag = indexPath.row
        return cell
        
    }
    
    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // create a cell size from the image size, and return the size
        //  let imageSize = model.images[indexPath.row].size
        
        return CGSize(width: collectionView.bounds.size.width / 2 - 2, height: postHeightArray[indexPath.row])
    }

    
    
    
    
    
    //MARK:-configure segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailedSegue" {
            if let toViewController = segue.destination as? ProdactDetailedViewController {
                if let cell = sender as? PostsCollectionViewCell {
                    toViewController.post = postsArray[cell.tag]
                }
                
            }
        }
    }
    
    //MARK:-loading data from firebase
    private func loadData(completed:@escaping DownloadComplete){
     /*   ref.child("posts").observe(.value, with:  {(snapshot) in*/
        ref.child("posts").observeSingleEvent(of: .value, with: {(snapshot) in
            self.postsArray.removeAll()
            
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snaps {
                    
                    if let dic = snap.value as? [String:Any] {
                        
                        
                        let id = snap.key
                        let likes = dic["likes"] as! Int
                        let imageUrl = dic["image"] as! String
                        let price = dic["price"] as! String
                        let shopname = dic["shopName"] as! String
                        let description = dic["description"] as! String
                        let images = dic["images"] as! [String:String]
                        let postHeight = dic["height"] as! CGFloat
                        let timeStamp = dic["timeStamp"] as! Int
                    let post = Post.init(price: price, likes: likes, imageUrl: imageUrl, description: description, shopName: shopname,images:images,id:id,timeStamp:timeStamp)
                            self.postsArray.append(post)
                      
                        
                        self.postHeightArray.append(postHeight)
                        
                    }
                    
                    
                }
                completed()
            }
            
        })
       
        
        
        
        
    }
    
    
    @IBAction func post(_ sender: Any) {
        
        let uuid = UUID().uuidString
        let dict = ["description" : "حذاء جلد اصلي باب ثاني",
                    "image" : "http://sararonline.com/images/P/Brown-Leather-Shoes-883P.jpg",
                    "likes" : 200,
                    "images": [uuid:"https://sc01.alicdn.com/kf/HTB1VbtxSFXXXXaNXpXX760XFXXX9/230927794/HTB1VbtxSFXXXXaNXpXX760XFXXX9.png"],
                    "price" : "60000",
                    "shopName" : "عدنان واولاده",
                    "height" : 300.1,"timeStamp": ServerValue.timestamp()] as [String : Any]
        
        
         ref.child("posts").childByAutoId().setValue(dict)
       
    }
    @objc private func setupView() {
        self.automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.barTintColor = colors.tintColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: fonts.massariBluePrintFont(size: 18)]
        
        tabBarController?.tabBar.barTintColor = UIColor.white
        tabBarController?.tabBar.tintColor = colors.tintColor
        tabBarController?.tabBar.backgroundColor = UIColor.white
        
        //pull to refresh adjusment
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.blue
        self.refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
        //end
        
    }
    
    
    func setupCollectionView(){
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 1.5
        layout.minimumInteritemSpacing = 2.0
        
        // Collection view attributes
        self.collectionView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.collectionView.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collectionView.collectionViewLayout = layout
    }
    

    
}





