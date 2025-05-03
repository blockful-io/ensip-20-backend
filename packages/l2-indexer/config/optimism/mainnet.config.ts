import { config } from 'dotenv'
import { createConfig } from '@ponder/core'
import { http } from 'viem'

import { ENSRegistry, NameWrapper, PublicResolver } from '../../abis'

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
    optimism_mainnet: {
      chainId: 10,
      transport: http(process.env.RPC_URL),
      pollingInterval: parseInt(process.env.POOL_INTERVAL || '1000'),
      maxRequestsPerSecond: parseInt(process.env.MAX_REQUESTS || '50'),
    },
  },
  contracts: {
    ENSRegistry: {
      abi: ENSRegistry,
      network: {
        optimism_mainnet: {
          address: '0x28848853CED9B5f5702E7995471514A4b751d25d',
          startBlock: 135306908,
        },
      },
    },
    NameWrapper: {
      abi: NameWrapper,
      network: {
        optimism_mainnet: {
          address: '0xFac46Cfd731aaEd4EfeB5D3F5336F2d7a2EEEEf3',
          startBlock: 135310037,
        },
      },
    },
    PublicResolver: {
      abi: PublicResolver,
      network: {
        optimism_mainnet: {
          address: '0x11bFDfbd625A6Ca9d4Ec8767f7341ff745075864',
          startBlock: 135310518,
        },
      },
    },
  },
})
