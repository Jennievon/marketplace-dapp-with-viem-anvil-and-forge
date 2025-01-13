import { createConfig } from "@ponder/core";
import { http } from "viem";
import { TOKEN_ABI, MARKETPLACE_ABI } from "./src/config/abis";
import { TOKEN_ADDRESS, MARKETPLACE_ADDRESS } from "./src/config/contracts";

export default createConfig({
  networks: {
    anvil: {
      chainId: 31337,
      transport: http("http://127.0.0.1:8545"),
    },
  },
  contracts: {
    Token: {
      network: "anvil",
      abi: TOKEN_ABI,
      address: TOKEN_ADDRESS,
      startBlock: 0,
    },
    Marketplace: {
      network: "anvil",
      abi: MARKETPLACE_ABI,
      address: MARKETPLACE_ADDRESS,
      startBlock: 0,
      events: {
        ItemListed: "ItemListed",
        ItemSold: "ItemSold",
        ItemDelisted: "ItemDelisted",
      },
    },
  },
});
