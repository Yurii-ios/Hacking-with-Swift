//
//  ViewController.swift
//  Project25Network
//
//  Created by Yurii Sameliuk on 15/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
var images = [UIImage]()
    //идентифицирует каждого пользователя уникально в сеансе.
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    //это класс менеджера, который обрабатывает все многопользовательские подключения для нас.
    var mcSession: MCSession?
    //используется при создании сеанса, сообщая другим, что мы существуем, и обрабатывая приглашения.
    var mcAdvertiserAssistant: MCAdvertiserAssistant!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Selfiee Share"

      let importPictureButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(importPicture))
      let usersConectedButton = UIBarButtonItem(title: "Users", style: UIBarButtonItem.Style.plain, target: self, action: #selector(usersConected))
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(schowConnectionPrompt))
        navigationItem.rightBarButtonItems = [importPictureButton, usersConectedButton ]
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.required)
        mcSession?.delegate = self


    }

    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else {return}
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }

    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else {return}
        //используется при поиске сеансов, показывает пользователей, которые находятся рядом, и позволяет им присоединиться.
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self

        present(mcBrowser, animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)

        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }

    @objc func usersConected() {
        guard let mcSession = mcSession else {return}
       let users = mcSession.connectedPeers
        for user in users {
            let ac = UIAlertController(title: "Online ", message: nil, preferredStyle: UIAlertController.Style.alert)
            ac.addAction(UIAlertAction(title: user.displayName, style: UIAlertAction.Style.default, handler: nil))
            present(ac, animated: true, completion: nil)
        }

    }

    @objc func schowConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session", style: UIAlertAction.Style.default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: UIAlertAction.Style.default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        present(ac, animated: true, completion: nil)
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true, completion: nil)

        images.insert(image, at: 0)

        collectionView.reloadData()

        guard let mcSession = mcSession else {return}

        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                } catch {
                    let ac = UIAlertController(title: "Send Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    present(ac, animated: true, completion: nil)
                }
            }
        }
    }
// Protocol methods
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Conected:\(peerID.displayName)")

        case .connecting:
            print("Connecting:\(peerID.displayName)")
        case .notConnected:
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
        DispatchQueue.main.async { [weak self] in
            self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
}

