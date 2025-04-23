# External Resolver

## Overview

The Ethereum Name Service (ENS) has revolutionized the way we interact with the blockchain by replacing complex addresses with human-readable domain names like "myname.eth". However, ENS faces scalability and cost challenges that hinder its widespread adoption. The External Resolver project offers an innovative solution to overcome these obstacles by combining established patterns such as ERC-3668, EIP-5559, ENSIP-10, and ENSIP-16.

At its core, a "resolver" is a crucial component of ENS that translates human-readable domain names into relevant blockchain information, such as wallet addresses, public keys, and custom records. The "resolution" process is fundamental for making domain names usable in decentralized applications (dApps) and wallets.

The External Resolver takes the concept of resolution further by allowing ENS data to be stored and managed off-chain. This drastically reduces transaction costs, improves network scalability, and enables more advanced features like larger and more complex data records.

This project not only makes ENS more efficient and cost-effective but also opens up a world of possibilities for developers and users, expanding the potential of ENS as a foundational infrastructure for Web3. By providing a comprehensive reference implementation for off-chain storage and management, the External Resolver empowers the community to innovate and build upon the ENS ecosystem.

## Objectives

- **Enhance Scalability**: Improve ENS scalability for broader adoption.
- **Cost-Effectiveness**: Lower costs for ENS users.
- **Increase Usability**: Make ENS more user-friendly and accessible.
- **Reference implementation**: Create a reference on how to implement off-chain storage and management.

## Deployments

### Mainnet

