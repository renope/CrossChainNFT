// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./CrossChainImplementationInterface.sol";
import "./Payment.sol";

contract CrossChainImplementation is Initializable, CrossChainImplementationInterface, Payment{

    function version() public pure returns(string memory) {
        return "1.0.0";
    }

    function initialize() initializer public {
        __Ownable_init();
        __PaymentData_init();
        __priceConsumer_init();
        __gasPriceConsumer_init();
    }

    function mintFee(uint256 targetChainId) public view returns(uint256){
        return _mintFee(targetChainId);
    }
    
    function redeemFee(uint256 targetChainId) public view returns(uint256){
        return _redeemFee(targetChainId);
    }

    
    function requestTransferCrossChain(
        uint256 targetChainId,
        address to,
        uint256 chainId,
        address contAddr,
        uint256 tokenId,
        string memory uri,
        uint256 dappId,
        bytes memory data
    ) public payable {
        _payMintFee(msg.value, targetChainId, dappId);
    }

    function requestReleaseLockedToken(
        uint256 chainId,
        address contAddr,
        address to,
        uint256 tokenId,
        uint256 dappId,
        bytes memory data
    ) public payable{
        _payRedeemFee(msg.value, chainId, dappId);
    }
}