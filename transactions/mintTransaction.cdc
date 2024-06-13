// File: mintTransaction.cdc

import NonFungibleToken from 0x06
import CryptoPets from 0x05

transaction(recipientAccount: Address, petName: String, petType: String, petAge: Int) {
  prepare(signer: AuthAccount) {
    let minter = signer.borrow<&CryptoPets.Minter>(from: /storage/Minter)!
    let pubrecipientRef = getAccount(recipientAccount).getCapability(/public/CryptoPetsCollection)
                    .borrow<&CryptoPets.Collection{NonFungibleToken.CollectionPublic}>()
                    ?? panic("No collection is associated with the address.")
    let nft <- minter.createNFT(petName: petName, petType: petType, petAge: petAge)
    pubrecipientRef.deposit(token: <- nft)
  }

  execute {
    log("NFT minted and deposited successfully")
  }
}
