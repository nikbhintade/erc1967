// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

import {BoxV1} from "src/BoxV1.sol";
import {BoxV2} from "src/BoxV2.sol";

contract UpgradeBox is Script {
    function run() external returns (address proxy) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();

        BoxV2 newBox = new BoxV2();

        vm.stopBroadcast();

        proxy = upgradeBox(mostRecentlyDeployed, address(newBox));
    }

    function upgradeBox(address proxyAddress, address newBox) public returns (address) {
        vm.startBroadcast();
        BoxV1 proxy = BoxV1(proxyAddress);

        proxy.upgradeToAndCall(address(newBox), "");
        vm.stopBroadcast();

        return address(proxy);
    }
}
