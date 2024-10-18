// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/LibERC20Storage.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract ERC20Facet is Context {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function name() external view returns (string memory) {
        return LibERC20Storage.erc20Storage().name;
    }

    function symbol() external view returns (string memory) {
        return LibERC20Storage.erc20Storage().symbol;
    }

    function decimals() external view returns (uint8) {
        return LibERC20Storage.erc20Storage().decimals;
    }

    function totalSupply() external view returns (uint256) {
        return LibERC20Storage.erc20Storage().totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return LibERC20Storage.erc20Storage().balances[account];
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return LibERC20Storage.erc20Storage().allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), LibERC20Storage.erc20Storage().allowances[sender][_msgSender()] - amount);
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        LibERC20Storage.ERC20Storage storage ds = LibERC20Storage.erc20Storage();
        require(ds.balances[sender] >= amount, "ERC20: transfer amount exceeds balance");

        ds.balances[sender] -= amount;
        ds.balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        LibERC20Storage.erc20Storage().allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
