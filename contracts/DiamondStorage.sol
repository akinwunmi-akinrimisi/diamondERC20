// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library DiamondStorage {
    struct DiamondStorage {
        mapping(bytes4 => address) facets; // function selector to facet address
    }

    bytes32 constant DIAMOND_STORAGE_POSITION = keccak256("diamond.standard.diamond.storage");

    function diamondStorage() internal pure returns (DiamondStorage storage ds) {
        bytes32 position = DIAMOND_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    function setFacetAddress(bytes4 _selector, address _facet) internal {
        DiamondStorage storage ds = diamondStorage();
        ds.facets[_selector] = _facet;
    }
}
