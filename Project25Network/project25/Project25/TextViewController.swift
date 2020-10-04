//
//  TextViewController.swift
//  Project25
//
//  Created by Yurii Sameliuk on 16/06/2020.
//

import UIKit
import MultipeerConnectivity
class TextViewController: UIViewController {

    var mcSession: MCSession?

    
    @IBOutlet var textView: UITextView!
    var texts: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItem.Style.plain, target: self, action: #selector(sendText))
    }
    
   @objc func sendText() {
        
    guard let mcSession = mcSession else {return}

    if mcSession.connectedPeers.count > 0 {
         let textData = Data(texts!.utf8)
            do {
                try mcSession.send(textData, toPeers: mcSession.connectedPeers, with: MCSessionSendDataMode.reliable)
            } catch {
                let ac = UIAlertController(title: "Send Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                present(ac, animated: true, completion: nil)
            }
        }
    
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
         let text = String(decoding: data, as: UTF8.self)
            DispatchQueue.main.async { [weak self] in
                self?.texts = text
                self?.textView.text = text
                self?.view.reloadInputViews()
            }
        
    }
}
