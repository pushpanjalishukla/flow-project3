// File: collectionTransaction.cdc

import CryptoPets from 0x05

transaction() {
  prepare(signer: AuthAccount) {
    if signer.borrow<&CryptoPets.Collection>(from: /storage/CryptoPetsCollection) != nil {
      log("You already have a collection.")
      return
    }

    signer.save(<- CryptoPets.createEmptyCollection(), to: /storage/CryptoPetsCollection)
    signer.link<&CryptoPets.Collection>(/public/CryptoPetsCollection, target: /storage/CryptoPetsCollection)

    log("Collection Created")
  }
}
