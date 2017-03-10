
import Foundation

 // let serialQueue = DispatchQueue(label: "com.queue.Serial")
  //      serialQueue.async {

NetworkKeeper.sharedSingleton.loadData()
NetworkKeeper.sharedSingleton.initNetwork()

NetworkKeeper.sharedSingleton.train(updateFunc:

    { a in
    NSLog("*")
    })

NSLog("Done")
NSLog("\(NetworkKeeper.sharedSingleton.test())")
