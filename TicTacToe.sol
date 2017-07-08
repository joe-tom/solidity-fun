
pragma solidity ^0.4.

contract TicTacToe {
    struct Game {
        uint8 board[9];
        address player_x;
        address player_o;
    }

    mapping (uint => Game) games;
    mapping (address => uint[]) player;

    event Start(
        address x,
        address o,
        uint game
    );
    
    uint counter = 0;


    function start (address one, address two) {

        // Joe Thomas' sick RNG.
        bytes32 hash = block.blockhash(block.number - 1);
        uint time = block.timestamp;
        uint rng = time ^ uint(hash[0]);

        // Check to see if the random number is odd or even to determine x and o.
        if (rng % 2) {
            Game game = Game([0,0,0,0,0,0,0,0,0], one, two);
            Start(one, two, counter);
        } else {
            Game game = Game([0,0,0,0,0,0,0,0,0], two, one);
            Start(two, one, counter);
        }
        
        // Put the new game in the mappings.
        games[counter] = game;
        player[one] = counter;
        player[two] = counter;
        counter++;
    }

    function move () {

    }
}
