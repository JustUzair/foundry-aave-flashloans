// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IERC20} from "@aave-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {IPool} from "@aave-v3/contracts/interfaces/IPool.sol";

import {FlashLoan} from "../src/FlashLoan.sol";

contract FlashLoanTest is Test {
    FlashLoan flashLoan;
    HelperConfig helperConfig;
    string ethSepoliaRPCUrl = "https://ethereum-sepolia-rpc.publicnode.com/";
    uint256 networkFork;
    address wallet = address(0xA72e562f24515C060F36A2DA07e0442899D39d2c);
    address usdcAddress;
    address poolAddressProvider;
    address daiAddress;

    function setUp() public {
        networkFork = vm.createSelectFork(ethSepoliaRPCUrl);
        vm.selectFork(networkFork);
        vm.allowCheatcodes(address(this));
        vm.allowCheatcodes(wallet);
        helperConfig = new HelperConfig();
        (, usdcAddress, daiAddress, poolAddressProvider) = helperConfig.activeNetworkConfig();
        vm.allowCheatcodes(address(helperConfig));
        vm.allowCheatcodes(address(poolAddressProvider));
        vm.allowCheatcodes(address(usdcAddress));
        vm.allowCheatcodes(address(daiAddress));
        vm.startPrank(wallet);
        console.log("### FORKING ETH SEPOLIA ###");
        console.log("Sepolia RPC URL : ", ethSepoliaRPCUrl);
        // chain Id
        console.log("Chain ID : ", block.chainid);
        // networkFork = vm.createSelectFork(ethSepoliaRPCUrl);

        console.log("Pool Address Provider : ", poolAddressProvider);
        console.log("USDC Address : ", usdcAddress);
        console.log("DAI Address : ", daiAddress);

        flashLoan = new FlashLoan(poolAddressProvider);
        console.log("FlashLoan contract deployed at address: ", address(flashLoan));
        vm.allowCheatcodes(address(flashLoan));

        vm.stopPrank();
    }

    function test_walletHasTokensForCollateral() public {
        vm.startPrank(wallet);
        uint256 usdcBalance = flashLoan.getBalance(usdcAddress, wallet);
        uint256 daiBalance = flashLoan.getBalance(daiAddress, wallet);
        console.log("USDC Balance : ", usdcBalance / 1e6);
        console.log("DAI Balance : ", daiBalance / 1e18);
        assert(usdcBalance > 0);
        assert(daiBalance > 0);
        vm.stopPrank();
    }

    modifier depositDaiCollateral() {
        vm.startPrank(wallet);
        address poolAddress = address(flashLoan.POOL());
        IERC20(daiAddress).approve(poolAddress, 1000 * 1e18);
        IPool(poolAddress).deposit(daiAddress, 1000 * 1e18, wallet, 1);

        vm.stopPrank();
        _;
    }

    function test_simpleFlashLoanDAI() public {
        vm.startPrank(wallet);

        IERC20(daiAddress).approve(address(flashLoan), 3 * 1e18);
        IERC20(daiAddress).transfer(address(flashLoan), 3 * 1e18);

        assertEq(flashLoan.getBalance(daiAddress, address(flashLoan)), 3 * 1e18);
        flashLoan.requestFlashLoan(daiAddress, 1 * 1e18);
        vm.stopPrank();
    }

    function test_simpleFlashLoanUSDC() public {
        vm.startPrank(wallet);

        IERC20(usdcAddress).approve(address(flashLoan), 3 * 1e6);
        IERC20(usdcAddress).transfer(address(flashLoan), 3 * 1e6);

        assertEq(flashLoan.getBalance(usdcAddress, address(flashLoan)), 3 * 1e6);
        flashLoan.requestFlashLoan(usdcAddress, 1 * 1e6);
        vm.stopPrank();
    }
}
