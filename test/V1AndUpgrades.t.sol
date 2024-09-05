// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2 as console} from "forge-std/Test.sol";

import {DeployBox} from "script/DeployBox.s.sol";
import {UpgradeBox} from "script/UpgradeBox.s.sol";

import {BoxV1} from "src/BoxV1.sol";
import {BoxV2} from "src/BoxV2.sol";

contract V1AndUpgrades is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;

    address public proxy;

    function setUp() external {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();

        proxy = deployer.run();
    }

    function testProxyVersionIsCorrect() public view {
        uint256 actualVersion = BoxV1(proxy).version();
        uint256 expectedVersion = uint256(1);

        vm.assertEq(actualVersion, expectedVersion);
    }

    function testUpgradesToCorrectVersion() public {
        BoxV2 boxV2 = new BoxV2();
        upgrader.upgradeBox(proxy, address(boxV2));

        uint256 actualVersion = BoxV2(proxy).version();
        uint256 expectedVersion = uint256(2);

        vm.assertEq(actualVersion, expectedVersion);
    }
}
