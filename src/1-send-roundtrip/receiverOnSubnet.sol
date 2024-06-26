// (c) 2023, Ava Labs, Inc. All rights reserved.
// See the file LICENSE for licensing terms.

// SPDX-License-Identifier: Ecosystem

pragma solidity ^0.8.18;

import "@teleporter/ITeleporterMessenger.sol";
import "@teleporter/ITeleporterReceiver.sol";

contract ReceiverOnSubnet is ITeleporterReceiver {
    ITeleporterMessenger public immutable messenger = ITeleporterMessenger(0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf);

    function receiveTeleporterMessage(bytes32 sourceBlockchainID, address originSenderAddress, bytes calldata message)
        external
    {
        // Only the Teleporter receiver can deliver a message.
        require(msg.sender == address(messenger), "ReceiverOnSubnet: unauthorized TeleporterMessenger");

        // Send Roundtrip message back to sender
        string memory response = string.concat(abi.decode(message, (string)), " World!");

        messenger.sendCrossChainMessage(
            TeleporterMessageInput({
                // Blockchain ID of C-Chain
                destinationBlockchainID: sourceBlockchainID,
                destinationAddress: originSenderAddress,
                feeInfo: TeleporterFeeInfo({feeTokenAddress: address(0), amount: 0}),
                requiredGasLimit: 100000,
                allowedRelayerAddresses: new address[](0),
                message: abi.encode(response)
            })
        );
    }
}
