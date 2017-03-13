
import Foundation

 // let serialQueue = DispatchQueue(label: "com.queue.Serial")
  //      serialQueue.async {
NSLog("Starting")
NetworkKeeper.sharedSingleton.loadData()
NetworkKeeper.sharedSingleton.initNetwork()

NetworkKeeper.sharedSingleton.train(updateFunc:

    { a in
    })

NSLog("Done")
NSLog("\(NetworkKeeper.sharedSingleton.test())")
