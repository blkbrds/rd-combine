//
//  GameDetailViewController.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/31/21.
//

import UIKit

final class GameDetailViewController: ViewController {

    var viewModel: GameDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel?.gameName
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
