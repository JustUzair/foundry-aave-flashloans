// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 deployerKey;
        address usdcAddress;
        address daiAddress;
        address poolAddressProvider;
    }

    NetworkConfig public activeNetworkConfig;
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    constructor() {
        /* Activate Mainnet Configs */

        if (block.chainid == 1) {
            activeNetworkConfig = getEthMainnetConfig();
        } else if (block.chainid == 137) {
            activeNetworkConfig = getPolygonMainnetConfig();
        } else if (block.chainid == 8453) {
            activeNetworkConfig = getBaseMainnetConfig();
        } else if (block.chainid == 10) {
            activeNetworkConfig = getOptimismMainnetConfig();
        }
        /* Activate Testnet Configs */
        else if (block.chainid == 11155111) {
            activeNetworkConfig = getEthSepoliaConfig();
        } else if (block.chainid == 80002) {
            activeNetworkConfig = getPolygonAmoyConfig();
        } else if (block.chainid == 11155420) {
            activeNetworkConfig = getOptimismSepoliaConfig();
        } else if (block.chainid == 84532) {
            activeNetworkConfig = getBaseSepoliaConfig();
        }
        /* Activate Local Testnet Config */
        else if (block.chainid == 31337) {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    /**
     * Testnet Configs
     */
    function getPolygonAmoyConfig() public view returns (NetworkConfig memory polygonMumbaiNetworkConfig) {
        polygonMumbaiNetworkConfig = NetworkConfig({
            deployerKey: vm.envUint("PRIVATE_KEY"),
            usdcAddress: address(0x41E94Eb019C0762f9Bfcf9Fb1E58725BfB0e7582),
            daiAddress: address(0),
            poolAddressProvider: address(0)
        });
    }

    function getOptimismSepoliaConfig() public view returns (NetworkConfig memory optimismSepoliaConfig) {
        optimismSepoliaConfig = NetworkConfig({
            deployerKey: vm.envUint("PRIVATE_KEY"),
            usdcAddress: address(0x5fd84259d66Cd46123540766Be93DFE6D43130D7),
            daiAddress: address(0),
            poolAddressProvider: address(0x36616cf17557639614c1cdDb356b1B83fc0B2132)
        });
    }

    function getBaseSepoliaConfig() public view returns (NetworkConfig memory baseSepoliaConfig) {
        baseSepoliaConfig = NetworkConfig({
            deployerKey: vm.envUint("PRIVATE_KEY"),
            usdcAddress: address(0x036CbD53842c5426634e7929541eC2318f3dCF7e),
            daiAddress: address(0),
            poolAddressProvider: address(0xd449FeD49d9C443688d6816fE6872F21402e41de)
        });
    }

    function getOrCreateAnvilConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            deployerKey: DEFAULT_ANVIL_PRIVATE_KEY,
            usdcAddress: address(0),
            daiAddress: address(0),
            poolAddressProvider: address(0)
        });
    }

    function getEthSepoliaConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            deployerKey: vm.envUint("PRIVATE_KEY"),
            usdcAddress: address(0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8),
            daiAddress: address(0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357),
            poolAddressProvider: address(0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A)
        });
    }

    /**
     * Mainnet Configs
     */
    function getEthMainnetConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            deployerKey: vm.envUint("PRIVATE_KEY"),
            usdcAddress: address(0),
            daiAddress: address(0),
            poolAddressProvider: address(0)
        });
    }

    function getOptimismMainnetConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            deployerKey: vm.envUint("PRIVATE_KEY"),
            usdcAddress: address(0),
            daiAddress: address(0),
            poolAddressProvider: address(0)
        });
    }

    function getBaseMainnetConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            deployerKey: vm.envUint("PRIVATE_KEY"),
            usdcAddress: address(0),
            daiAddress: address(0),
            poolAddressProvider: address(0)
        });
    }

    function getPolygonMainnetConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            deployerKey: vm.envUint("PRIVATE_KEY"),
            usdcAddress: address(0),
            daiAddress: address(0),
            poolAddressProvider: address(0)
        });
    }
}
