import { namehash } from 'viem'

import * as ccip from '@blockful/ccip-server'

import {
  NodeProps,
  RegisterDomainProps,
  OwnershipValidator,
  TypedSignature,
  TransferDomainProps,
  SetResolverProps,
} from '../types'
import { Domain } from '../entities'
import { decodeDNSName, extractParentFromName } from '../utils'

interface WriteRepository {
  register(params: RegisterDomainProps)
  transfer(params: TransferDomainProps)
  setResolver(params: SetResolverProps)
}

interface ReadRepository {
  getDomain(params: NodeProps): Promise<Domain | null>
}

export function withRegisterDomain(
  repo: WriteRepository & ReadRepository,
): ccip.HandlerDescription {
  return {
    type: 'register((bytes name,address owner,uint256 duration,bytes32 secret,address resolver,bytes extraData))',
    func: async (
      [[name, owner, ttl, , resolver]],
      { signature }: { signature: TypedSignature },
    ) => {
      try {
        name = decodeDNSName(name)
        const node = namehash(name)

        const existingDomain = await repo.getDomain({ node })
        if (existingDomain) {
          return { error: { message: 'Domain already exists', status: 400 } }
        }

        await repo.register({
          name,
          node,
          ttl: ttl.toString(),
          owner,
          parent: namehash(extractParentFromName(name)),
          resolver,
          resolverVersion: signature.domain.version,
        })
      } catch (err) {
        return {
          error: { message: 'Unable to register new domain', status: 400 },
        }
      }
    },
  }
}

export function withTransferDomain(
  repo: WriteRepository,
  validator: OwnershipValidator,
): ccip.HandlerDescription {
  return {
    type: 'transfer(bytes32 node, address owner)',
    func: async (
      { node, owner },
      { signature }: { signature: TypedSignature },
    ) => {
      try {
        const isOwner = await validator.verifyOwnership({
          node,
          signature,
        })
        if (!isOwner) {
          return { error: { message: 'Unauthorized', status: 401 } }
        }
        await repo.transfer({ node, owner })
      } catch (err) {
        return {
          error: { message: 'Unable to transfer domain', status: 400 },
        }
      }
    },
  }
}

export function withSetResolver(
  repo: WriteRepository,
  validator: OwnershipValidator,
): ccip.HandlerDescription {
  return {
    type: 'setResolver(bytes32 node, address resolver)',
    func: async (
      { node, resolver },
      { signature }: { signature: TypedSignature },
    ) => {
      const isOwner = await validator.verifyOwnership({
        node,
        signature,
      })
      if (!isOwner) {
        return { error: { message: 'Unauthorized', status: 401 } }
      }
      await repo.setResolver({ node, resolver })
    },
  }
}
