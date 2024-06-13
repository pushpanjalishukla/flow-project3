
import NonFungibleToken from 0x06
import CryptoPets from 0x05

pub fun main(acctAddress: Address): [UInt64] {
    
    let pubRef = getAccount(acctAddress).getCapability(/public/CryptoPetsCollection)
                    .borrow<&CryptoPets.Collection{NonFungibleToken.CollectionPublic}>()
                    ?? panic("No collection is associated with the address.")

    return pubRef.getIDs()
}
