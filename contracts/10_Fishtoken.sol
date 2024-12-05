// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FishToken is ERC20, Ownable {
    uint256 public constant WEI_PER_TOKEN = 100;

    event FishTokenInstantiated(address indexed creator);

    constructor() ERC20("FishToken", "FISH") Ownable(msg.sender) {
        emit FishTokenInstantiated(msg.sender);
        // 铸造初始供应量的代币，并将其分配给合约所有者
        _mint(msg.sender, 1000 * 10 ** decimals());

     }


    // 铸造功能，仅限合约所有者
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // 销毁功能，仅限合约所有者
    function burn(uint256 amount) external onlyOwner {
        _burn(msg.sender, amount);
    }

    // 购买功能，参与者可以用以太坊购买FishToken
    function buyTokens() external payable {
        require(msg.value > 0, "Must send some ether to buy tokens");
        uint256 tokenAmount = msg.value / WEI_PER_TOKEN;
        require(tokenAmount > 0, "Not enough ether to buy even one token");
        require(balanceOf(owner()) >= tokenAmount, "Not enough tokens available");

        // 将代币从所有者转移到购买者
        _transfer(owner(), msg.sender, tokenAmount);
    }

    // 提取合约中的以太币，仅限合约所有者
    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // 覆写以支持小数点精度
    function decimals() public pure override returns (uint8) {
        return 2; // 100 wei = 1 FishToken
    }
}
