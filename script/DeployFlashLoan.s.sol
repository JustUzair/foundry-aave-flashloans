// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.25;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {console} from "forge-std/console.sol";
import {FlashLoan} from "../src/FlashLoan.sol";

contract DeployFlashLoan is Script {
    HelperConfig helperConfig;
    FlashLoan flashLoanContract;

    function run() public {
        helperConfig = new HelperConfig();
        (uint256 deployerKey, address usdcAddress, address daiAddress, address poolAddressProvider) =
            helperConfig.activeNetworkConfig();

        vm.startBroadcast(deployerKey);
        console.log("------ Deploying FlashLoan contract ------");
        flashLoanContract = new FlashLoan(poolAddressProvider);
        console.log("FlashLoan contract deployed at address: ", address(flashLoanContract));
    }
}
