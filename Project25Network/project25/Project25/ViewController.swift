//
//  ViewController.swift
//  Project25
//
//  Created by TwoStraws on 19/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
   
    @IBOutlet var label: UILabel!
    
    
	var images = [UIImage]()
//идентифицирует каждого пользователя уникально в сеансе.
	var peerID: MCPeerID!
    //это класс менеджера, который обрабатывает все многопользовательские подключения для нас.
	var mcSession: MCSession!
    //используется при создании сеанса, сообщая другим, что мы существуем, и обрабатывая приглашения.
	var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Selfie Share"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
		let importPictureButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(importPicture))
        let usersConectedButton = UIBarButtonItem(title: "Users", style: UIBarButtonItem.Style.plain, target: self, action: #selector(usersConected))
        let addSomeText = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(addText))
         
        navigationItem.rightBarButtonItems = [importPictureButton, usersConectedButton, addSomeText ]
        
        
        
		peerID = MCPeerID(displayName: UIDevice.current.name)
		mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
		mcSession.delegate = self
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)

		if let imageView = cell.viewWithTag(1000) as? UIImageView {
			imageView.image = images[indexPath.item]
		}
        
        if let vc = cell.viewWithTag(900) as? UITextView {
            vc.text = "nsjnsvjnsvsv"
        }

		return cell
	}
    
    @objc func addText() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "toVC") as? TextViewController {
           // vc.text =
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @objc func usersConected() {
            guard let mcSession = mcSession else {return}
           let users = mcSession.connectedPeers
            for user in users {
                let ac = UIAlertController(title: "Online ", message: user.displayName, preferredStyle: UIAlertController.Style.alert)
                ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                present(ac, animated: true, completion: nil)
            }
    
        }

	@objc func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }

		dismiss(animated: true)

		images.insert(image, at: 0)
		collectionView?.reloadData()

		// 1
		if mcSession.connectedPeers.count > 0 {
			// 2
            if let imageData = image.pngData() {
				// 3
				do {
					try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
				} catch {
					let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
					ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					present(ac, animated: true)
				}
			}
		}
	}

	@objc func showConnectionPrompt() {
		let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
		ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}

	func startHosting(action: UIAlertAction) {
		mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
		mcAdvertiserAssistant.start()
	}

	func joinSession(action: UIAlertAction) {
        //используется при поиске сеансов, показывает пользователей, которые находятся рядом, и позволяет им присоединиться.
		let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
		mcBrowser.delegate = self
		present(mcBrowser, animated: true)
	}

	func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

	}

	func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

	}

	func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

	}

	func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}

	func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}

	func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
		switch state {
		case MCSessionState.connected:
			print("Connected: \(peerID.displayName)")

		case MCSessionState.connecting:
			print("Connecting: \(peerID.displayName)")

		case MCSessionState.notConnected:
			let ac = UIAlertController(title: " User Disconected", message: peerID.displayName, preferredStyle: UIAlertController.Style.alert)
                        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        present(ac, animated: true, completion: nil)
                         print("NotConnected:\(peerID.displayName)")
            @unknown default:
                        print("unknown state received:\(peerID.displayName)")
            
		}
	}

	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		if let image = UIImage(data: data) {
			DispatchQueue.main.async { [unowned self] in
				self.images.insert(image, at: 0)
				self.collectionView?.reloadData()
			}
		}
	}

	func sendImage(img: UIImage) {
		if mcSession.connectedPeers.count > 0 {
			if let imageData = img.pngData() {
				do {
					try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
				} catch let error as NSError {
					let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
					ac.addAction(UIAlertAction(title: "OK", style: .default))
					present(ac, animated: true)
				}
			}
		}
	}
}

 //Вы можете создать Dataиз строки, используя Data(yourString.utf8), и преобразовать Dataобратно в строку, используя String(decoding: yourData, as: UTF8.self).
