import { useState, useEffect } from "react";
import { useWriteContract, useReadContract, useAccount } from "wagmi";
import { parsePrice } from "../lib/utils/format";
import { TOKEN_ADDRESS } from "../config/contracts";
import { Card } from "./ui/Card";
import { Button } from "./ui/Button";
import { TOKEN_ABI } from "../config/abis";

export function MintForm() {
  const [address, setAddress] = useState("");
  const [amount, setAmount] = useState("");
  const [isOwner, setIsOwner] = useState(false);

  const { address: connectedAddress } = useAccount();
  const { data: owner } = useReadContract({
    address: TOKEN_ADDRESS,
    abi: TOKEN_ABI,
    functionName: "owner",
  });

  const { writeContract: mint, isPending: isMinting } = useWriteContract();

  useEffect(() => {
    if (connectedAddress && owner) {
      setIsOwner(connectedAddress === owner);
    }
  }, [connectedAddress, owner]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!address || !amount) return;

    if (!address.match(/^0x[0-9a-fA-F]{40}$/)) {
      alert("Invalid address format");
      return;
    }

    mint({
      abi: TOKEN_ABI,
      address: TOKEN_ADDRESS,
      functionName: "mint",
      args: [address as `0x${string}`, parsePrice(amount)],
    });
  };

  return (
    <Card title="Mint Tokens">
      {isOwner ? (
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label
              htmlFor="address"
              className="block text-sm font-medium text-gray-700"
            >
              Recipient Address
            </label>
            <input
              type="text"
              id="address"
              value={address}
              onChange={(e) => setAddress(e.target.value)}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              placeholder="0x..."
              required
            />
          </div>
          <div>
            <label
              htmlFor="amount"
              className="block text-sm font-medium text-gray-700"
            >
              Amount
            </label>
            <input
              type="number"
              id="amount"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              min="0"
              step="0.000000000000000001"
              required
            />
          </div>
          <Button type="submit" disabled={isMinting}>
            {isMinting ? "Minting..." : "Mint"}
          </Button>
        </form>
      ) : (
        <p className="text-red-500 text-center font-medium">
          Only the contract owner can mint tokens.
        </p>
      )}
    </Card>
  );
}
