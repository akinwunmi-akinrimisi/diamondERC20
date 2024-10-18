// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/LibERC20Storage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20OwnershipFacet is Ownable {

    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);

    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "ERC20: mint to the zero address");

        LibERC20Storage.ERC20Storage storage ds = LibERC20Storage.erc20Storage();
        ds.totalSupply += amount;
        ds.balances[to] += amount;

        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        require(from != address(0), "ERC20: burn from the zero address");

        LibERC20Storage.ERC20Storage storage ds = LibERC20Storage.erc20Storage();
        require(ds.balances[from] >= amount, "ERC20: burn amount exceeds balance");

        ds.balances[from] -= amount;
        ds.totalSupply -= amount;

        emit Burn(from, amount);
        emit Transfer(from, address(0), amount);
    }
}
