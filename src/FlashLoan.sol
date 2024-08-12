// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {IFlashLoanSimpleReceiver} from "@aave-v3/contracts/flashloan/interfaces/IFlashLoanSimpleReceiver.sol";
// import {IFlashLoanReceiver} from "@aave-v3/contracts/flashloan/interfaces/IFlashLoanReceiver.sol";
import {FlashLoanSimpleReceiverBase} from "@aave-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";

import {IPoolAddressesProvider} from "@aave-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IPool} from "@aave-v3/contracts/interfaces/IPool.sol";
import {IERC20} from "@aave-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract FlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner;

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "FlashLoan: Not Owner");
        _;
    }
    // function ADDRESSES_PROVIDER() external  view returns (IPoolAddressesProvider) {}

    // function POOL() external  view returns (IPool) {}

    /*
     * @notice Executes an operation after receiving the flash-borrowed asset
     * @dev Ensure that the contract can return the debt + premium, e.g., has
     *      enough funds to repay and has approved the Pool to pull the total amount
     * @param asset The address of the flash-borrowed asset
     * @param amount The amount of the flash-borrowed asset
     * @param premium The fee of the flash-borrowed asset
     * @param initiator The address of the flashloan initiator
     * @param params The byte-encoded params passed when initiating the flashloan
     * @return True if the execution of the operation succeeds, false otherwise
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address, /*initiator */
        bytes calldata /*params */
    ) external override returns (bool) {
        uint256 amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);

        return true;
    }

    function requestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }

    function getBalance(address _asset, address user) public view returns (uint256) {
        return IERC20(_asset).balanceOf(address(user));
    }

    function withdraw(address _asset) external onlyOwner {
        if (_asset == address(0)) {
            uint256 ethBalance = address(this).balance;
            require(ethBalance > 0, "FlashLoan: No ETH balance");
            (bool success,) = owner.call{value: ethBalance}("");
            require(success, "FlashLoan: ETH withdraw failed");
        } else {
            uint256 assetBalance = IERC20(_asset).balanceOf(address(this));
            IERC20(_asset).approve(owner, assetBalance);
            IERC20(_asset).transfer(owner, assetBalance);
        }
    }

    function updateOwner(address _newOwner) external onlyOwner {
        owner = payable(_newOwner);
    }

    receive() external payable {}
}
