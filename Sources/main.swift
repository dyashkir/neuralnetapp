
import Foundation

 // let serialQueue = DispatchQueue(label: "com.queue.Serial")
  //      serialQueue.async {

NetworkKeeper.sharedSingleton.train(updateFunc:
    { a in
    NSLog("*")
    },

onFinish: { _ in return })
