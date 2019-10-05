# Blackjack

MacOS/Linux Command Line Interface written in Swift for Blackjack Monte Carlo Simulations and Testing.

## How to run

Clone the repo and double click on the unix executable under Product/Blackjack to run the CLI on Linux and Mac. 

I recommend downloading Xcode 11+ and Swift 5+ to browse and run the code.

## Design

### Rules
This game makes several simplifications for now. It assumes a continuous shuffle machine rather than a fixed set of decks. Dealer hits on a hard 17. 
No splitting, no doubling, no surrendering. Only original bets are lost on dealer blackjack, although the dealer wins immediately.

### Features
Players start out with 1000 coins. Every hand dealt, they can receive a hint, stand, or hit. 
The hint is currently implemented as a expectation maximization hand lookup table, where every possible hand is assigned an optimal move (either hit or stand in this case). 
The player hits until they stand or bust, the dealer draws until they reach 17 or bust, and then the winner takes the prize. 
The game continues until the player is out of coins or quits the game voluntarily.

### Code Design
`main.swift` is the entry point of the application. It creates a new `Game` object to `play()`.  
A `Game` contains the state machine for the blackjack game, such as coins remaining, 
and the `play()` method runs an indefinite loop until the player exits the game or loses.
The `Game` reads user input using the `Input` enumeration and its static method `getCurrentLine()`, which reads from `stdin`.

Both the `.player` and the `.dealer` receive a `Hand`.
A `Hand` contains initially two `Card`'s, and can `hit()` to receive more or `stand()` to remain at the current `sum`. 
The `sum` returns either the soft value or the hard value, depending on which is greater and not over 21.
The soft value is determined by calling `reduce(initialResult:,nextPartialResult:)` on the soft value of every `Card` that makes up the Hand, which is 1 for Ace and face value for everything else.
The hard value is determined by reducing the hard values of each card, which is 11 for ace and face value for everything else.

A `Card` is an enumeration of either `.ace` or `.notAce`  with associated values containing the `name` of the card, as well as the 1) value of the card for `.notAce`, or 2) `softValue` and `hardValue` for `.ace`.
The Card `.init` is noteworthy - it simply calls Swift's built-in `Array` method `randomElement()`, which in turn calls the `Collection` protocol's `randomElement(using:)`.
The random card will be chosen from a uniform distribution - in this case, every card has an equal chance of being chosen since every card appears four times in a deck.
See <https://github.com/apple/swift-evolution/blob/master/proposals/0202-random-unification.md> for the Swift Evolution proposal.
See <https://github.com/apple/swift/blob/master/stdlib/public/core/Collection.swift> for randomElement's implementation with the default generator.

If the dealer's hand `isBlackjack`, the dealer automatically wins the hand. 
Else, the player can `hit()` until they bust or `stand()`, with the ability to receive hints every draw.
Receiving a `Hint` involves calling `bestMove()`  given both the dealer and player hands, 
and returning the move with the highest expected value using a priori blackjack knowledge.
For example, if the dealer's hand currently sums to less than 9, and the player has an ace and a seven, the best move is to `Move.hit`.

Now that the player's hand is finalized, the dealer draws until they reach 17 or bust. 
The `Game` instance's `gameOutcome()` is then decided, printed to `stdout`, and the coins are exchanged in the case of no tie.
The loop starts back from the top, with each `Player` dealt a hand.

### Todo
The blackjack game needs to be automated for Monte Carlo simulations. This goes hand in hand with increasing game rule options. For example, the user could run 10000 iterations on a game with 2 decks vs 4 decks and measure the difference in outcomes. Test cases will need to be added along with automation to check for edge cases like having multiple aces. The hints should be customizable by strategy, and perhaps even machine-learned via thousands of iterations with various parameters. Then, this simulation will be the perfect tool for any gambler wanting to brush up on their strategy before heading to the casino.

