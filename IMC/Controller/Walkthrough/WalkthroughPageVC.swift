//
//  WalkthroughPageViewController.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 9/24/18.
//  Copyright © 2018 Mohamed Salah Zidane. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController,UIPageViewControllerDataSource{
    var pageHeadings = ["المركز الطبي العالمي","العيادات", "الخبراء", "الاطباء","الحجز","تواصل بنا"]
    var pageImages = ["imcb", "clinics", "experts","doctors","reserve","phoneContact"]
    var pageContent = ["يضم المركز الطبي العالمي أكثر من مائة من الخبراء الاستشاريين الذين يعملون في العديد من التخصصات الطبية والجراحية المختلفه:- \n- الرعاية الصحية الفعالة من حيث التكلفة في المجتمعات التي نخدمها \n- العديد من الخبراء والإستشاريين الأجانب يزورون المركز الطبي العالمي كل عام، مما يتيح لنا تقديم أحدث طرق العلاج الطبي \n- يضم المركز الطبي العالمي أحدث المعدات الطبية في كافة التخصصات \n- تم تجهيز المركز الطبي العالمي بمدرج للطائرات المروحية لإستقبال الحالات الحرجة \n- يضم المركز الطبي العالمي بقسم الطوارئ قسم خاص إزالة حالات التلوث المختلفة كالتلوث الكيميائي أو التلوث البيولوجي أو حتى التلوث الإشعاعي \n- المركز الطبي العالمي حاصل على إعتماد اللجنة الدولية المشتركة (JCI)  -\nيضم المركز الطبي العالمي قسماً فندقياً ، لأسر المرضى القادمين من المحافظات المختلفة ، أو للأجانب من خارج جمهورية مصر العربية", "تصفح وابحث عن العياده التي تريد الحجز بها", "   يوجد خبراء اجانب من جميع انحاء العالم يلتحقون بالمستشفي ويمكنك الحجز معهم","   بعد اختيار العياده يمكنك اختيار الطبيب المفضل لديك للحجز معه","   يمكنك بشكل مبسط حجز معاد كشف من اي مكان في خلال ٤٨ ساعه","   يمكنك التواصل بنا في اي وقت خلال ال ٢٤ ساعه"]
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        dataSource = self
        if let  startingViewController = contentViewController(at : 0 ){
        
          setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)

        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,    viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    func contentViewController(at index:Int)->WalkthroughContentViewController?{
        if index < 0 || index >= pageHeadings.count
        {
             return nil
        }
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController{
            
            pageContentViewController.content = pageContent[index]
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.index = index
            return pageContentViewController
            
        }
        return nil
    }

    func forward(index : Int){
        if let nextViewController = contentViewController(at: index + 1){
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return pageHeadings.count
//    }
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController")as? WalkthroughContentViewController {
//
//            return pageContentViewController.index
//        }
//        return 0
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
