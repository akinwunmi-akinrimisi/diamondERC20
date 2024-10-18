// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./facets/ERC20Facet.sol";
import "./facets/ERC20OwnershipFacet.sol";
import "./DiamondStorage.sol";

contract Diamond {
    constructor() {
        // Deploy the diamond with initial facets and configuration
    }

    fallback() external {
        address facet = DiamondStorage.diamondStorage().facets[msg.sig];
        require(facet != address(0), "Diamond: Function does not exist");
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
        }
    }
}
