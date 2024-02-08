// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

interface IliquidRNG {
    function random1(uint256 mod, uint256 demod) external view returns(uint256);

    function random2(uint256 mod, uint256 demod) external view returns(uint256);

    function random3(uint256 mod, uint256 demod) external view returns(uint256);

    function random4(uint256 mod, uint256 demod) external view returns(uint256);

    function random5(uint256 mod, uint256 demod) external view returns(uint256);

    function random6() external view returns(uint256);

    function random7() external view returns(uint256);

    function random8() external view returns(uint256);

    function random9() external view returns(uint256);

    function random10() external view returns(uint256);

    function randomFull() external view returns(uint256);

    function requestMixup() external;
}


interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    function mint(address account, uint256 amount) external;
}

interface IERC165 {

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IFOODIES is IERC165 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator) external view returns (bool);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    function mint(address account, uint256 amount) external;
}

interface IFOODIESTORAGE {

  function pushID(uint256 newId) external;

  function pushName(uint256 newId, string memory newName) external;

  function pushAbout(uint256 newId, string memory newAbout) external;

  function pushLevel(uint256 newId, uint256 newLevel) external;

  function pushTime(uint256 newId, uint256 newTime) external;

  function pushExp(uint256 newId, uint256 value) external;

  function pushCooking(uint256 newId, uint256 newCook) external;

  function pushFullness(uint256 newId, uint256 newFull) external;

  function fullSet(uint256 newId, 
  uint256 newLevel, uint256 newExp, 
  uint256 newCook, uint256 newFull,
  uint256 newTime, string memory newName,
  string memory newAbout) external;

  function compareStrings(string memory a, string memory b) external pure returns(bool);

  function getID(uint256 ID) external view returns(uint256);

  function getName(uint256 ID) external view returns(string memory);

  function getAbout(uint256 ID) external view returns(string memory);

  function getLevel(uint256 ID) external view returns(uint256);

  function getExp(uint256 ID) external view returns(uint256);

  function getTime(uint256 ID) external view returns(uint256);

  function getCooking(uint256 ID) external view returns(uint256);

  function getFullness(uint256 ID) external view returns(uint256);

  function fullStats(uint256 ID) external view returns(
  uint256 iD, string memory nm, string memory abt, 
  uint256 lv, uint256 exp, uint256 ful, uint256 ckn);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract FoodieLogic is Ownable {


  address public foodToken = 0xBDc635be4D1b43c48734a70Df0A90edC0D70F7e0;
  address public foodieStorage = 0xBDc635be4D1b43c48734a70Df0A90edC0D70F7e0;
  address public foodieBase = 0xBDc635be4D1b43c48734a70Df0A90edC0D70F7e0;
  address public liquidRNG = 0xBDc635be4D1b43c48734a70Df0A90edC0D70F7e0;
  uint256 public cost = 1000;
  uint256 public counter = 0;
  uint256 public gate = 0;

  function buyFoodie() external {
    IERC20 fd = IERC20(foodToken);
    if(msg.sender != owner()){
    require(gate == 1);
    fd.transferFrom(msg.sender,address(this), cost * 1e18);
    }
    _afterPayment();
  }

  function _afterPayment() internal {
    IFOODIES fb = IFOODIES(foodieBase);
    fb.mint(msg.sender,1);
    counter++;
    assignStats();
  }

  function assignStats() internal {
    IliquidRNG rng = IliquidRNG(liquidRNG);
    IFOODIESTORAGE db = IFOODIESTORAGE(foodieStorage);
    rng.requestMixup;
    db.fullSet(counter,1,0,rng.random1(30,1),0,block.timestamp,"nameMe","WhoAmI?");
  }

  function setTokenAddr(address token) external onlyOwner {
    foodToken = token;
  }

  function setDbAddr(address database) external onlyOwner {
    foodieStorage = database;
  }

  function setFoodieBaseAddr(address base) external onlyOwner {
    foodieBase = base;
  }

  function setLiquidRng(address newRNG) external onlyOwner {
    liquidRNG = newRNG;
  }

  function setCost(uint256 newCost) external onlyOwner {
    cost = newCost;
  }

  function fixCounter(uint256 counterFix) external onlyOwner {
    counter = counterFix;
  }

  function setGate(uint256 gateStatus) external onlyOwner {
    gate = gateStatus;
  }

  function withdrawFood() external onlyOwner {
    IERC20 fd = IERC20(foodToken);
    fd.transfer(msg.sender,fd.balanceOf(address(this)));
  }
}