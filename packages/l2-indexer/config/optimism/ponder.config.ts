import { config } from 'dotenv'
import { createConfig } from '@ponder/core'
import { http } from 'viem'

import {
  ENSRegistry,
  ETHRegistrarController,
  NameWrapper,
  PublicResolver,
} from '../../abis'

config({
  path: process.env.ENV_FILE || '../../.env',
})

export default createConfig({
  database: {
    kind: 'postgres',
    connectionString: process.env.DATABASE_URL,
    schema: 'public',
  },
  networks: {
    optimism_sepolia: {
      chainId: 42069,
      transport: http(process.env.RPC_URL),
      pollingInterval: parseInt(process.env.POOL_INTERVAL || '1000'),
      maxRequestsPerSecond: parseInt(process.env.MAX_REQUESTS || '50'),
    },
  },
  contracts: {
    ENSRegistry: {
      abi: ENSRegistry,
      network: {
        optimism_sepolia: {
          address: '0x28848853CED9B5f5702E7995471514A4b751d25d',
          startBlock: 25821258,
        },
      },
    },
    ETHRegistrarController: {
      abi: ETHRegistrarController,
      network: {
        optimism_sepolia: {
          address: '0x47426cC33E8330eD7488eE871f31880202a12254',
          startBlock: 25822324,
        },
      },
    },
    NameWrapper: {
      abi: NameWrapper,
      network: {
        optimism_sepolia: {
          address: '0xfa304291C0e3B45b57e6205bfD48B50c6f1C2CEB',
          startBlock: 25822130,
        },
      },
    },
    PublicResolver: {
      abi: PublicResolver,
      network: {
        optimism_sepolia: {
          address: '0x3fb3230d65DA8F2Ce71B1b7c5C9E56bdFfC2c40a',
          startBlock: 25906233,
        },
      },
    },
  },
})