| Contract         | Network  | Address                                                                                                               |
| ---------------- | -------- | --------------------------------------------------------------------------------------------------------------------- |
| DatabaseResolver | Ethereum | [0xBF3F57862717099319285c1E2664Cd583f35E333](https://etherscan.io/address/0xBF3F57862717099319285c1E2664Cd583f35E333) |

### Sepolia

| Contract                    | Network  | Address                                                                                                                                |
| --------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| DatabaseResolver            | Ethereum | [0x7dc07bc3a73e6b3d231dcf1b6f23ed20cb12132c](https://sepolia.etherscan.io/address/0x7dc07bc3a73e6b3d231dcf1b6f23ed20cb12132c)          |
|                             |          |                                                                                                                                        |
| Arb Verifier                | Ethereum | [0x8fc4a214705e3c40032e99f867d964c012bf8efb](https://sepolia.etherscan.io/address/0x8fc4a214705e3c40032e99f867d964c012bf8efb)          |
| Arb L1Resolver              | Ethereum | [0x029928615ffc0cb209747acc9c6eb4c504b527f6](https://sepolia.etherscan.io/address/0x029928615ffc0cb209747acc9c6eb4c504b527f6)          |
| ENSRegistry                 | Arbitrum | [0x8d55e297c37993ebbd2e7a8d7688f7e5b35f1b50](https://sepolia.arbiscan.io/address/0x8d55e297c37993ebbd2e7a8d7688f7e5b35f1b50)           |
| ReverseRegistrar            | Arbitrum | [0xb3c9ff08671bbadddd0436cc46fbfa005c8da0a7](https://sepolia.arbiscan.io/address/0xb3c9ff08671bbadddd0436cc46fbfa005c8da0a7)           |
| BaseRegistrarImplementation | Arbitrum | [0x2C6a113C513fa0fd404abcCE3aC8a4BE16ccb651](https://sepolia.arbiscan.io/address/0x2C6a113C513fa0fd404abcCE3aC8a4BE16ccb651)           |
| NameWrapper                 | Arbitrum | [0xff4f34ac12a84de527cf9e24856fc8d7c42cc379](https://sepolia.arbiscan.io/address/0xff4f34ac12a84de527cf9e24856fc8d7c42cc379)           |
| ETHRegistrarController      | Arbitrum | [0x263c644d8f5d4bdb44cfab020491ec6fc4ca5271](https://sepolia.arbiscan.io/address/0x263c644d8f5d4bdb44cfab020491ec6fc4ca5271)           |
| SubdomainController         | Arbitrum | [0x2c5bec2d955d5d15be98df0a0b3b00611d49fa9a](https://sepolia.arbiscan.io/address/0x2c5bec2d955d5d15be98df0a0b3b00611d49fa9a)           |
| PublicResolver              | Arbitrum | [0x0a33f065c9c8f0F5c56BB84b1593631725F0f3af](https://sepolia.arbiscan.io/address/0x0a33f065c9c8f0F5c56BB84b1593631725F0f3af)           |
|                             |          |                                                                                                                                        |
| OP Verifier                 | Ethereum | [0x5F1681D608e50458D96F43EbAb1137bA1d2A2E4D](https://sepolia-optimism.etherscan.io/address/0x5F1681D608e50458D96F43EbAb1137bA1d2A2E4D) |
| OP L1Resolver               | Ethereum | [0x6291D6ceAFFaBf2e6AFB1D626aDAe1d76BFE11fa](https://sepolia-optimism.etherscan.io/address/0x6291D6ceAFFaBf2e6AFB1D626aDAe1d76BFE11fa) |
| ENSRegistry                 | Optimism | [0x28848853CED9B5f5702E7995471514A4b751d25d](https://sepolia-optimism.etherscan.io/address/0x28848853CED9B5f5702E7995471514A4b751d25d) |
| ReverseRegistrar            | Optimism | [0x72CD87Ee0F151072A5D265fd7093d7FBa13Abc47](https://sepolia-optimism.etherscan.io/address/0x72CD87Ee0F151072A5D265fd7093d7FBa13Abc47) |
| BaseRegistrarImplementation | Optimism | [0x72CB51fBF9fa715AC7004b33c001385De28Ed504](https://sepolia-optimism.etherscan.io/address/0x72CB51fBF9fa715AC7004b33c001385De28Ed504) |
| NameWrapper                 | Optimism | [0xfa304291C0e3B45b57e6205bfD48B50c6f1C2CEB](https://sepolia-optimism.etherscan.io/address/0xfa304291C0e3B45b57e6205bfD48B50c6f1C2CEB) |
| ETHRegistrarController      | Optimism | [0x47426cC33E8330eD7488eE871f31880202a12254](https://sepolia-optimism.etherscan.io/address/0x47426cC33E8330eD7488eE871f31880202a12254) |
| SubdomainController         | Optimism | [0x2CcbbeeD213907B24085e486c799c358d31283ff](https://sepolia-optimism.etherscan.io/address/0x2CcbbeeD213907B24085e486c799c358d31283ff) |
| PublicResolver              | Optimism | [0x3fb3230d65DA8F2Ce71B1b7c5C9E56bdFfC2c40a](https://sepolia-optimism.etherscan.io/address/0x3fb3230d65DA8F2Ce71B1b7c5C9E56bdFfC2c40a) |

## Components

The External Resolver consists of three main components, each of them is a self-contained project with its own set of files and logic, ensuring seamless integration and collaboration between them. This modular architecture allows for flexibility and customization, making the External Resolver a versatile solution for various use cases.

### Gateway

The Gateway serves as the bridge between the blockchain and external data sources. It follows the EIP-3668 specification to fetch data from off-chain storage and relays it back to the client. The Gateway ensures secure and efficient communication between the different components of the system.

### Contracts

The smart contracts are the backbone of the External Resolver. They include the L1 Resolver, which redirects requests to external resolvers, the L2 Resolver Contract, which handles the actual resolution of domain names on Layer 2 networks and more. These contracts are designed to be modular and adaptable, allowing for deployment on various EVM-compatible chains.

#### Database Resolver

#### L1 Resolver

A smart contract that redirects requests to specified external contract deployed to any EVM compatible protocol.

#### L2 Resolver

An L2 contract capable of resolving ENS domains to corresponding addresses and fetching additional information fully compatible with the [ENS' Public Resolver](https://docs.ens.domains/resolvers/public) but responsible for authentication.

### Client

The client acts as the interface between the user and the Blockchain. It handles requests for domain resolution and interacts with the Gateway to retrieve the necessary information.

Sample interaction with the Database Resolver:

```ts
try {
    await client.simulateContract({
      functionName: 'register',
      abi: dbAbi,
      args: [toHex(name), 300],
      account: signer.address,
      address: resolverAddr,
    })
  } catch (err) {
    const data = getRevertErrorData(err)
    if (data?.errorName === 'OperationHandledOffchain') {
      const [domain, url, message] = data.args as [
        DomainData,
        string,
        MessageData,
      ]
      await handleDBStorage({ domain, url, message, signer })
    } else {
      console.error('writing failed: ', { err })
    }
}
```

Sample interaction with the Layer 1 Resolver:

```ts
const calldata = {
  functionName: 'setText',
  abi: l1Abi,
  args: [namehash(name), 'com.twitter', '@blockful'],
  address: resolverAddr,
}
try {
    await client.simulateContract(calldata)
  } catch (err) {
    const data = getRevertErrorData(err)
    if (data?.errorName === 'OperationHandledOnchain') {
      const [chainId, contractAddress] = data.args as [bigint, `0x${string}`]

      await handleL2Storage({
        chainId,
        l2Url: providerL2,
        args: {
          ...calldata,
          address: contractAddress,
          account: signer,
        },
      })
    } else if (data) {
      console.error('error setting text: ', data.errorName)
    } else {
      console.error('error setting text: ', { err })
    }
}
```

## Usage

To run the External Resolver project in its entirety, you'll need to complete the installation process. Since we provide an off-chain resolver solution, it's essential to set up both the database and the Arbitrum Layer 2 environment. This will enable you to run comprehensive end-to-end tests and verify the functionality of the entire project.

### Prerequisites

- [Foundry](https://book.getfoundry.sh)
  - Run local node by calling `anvil`

### Setup

1. Clone this repository to your local machine.
2. Copy the `env.example` file to `.env` in the root directory.
3. Install dependencies: `npm install`
4. Build the contracts: `npm run build`

#### Database Setup

1. Run a local PostgreSQL instance (no initial data is inserted):

    ```shell
    docker-compose up db -d
    ```

2. Deploy the contracts locally:

    ```bash
    npm run contracts dev:db
    ```

3. Start the gateway:

    ```bash
    npm run gateway dev:db
    ```

4. Write properties to a given domain:

    ```bash
      npm run client start:write:db
    ```

5. Request domain properties through the client:

    ```bash
    npm run client read
    ```

##### Migrations

This repository relies on migrations to manage the database schema. To create a new migration, run the following command:

```bash
npm run gateway migration:create --name=<migration_name>
```

To apply the migration, run the following command:

```bash
npm run migration:generate -- -n <migration_name>
```

#### Layer 2 Setup

1. Deploy the contracts to the local Arbitrum node (follow the [Arbitrum's local node setup tutorial](https://docs.arbitrum.io/run-arbitrum-node/run-local-dev-node)):

    ```bash
    npm run contracts dev:arb:l2
    ```

2. Gather the contract address from the terminal and add it [here](https://github.com/blockful-io/external-resolver/blob/main/packages/contracts/script/local/L1ArbitrumResolver.s.sol#L56) so the L1 domain gets resolved by the L2 contract you just deployed.

3. Start the gateway:

    ```bash
    npm run gateway dev:arb
    ```

4. Request domain properties through the client:

    ```bash
    npm run client start
    ```

## Deployment

### Gateway

Ensure you have the [Railway CLI](https://docs.railway.app/guides/cli) installed.

1. Install the Railway CLI:

    ```bash
    npm i -g @railway/cli
    ```

2. Log in to your Railway account:

    ```bash
    railway login
    ```

3. Link the repo to the project:

    ```bash
    railway link
    ```

4. Deploy the Gateway:

    ```bash
    railway up
    ```

### Contracts

1. `npm run contracts deploy:db -- --rpc-url <RPC_URL>`

## Architecture

### High-Level Overview

#### Database

![Database Architecture](https://github.com/blockful-io/external-resolver/assets/29408363/02882939-dd54-4fa7-a268-a817403ddd2d)

#### Layer 2

![Layer 2 Architecture](https://github.com/blockful-io/external-resolver/assets/29408363/48306561-59b4-4ab7-b920-b9a8f50cb325)

### Flowchart overview

#### Database

Domain Register and data writing:

1. Find the resolver associated with the given domain through the Universal Resolver
2. Call the `register` function on the resolver
3. Client receive a `StorageHandledByDB` revert with the arguments required to call the gateway
4. Sign the request with the given arguments using the EIP-712
5. Call the gateway on endpoint `/{sender}/{data}.json` as specified by the EIP-3668
6. Gateway validates the signer and create a new entry on the database for this domain

![domain register and data writing](https://github.com/blockful-io/external-resolver/assets/29408363/3264acdd-1d0b-4ad0-ad60-f6d910480534)

Reading domain properties:

1. Call the `resolver` function on the Universal Resolver passing the reading method in an encoded format as argument
2. Client receive the `OffchainLookup` revert with the required arguments to call the gateway
3. Client calls the gateway on endpoint `/{sender}/{data}.json` as specified by the EIP-3668
4. Gateway reads the data and sign it using it's own private key which as previously marked as authorized on the Database Resolver
5. Client calls the callback function with the gateway signed response and extra data from the Database Resolver
6. The Database Resolver contract validates the signature came from an authorized source and decode de data
7. Data is returned to the client

![reading domain properties](https://github.com/blockful-io/external-resolver/assets/29408363/4e7f7b6e-dbcb-489c-9468-1a107b735f8d)

#### Layer 2

Domain Register:

1. Find the resolver associated with the given domain through the Universal Resolver
2. Call the `register` function on the resolver passing the address of the Layer 2 resolver that will be managing the properties of a given domain
3. Client calls `setOwner` on the L1 Resolver
4. Client receive a `OperationHandledOnchain` revert with the arguments required to call the gateway
5. Client calls the L2 Resolver with the returned arguments

![domain register](https://github.com/blockful-io/external-resolver/assets/29408363/1ef65db2-a979-4e2f-bb9f-7dde0769fae4)

## Conclusion

This project aims to significantly enhance the scalability and usability of the Ethereum Name Service through the development of a comprehensive reference codebase. By combining existing patterns and best practices, we aim to lower costs for users and drive increased adoption within the industry. We welcome collaboration and feedback from the community as we progress towards our goals.

## Contributing

We welcome contributions from the community to improve this project. To contribute, please follow these guidelines:

1. Fork the repository and create a new branch for your feature or bug fix.
2. Make your changes and ensure they follow the project's coding conventions.
3. Test your changes locally to ensure they work as expected.
4. Create a pull request with a detailed description of your changes.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgements

Special thanks to the Ethereum Name Service (ENS) community for their contributions and support.
