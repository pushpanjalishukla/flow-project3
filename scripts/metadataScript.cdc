import NonFungibleToken from 0x06
import CryptoPets from 0x05

pub fun main(acctAddress: Address, id: UInt64): &CryptoPets.NFT {
    let contract = getAccount(acctAddress).getCapability(/public/CryptoPetsCollection)
      .borrow<&CryptoPets.Collection>() ?? panic("Could not borrow collection reference")

    let nftMeta = contract.borrowAuthNFT(id: id)

    log(nftMeta.name)
    log(nftMeta.petType)
    log(nftMeta.petAge)

    return nftMeta
}
