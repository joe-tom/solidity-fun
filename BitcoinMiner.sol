pragma solidity ^0.4.8;

contract BitcoinMiner {
    address FOUNDER_ADDR;
    string FOUNDER_NAME;
    uint GAS_PER_HASH = 80;
    uint MAX_UINT = 2**32;
    
    uint32 nonce;
    
    function BitcoinMiner () {
        FOUNDER_NAME = "Joe Thomas";
        FOUNDER_ADDR = msg.sender;
        
        // Start the nonce at 0.
        nonce = 0;
    }
    
    /**
     * Accepts the bitcoin header params and produces a valid mined blockheader
     * @param  {uint256} uint256 prev          - The hash of the previous block.
     * @param  {uint256} uint256 merkle        - The transaction merkle tree.
     * @param  {uint32} uint32  bits           - The target bits, for the actual block. 
     * @param  {uint32} uint32  time           - The 4 byte UNIX timestamp. 
     * @param  {uint32} uint32  version        - The 4 byte version number of the thing.

     * @return {(uint32, bool)}         Returns a tuple of the nonce, and whether it was mined. 
     */
    function mine (
        uint256 prev,
        uint256 merkle, 
        uint32 bits,
        uint32 time,
        uint32 version) public returns (uint32, bool) {

        // Extract the actual target from bits.
        bytes32 target = bytes32(uint256(bits) * 2**(8*(0x1b - 3)));

        // Don't want an overflow, so reset the nonce if it overflows.
        uint hashes = msg.gas / GAS_PER_HASH;
        
        if ((MAX_UINT - hashes) < nonce) {
            nonce = 0;
        }
        
        // This loop does the mining.
        while ((msg.gas > 20) && (sha256(sha256(version,prev,merkle,time,bits,nonce)) > target)) {
            nonce++;
        }
        
        // This either the means, we ran out of gas, or we successfully mined a coin
        return (nonce, msg.gas < 20);
    }
    
    
    // Donate to my miner, for helping find your bitcoins :D!
    function donate() public payable returns (bool) {
        return FOUNDER_ADDR.send(msg.value);
    
    }
}