# Ethernaut levels using Foundry

- This repo initially use this foundry [template](https://github.com/abigger87/femplate) (It's a cool one, make sure you check it).
- Make sure you have [foundry](https://book.getfoundry.sh/getting-started/installation.html) installed.

## Getting Started

1. Clone this repo and `cd` inside the cloned directory
2. Run `yarn install`
3. Run `yarn setup`
4. Run `forge build` to compile all contracts
5. Run `forge test` to run all tests (levels exploit)

### How To Play
- Each level is inside the `src` dir
- Each level exploit is inside the `test` dir
- Each level is composed of Factory contract and the level contract (e.g `FallbackFactory.sol` and `Fallback.sol`)
- To deploy a new level instance 
 - Deploy `Ethernaut.sol`
 - Deploy an instance of the level factory (e.g `FallbackFactory.sol`)
 - Register the level factory in `Ethernaut.sol` by calling `registerLevel()`
 - Create a new level instance by calling `createLevelInstance()` in `Ethernaut.sol`
 - Assign the level contract to the new created address
 - At the end of your exploit, call `submitLevelInstance()` in `Ethernaut.sol` giving the level instance address as arg, it should return true to complete the level
 - If you are confused, please take a loot at [setUp()](/test/FallbackTest.t.sol) for level setup and [testExploit()](/test/FallbackTest.t.sol) for exploit and level submission


#### Configure Foundry

Using [foundry.toml](./foundry.toml), Foundry is easily configurable.

For a full list of configuration options, see the Foundry [configuration documentation](https://github.com/gakonst/foundry/blob/master/config/README.md#all-options).