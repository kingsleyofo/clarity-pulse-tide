import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

// [Previous tests remain unchanged]

Clarinet.test({
  name: "Ensure input validation works correctly",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    
    // Test short title
    let result = chain.callPublic("pulse-tide", "create-event", [
      types.ascii("Te"),
      types.ascii("Test Description")
    ], deployer.address);
    result.result.expectErr().expectUint(106);
    
    // Test short description
    result = chain.callPublic("pulse-tide", "create-event", [
      types.ascii("Test Event"),
      types.ascii("Short")
    ], deployer.address);
    result.result.expectErr().expectUint(106);
  },
});

// [Add more test cases]
