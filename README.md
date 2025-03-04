# Weight Balanced Tree

A Solidity implementation of a weight-balanced tree data structure that enables weighted random selection. This data structure is particularly useful for applications requiring weighted randomness, such as:

- Random NFT selection with different probabilities
- Weighted token distribution
- Probabilistic selection mechanisms
- Lottery systems with varying ticket weights

## Overview

The WeightBalancedTree library implements a self-balancing binary tree where each node contains:

- An identifier
- A weight value
- The sum of all weights in its subtree

The tree maintains balance based on node weights rather than just tree height, ensuring efficient weighted selection operations.

## Key Features

- **Weighted Insertion**: Add elements with associated weights
- **Weighted Selection**: Select elements randomly with probability proportional to their weights
- **Dynamic Updates**: Modify weights of existing elements
- **Efficient Removal**: Remove elements while maintaining tree balance
- **Auto-balancing**: Self-balances to maintain optimal performance

## Core Functions

### `insert(uint256 id, uint256 weight)`

Adds a new element to the tree with the specified ID and weight.

### `select(uint256 weight)`

Performs a weighted random selection. Returns an ID based on the provided weight value. The selected item's weight is decreased by 1.

### `update(uint256 id, uint256 weight)`

Updates the weight of an existing element.

### `remove(uint256 id)`

Removes an element from the tree.

### `weightSum()`

Returns the total sum of all weights in the tree.

## Usage Example

```solidity
using WeightBalancedTree for WeightBalancedTree.Tree;
WeightBalancedTree.Tree private tree;

// Insert elements with weights
tree.insert(1, 50);  // ID 1 with weight 50
tree.insert(2, 30);  // ID 2 with weight 30
tree.insert(3, 20);  // ID 3 with weight 20

// Perform weighted selection
uint256 selected = tree.select(75);  // Returns an ID based on weight distribution

// Update weight
tree.update(1, 60);  // Change weight of ID 1 to 60

// Remove element
tree.remove(2);  // Remove ID 2 from tree
```

## Development

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

## Testing

The contract includes comprehensive tests covering:

- Basic operations (insert, remove, update, select)
- Edge cases
- Complex tree operations
- Fuzzing tests
- Tree balancing verification
- Weight management
- Empty tree handling

## License

MIT
