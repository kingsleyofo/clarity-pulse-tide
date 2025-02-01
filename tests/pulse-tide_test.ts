import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure owner can create events",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const result = chain.callPublic("pulse-tide", "create-event", [
      types.ascii("Test Event")
    ], deployer.address);
    result.result.expectOk().expectUint(0);
  },
});

Clarinet.test({
  name: "Ensure users can submit feedback",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const user1 = accounts.get("wallet_1")!;
    
    chain.callPublic("pulse-tide", "create-event", [
      types.ascii("Test Event")
    ], deployer.address);

    const result = chain.callPublic("pulse-tide", "submit-feedback", [
      types.uint(0),
      types.uint(5)
    ], user1.address);
    
    result.result.expectOk().expectBool(true);
  },
});

Clarinet.test({
  name: "Prevent duplicate feedback",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const user1 = accounts.get("wallet_1")!;
    
    chain.callPublic("pulse-tide", "create-event", [
      types.ascii("Test Event")
    ], deployer.address);

    chain.callPublic("pulse-tide", "submit-feedback", [
      types.uint(0),
      types.uint(5)
    ], user1.address);

    const result = chain.callPublic("pulse-tide", "submit-feedback", [
      types.uint(0),
      types.uint(4)
    ], user1.address);
    
    result.result.expectErr().expectUint(102);
  },
});
