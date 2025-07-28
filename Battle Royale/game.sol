// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BattleRoyaleGame {
    address public owner;
    uint256 public gameCounter;
    uint256 public constant ENTRY_FEE = 0.01 ether;
    uint256 public constant MAX_PLAYERS = 10;
    uint256 public constant MIN_PLAYERS = 3;
    
    enum GameState { WaitingForPlayers, InProgress, Finished }
    
    struct Game {
        uint256 gameId;
        address[] players;
        address winner;
        uint256 prizePool;
        GameState state;
        uint256 startTime;
        uint256 lastActionTime;
        mapping(address => bool) isEliminated;
        mapping(address => uint256) playerIndex;
    }
    
    mapping(uint256 => Game) public games;
    mapping(address => uint256) public playerCurrentGame;
    
    event GameCreated(uint256 indexed gameId);
    event PlayerJoined(uint256 indexed gameId, address indexed player);
    event GameStarted(uint256 indexed gameId, uint256 playerCount);
    event PlayerEliminated(uint256 indexed gameId, address indexed player, address indexed eliminator);
    event GameFinished(uint256 indexed gameId, address indexed winner, uint256 prizePool);
    event PrizeWithdrawn(uint256 indexed gameId, address indexed winner, uint256 amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    
    modifier validGame(uint256 gameId) {
        require(gameId <= gameCounter && gameId > 0, "Invalid game ID");
        _;
    }
    
    modifier playerInGame(uint256 gameId) {
        require(playerCurrentGame[msg.sender] == gameId, "Player not in this game");
        require(!games[gameId].isEliminated[msg.sender], "Player already eliminated");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        gameCounter = 0;
    }
    
    // Core Function 1: Join Game (creates new game if none waiting)
    function joinGame() external payable {
        require(msg.value == ENTRY_FEE, "Incorrect entry fee");
        require(playerCurrentGame[msg.sender] == 0, "Player already in a game");
        
        uint256 currentGameId = gameCounter;
        
        // Check if there's an existing game waiting for players
        if (currentGameId > 0 && 
            games[currentGameId].state == GameState.WaitingForPlayers && 
            games[currentGameId].players.length < MAX_PLAYERS) {
            
            // Join existing game
            Game storage game = games[currentGameId];
            game.players.push(msg.sender);
            game.playerIndex[msg.sender] = game.players.length - 1;
            game.prizePool += msg.value;
            playerCurrentGame[msg.sender] = currentGameId;
            
            emit PlayerJoined(currentGameId, msg.sender);
            
            // Start game if we have enough players
            if (game.players.length >= MIN_PLAYERS) {
                game.state = GameState.InProgress;
                game.startTime = block.timestamp;
                game.lastActionTime = block.timestamp;
                emit GameStarted(currentGameId, game.players.length);
            }
            
        } else {
            // Create new game
            gameCounter++;
            uint256 newGameId = gameCounter;
            
            Game storage newGame = games[newGameId];
            newGame.gameId = newGameId;
            newGame.players.push(msg.sender);
            newGame.playerIndex[msg.sender] = 0;
            newGame.prizePool = msg.value;
            newGame.state = GameState.WaitingForPlayers;
            playerCurrentGame[msg.sender] = newGameId;
            
            emit GameCreated(newGameId);
            emit PlayerJoined(newGameId, msg.sender);
        }
    }
    
    // Core Function 2: Attack Player (eliminate other players)
    function attackPlayer(uint256 gameId, address target) 
        external 
        validGame(gameId) 
        playerInGame(gameId) 
    {
        Game storage game = games[gameId];
        require(game.state == GameState.InProgress, "Game not in progress");
        require(target != msg.sender, "Cannot attack yourself");
        require(!game.isEliminated[target], "Target already eliminated");
        require(playerCurrentGame[target] == gameId, "Target not in this game");
        
        // Simple elimination logic - 50% chance based on block hash
        uint256 randomValue = uint256(keccak256(abi.encodePacked(
            block.timestamp, 
            block.prevrandao, 
            msg.sender, 
            target
        ))) % 100;
        
        if (randomValue < 50) {
            // Attacker wins - eliminate target
            game.isEliminated[target] = true;
            game.lastActionTime = block.timestamp;
            playerCurrentGame[target] = 0;
            
            emit PlayerEliminated(gameId, target, msg.sender);
            
            // Check if game is finished (only one player left)
            _checkGameEnd(gameId);
        } else {
            // Target survives, attacker gets eliminated
            game.isEliminated[msg.sender] = true;
            game.lastActionTime = block.timestamp;
            playerCurrentGame[msg.sender] = 0;
            
            emit PlayerEliminated(gameId, msg.sender, target);
            
            // Check if game is finished
            _checkGameEnd(gameId);
        }
    }
    
    // Core Function 3: Claim Prize (winner claims the prize pool)
    function claimPrize(uint256 gameId) external validGame(gameId) {
        Game storage game = games[gameId];
        require(game.state == GameState.Finished, "Game not finished");
        require(game.winner == msg.sender, "Only winner can claim prize");
        require(game.prizePool > 0, "Prize already claimed");
        
        uint256 prize = game.prizePool;
        uint256 ownerFee = (prize * 5) / 100; // 5% platform fee
        uint256 winnerPrize = prize - ownerFee;
        
        game.prizePool = 0;
        
        // Transfer prize to winner
        payable(msg.sender).transfer(winnerPrize);
        // Transfer fee to owner
        payable(owner).transfer(ownerFee);
        
        emit PrizeWithdrawn(gameId, msg.sender, winnerPrize);
    }
    
    // Internal function to check if game has ended
    function _checkGameEnd(uint256 gameId) internal {
        Game storage game = games[gameId];
        uint256 playersAlive = 0;
        address lastPlayer;
        
        for (uint256 i = 0; i < game.players.length; i++) {
            if (!game.isEliminated[game.players[i]]) {
                playersAlive++;
                lastPlayer = game.players[i];
            }
        }
        
        if (playersAlive == 1) {
            game.state = GameState.Finished;
            game.winner = lastPlayer;
            playerCurrentGame[lastPlayer] = 0;
            
            emit GameFinished(gameId, lastPlayer, game.prizePool);
        } else if (playersAlive == 0) {
            // Edge case: all players eliminated simultaneously
            game.state = GameState.Finished;
            // Prize pool goes to contract owner in this case
        }
    }
    
    // View functions
    function getGameInfo(uint256 gameId) external view validGame(gameId) returns (
        uint256 id,
        address[] memory players,
        address winner,
        uint256 prizePool,
        GameState state,
        uint256 startTime
    ) {
        Game storage game = games[gameId];
        return (
            game.gameId,
            game.players,
            game.winner,
            game.prizePool,
            game.state,
            game.startTime
        );
    }
    
    function getActivePlayersCount(uint256 gameId) external view validGame(gameId) returns (uint256) {
        Game storage game = games[gameId];
        uint256 count = 0;
        
        for (uint256 i = 0; i < game.players.length; i++) {
            if (!game.isEliminated[game.players[i]]) {
                count++;
            }
        }
        
        return count;
    }
    
    function isPlayerEliminated(uint256 gameId, address player) external view validGame(gameId) returns (bool) {
        return games[gameId].isEliminated[player];
    }
    
    // Emergency function to handle stuck games
    function forceEndGame(uint256 gameId) external onlyOwner validGame(gameId) {
        Game storage game = games[gameId];
        require(game.state == GameState.InProgress, "Game not in progress");
        require(block.timestamp > game.lastActionTime + 1 hours, "Game still active");
        
        game.state = GameState.Finished;
        // Refund all players proportionally
        uint256 refundAmount = game.prizePool / game.players.length;
        
        for (uint256 i = 0; i < game.players.length; i++) {
            if (!game.isEliminated[game.players[i]]) {
                payable(game.players[i]).transfer(refundAmount);
                playerCurrentGame[game.players[i]] = 0;
            }
        }
        
        game.prizePool = 0;
    }
    
    // Withdraw contract balance (only owner)
    function withdrawBalance() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
