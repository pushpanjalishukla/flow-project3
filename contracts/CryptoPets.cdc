// File: CryptoPets.cdc

import NonFungibleToken from 0x06

pub contract CryptoPets: NonFungibleToken {
  pub var totalSupply: UInt64

  pub event ContractInitialized()
  pub event Withdraw(id: UInt64, from: Address?)
  pub event Deposit(id: UInt64, to: Address?)

  pub resource NFT: NonFungibleToken.INFT {
    pub let id: UInt64
    pub let petName: String
    pub let petType: String
    pub let petAge: Int

    init(_petName: String, _petType: String, _petAge: Int) {
      self.id = self.uuid
      self.petName = _petName
      self.petType = _petType
      self.petAge = _petAge
    }
  }

  pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
    pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}
    pub var ownedNFTsMetadata: @{UInt64: CryptoPets.NFT}

    pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
      let nft <- self.ownedNFTs.remove(key: withdrawID) ?? panic("This NFT does not exist in this Collection.")
      emit Withdraw(id: nft.id, from: self.owner?.address)
      return <- nft
    }

    pub fun deposit(token: @NonFungibleToken.NFT) {
      let nft <- token as! @NFT
      emit Deposit(id: nft.id, to: self.owner?.address)
      self.ownedNFTs[nft.id] <-! nft
    }

    pub fun getIDs(): [UInt64] {
      return self.ownedNFTs.keys
    }

    pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
      return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
    }

    pub fun borrowAuthNFT(id: UInt64): &CryptoPets.NFT {
      return (&self.ownedNFTsMetadata[id] as &CryptoPets.NFT?)!
    }

    init() {
      self.ownedNFTs <- {}
      self.ownedNFTsMetadata <- {}
    }

    destroy() {
      destroy self.ownedNFTs
      destroy self.ownedNFTsMetadata
    }
  }

  pub fun createEmptyCollection(): @NonFungibleToken.Collection {
    return <- create Collection()
  }

  pub resource Minter {
    pub fun createNFT(petName: String, petType: String, petAge: Int): @NFT {
      return <- create NFT(_petName: petName, _petType: petType, _petAge: petAge)
    }

    pub fun createMinter(): @Minter {
      return <- create Minter()
    }
  }

  init() {
    self.totalSupply = 0
    emit ContractInitialized()
    self.account.save(<- create Minter(), to: /storage/Minter)
  }
}
