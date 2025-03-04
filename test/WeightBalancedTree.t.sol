// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/WeightBalancedTree.sol";

contract WeightBalancedTreeTest is Test {
    using WeightBalancedTree for WeightBalancedTree.Tree;
    WeightBalancedTree.Tree private tree;

    function setUp() public {
        // Initialize empty tree
    }

    function testInsertSingleNode() public {
        tree.insert(1, 100);
        assertEq(tree.weightSum(), 100);
    }

    function testInsertMultipleNodes() public {
        tree.insert(1, 100);
        tree.insert(2, 50);
        tree.insert(3, 75);
        assertEq(tree.weightSum(), 225);
    }

    function testRemoveNode() public {
        tree.insert(1, 100);
        tree.insert(2, 50);

        bool removed = tree.remove(1);
        assertTrue(removed);
        assertEq(tree.weightSum(), 50);

        // Try removing non-existent node
        removed = tree.remove(999);
        assertFalse(removed);
    }

    function testUpdateWeight() public {
        tree.insert(1, 100);

        bool updated = tree.update(1, 150);
        assertTrue(updated);
        assertEq(tree.weightSum(), 150);

        // Try updating non-existent node
        updated = tree.update(999, 50);
        assertFalse(updated);
    }

    function testSelect() public {
        // Insert nodes with different weights
        tree.insert(1, 50); // 0-49
        tree.insert(2, 30); // 50-79
        tree.insert(3, 20); // 80-99

        // Test selections from different ranges
        assertEq(tree.select(25), 2); // Should select from first range
        assertEq(tree.select(60), 1); // Should select from second range
        assertEq(tree.select(85), 3); // Should select from third range

        // Test edge cases
        assertEq(tree.select(0), 2); // First possible selection
        assertEq(tree.select(95), 3); // Last possible selection
        assertEq(tree.select(100), 0); // Beyond total weight
    }

    function testComplexTreeOperations() public {
        // Build a more complex tree
        tree.insert(1, 100);
        tree.insert(2, 50);
        tree.insert(3, 75);
        tree.insert(4, 25);
        tree.insert(5, 60);

        // Test initial state
        assertEq(tree.weightSum(), 310);

        // Update some weights
        tree.update(2, 80);
        tree.update(4, 40);

        // Remove a node
        tree.remove(3);

        // Insert new node
        tree.insert(6, 45);

        // Verify final state
        assertEq(tree.weightSum(), 325);
    }

    function testEmptyTreeOperations() public {
        // Operations on empty tree
        assertEq(tree.weightSum(), 0);
        assertEq(tree.select(0), 0);
        assertFalse(tree.remove(1));
        assertFalse(tree.update(1, 100));
    }

    function testWeightZero() public {
        // Test inserting and updating with zero weight
        tree.insert(1, 0);
        assertEq(tree.weightSum(), 0);

        tree.insert(2, 100);
        tree.update(2, 0);
        assertEq(tree.weightSum(), 0);
    }

    function testSelectWithWeightDecrease() public {
        tree.insert(1, 100);
        tree.insert(2, 50);

        // Select should decrease weight by 1
        uint256 selected = tree.select(75);
        assertEq(selected, 1);
        assertEq(tree.weightSum(), 149); // Original weight - 1
    }

    function testRemoveLastNode() public {
        tree.insert(1, 100);
        assertTrue(tree.remove(1));
        assertEq(tree.weightSum(), 0);
        // Try operations on empty tree after removing last node
        assertEq(tree.select(0), 0);
    }

    function testTreeBalancing() public {
        // Insert nodes in a way that triggers tree balancing
        tree.insert(1, 10);
        tree.insert(2, 20);
        tree.insert(3, 30);
        tree.insert(4, 40);
        tree.insert(5, 50);

        // The tree should maintain balance with higher weights closer to root
        assertEq(tree.weightSum(), 150);

        // Update weights to trigger rebalancing
        tree.update(1, 60);
        tree.update(2, 5);
    }

    function testFuzzInsertAndRemove(uint256 id, uint256 weight) public {
        // Bound the weight to prevent overflow
        weight = bound(weight, 0, type(uint256).max / 100);

        tree.insert(id, weight);
        assertEq(tree.weightSum(), weight);

        bool removed = tree.remove(id);
        assertTrue(removed);
        assertEq(tree.weightSum(), 0);
    }

    function testFuzzMultipleOperations(
        uint256[5] memory ids,
        uint256[5] memory weights
    ) public {
        for (uint i = 0; i < 5; i++) {
            // Ensure unique IDs and reasonable weights
            ids[i] = bound(ids[i], i + 1, type(uint256).max);
            weights[i] = bound(weights[i], 0, type(uint256).max / 100);

            tree.insert(ids[i], weights[i]);

            if (i % 2 == 1) {
                tree.update(ids[i - 1], weights[i] / 2);
            }
        }

        // Remove some nodes
        for (uint i = 0; i < 3; i++) {
            tree.remove(ids[i]);
        }
    }
}
