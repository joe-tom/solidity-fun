
pragma solidity ^0.4.8;

contract TicTacToe {

    struct Game {
        address cha;
        address acc;

        bytes32 chaCommit;
        bytes32 accCommit
        uint8 chaVal;
        uint8 accVal;

        bool chaX;
    }

    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    mapping (bytes32 => Game) games;
    mapping (address => uint[]) player;

    event Start(
        address x,
        address o,
        bytes32 game
    );

    uint counter = 0;


    function won (bytes32 game, bytes32 won) {
        return 0;
    }


    function start (bytes32 id, uint8 chaVal, uint8 accVal) {
        // Fetch the appropriate game.
        Game game = games[id];
        assert(game);

        // Check if the values are the correct commited values
        assert(sha256(chaVal) == game.cha);
        assert(sha256(accVal) == game.acc);

        // Flip the coin through multiplication.
        uint chaX = mulmod(chaVal, accVal, 2);
        game.chaX = bool(chaX);

        // Start the appropriate game.
        if (chaX) {
            Start(
                    game.cha,
                    game.acc,
                    id
                );
        } else {
            Start(
                    game.acc,
                    game.cha,
                    id
                );
        }
    }

    function newGame (bytes32 myCommitment, address accepting, bytes32 accCommitment, Signature sig) {

        // Verify that this commitment is new and legitimate.
        assert(ecrecover(accCommitment, sig.v, sig.r, sig.s) == accepting);
        assert(!games[accCommitment]);

        // We'll use this commitment as the gameID
        games[accCommitment] = Game(
                msg.sender,
                accepting,

                myCommitment,
                accCommitment,
                0,
                0,
                false
            );


    }
}
