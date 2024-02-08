// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


abstract contract Context {
  function _msgSender() internal view virtual returns(address payable) {
    return payable(msg.sender);
  }

  function _msgData() internal view virtual returns(bytes memory) {
    this;
    return msg.data;
  }
}

contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor() {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  function owner() public view returns(address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  function renounceOwnership() public virtual onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

abstract contract Controllable is Ownable {
    mapping(address => bool) internal _controllers;

    modifier onlyController() {
        require(
            _controllers[msg.sender] == true || address(this) == msg.sender,
            "Controllable: caller is not a controller"
        );
        _;
    }

    function addController(address _controller)
        external
        onlyOwner
    {
        _controllers[_controller] = true;
    }

    function delController(address _controller)
        external
        onlyOwner
    {
        delete _controllers[_controller];
    }

    function disableController(address _controller)
        external
        onlyOwner
    {
        _controllers[_controller] = false;
    }

    function isController(address _address)
        external
        view
        returns (bool allowed)
    {
        allowed = _controllers[_address];
    }

    function relinquishControl() external onlyController {
        delete _controllers[msg.sender];
    }
}

contract FoodiesStorage is Controllable {

  struct Character {
    uint256 id;
    uint256 level;
    uint256 experience;
    uint256 cooking;
    uint256 fullness;
    uint256 time;
    string name;
    string about;
  }

  mapping(uint256 => Character) characters;

//SETS

function pushID(uint256 newId) public onlyController {
    characters[newId].id = newId;
}

function pushName(uint256 newId, string memory newName) public onlyController {
    characters[newId].name = newName;
}

function pushAbout(uint256 newId, string memory newAbout) public onlyController {
    characters[newId].about = newAbout;
}

function pushLevel(uint256 newId, uint256 newLevel) public onlyController {
    characters[newId].level = newLevel;
}

function pushTime(uint256 newId, uint256 newTime) public onlyController {
    characters[newId].time = newTime;
}

function pushExp(uint256 newId, uint256 value) public onlyController {
	  characters[newId].experience = value;
}

function pushCooking(uint256 newId, uint256 newCook) public onlyController {
    characters[newId].cooking = newCook;
}

function pushFullness(uint256 newId, uint256 newFull) public onlyController {
	  characters[newId].fullness = newFull;
}

function fullSet(uint256 newId, 
uint256 newLevel, 
uint256 newExp, 
uint256 newCook, 
uint256 newFull,
uint256 newTime,
string memory newName,
string memory newAbout)
external onlyController {
pushID(newId);
pushLevel(newId,newLevel);
pushExp(newId,newExp);
pushCooking(newId, newCook);
pushFullness(newId,newFull);
pushTime(newId,newTime);
pushName(newId,newName);
pushAbout(newId,newAbout);
}

//GETS
 
  function compareStrings(string memory a, string memory b) external pure returns(bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }
  function getID(uint256 ID) public view returns(uint256) {
    return characters[ID].id;
  }
  function getName(uint256 ID) public view returns(string memory) {
    return characters[ID].name;
  }
  function getAbout(uint256 ID) public view returns(string memory) {
    return characters[ID].about;
  }
  function getLevel(uint256 ID) public view returns(uint256) {
    return characters[ID].level;
  }
  function getExp(uint256 ID) public view returns(uint256) {
    return characters[ID].experience;
  }
  function getTime(uint256 ID) public view returns(uint256) {
	  return characters[ID].time;
  }
  function getCooking(uint256 ID) public view returns(uint256) {
	  return characters[ID].cooking;
  }
  function getFullness(uint256 ID) public view returns(uint256) {
    return characters[ID].fullness;
  }
  function fullStats(uint256 ID) public view returns(
  uint256 iD, string memory nm, string memory abt, 
  uint256 lv, uint256 exp, uint256 ful, uint256 ckn) {
  iD = getID(ID);
  nm = getName(ID);
  abt = getAbout(ID);
  lv = getLevel(ID);
  exp = getExp(ID);
  ful = getFullness(ID);
  ckn = getCooking(ID);
  }
}