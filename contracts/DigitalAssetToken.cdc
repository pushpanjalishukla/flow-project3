// File: DigitalAssetToken.cdc

pub contract interface DigitalAssetToken {
    pub var totalAssets: UInt64

    pub event ContractInitialized()
    pub event AssetWithdrawn(id: UInt64, from: Address?)
    pub event AssetDeposited(id: UInt64, to: Address?)

    pub resource interface IAsset {
        pub let id: UInt64
    }

    pub resource Asset: IAsset {
        pub let id: UInt64
    }

    pub resource interface Provider {
        pub fun withdraw(withdrawID: UInt64): @Asset {
            post {
                result.id == withdrawID: "The ID of the withdrawn asset must be the same as the requested ID"
            }
        }
    }

    pub resource interface Receiver {
        pub fun deposit(asset: @Asset)
    }

    pub resource interface CollectionPublic {
        pub fun deposit(asset: @Asset)
        pub fun getIDs(): [UInt64]
        pub fun borrowAsset(id: UInt64): &Asset {
            pre {
                self.ownedAssets[id] != nil: "Asset does not exist in the collection!"
            }
        }
    }

    pub resource Collection: Provider, Receiver, CollectionPublic {
        pub var ownedAssets: @{UInt64: Asset}

        pub fun withdraw(withdrawID: UInt64): @Asset
        pub fun deposit(asset: @Asset)
        pub fun getIDs(): [UInt64]
        pub fun borrowAsset(id: UInt64): &Asset {
            pre {
                self.ownedAssets[id] != nil: "Asset does not exist in the collection!"
            }
        }
    }

    pub fun createEmptyCollection(): @Collection {
        post {
            result.getIDs().length == 0: "The created collection must be empty!"
        }
    }
}
