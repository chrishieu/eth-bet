// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract Bet {
    struct BetPlayer {
        address _payer;
        uint256 _money;
        uint256 _option;
        uint256 _prize;
        uint256 _status; // 0 dang cho, 1 da tra thuong, 2 thua
    }

    mapping(uint256 => BetPlayer) Payments; // ko length
    uint256[] private ListPayments;

    address private owner;

    uint256 public Prize;
    uint256 private Money_Win;
    uint256 public CHECK;

    constructor() {
        owner = msg.sender;
        Prize = 0;
        Money_Win = 0;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function counting() public view returns (uint256) {
        return ListPayments.length;
    }

    function get_1_Payment(uint256 ordering)
        public
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return (
            Payments[ordering]._payer,
            Payments[ordering]._money,
            Payments[ordering]._option,
            Payments[ordering]._prize,
            Payments[ordering]._status
        );
    }

    function betMoney(uint256 Option) public payable {
        ListPayments.push(ListPayments.length);
        BetPlayer memory newBet =
            BetPlayer(msg.sender, msg.value, Option, 0, 0);
        Payments[ListPayments.length - 1] = newBet;
    }

    function processResult(uint256 result) public {
        CHECK = 0;
        Prize = 0;
        Money_Win = 0;
        if (msg.sender == owner) {
            if (result == 1) {
                for (uint256 i = 0; i < ListPayments.length; i++) {
                    if (Payments[i]._option == 0) {
                        Prize = Prize + Payments[i]._money;
                        Payments[i]._status = 2;
                    }
                    if (Payments[i]._option == 1) {
                        Money_Win = Money_Win + Payments[i]._money;
                    }
                }

                // Prize -  100
                // .money/moneyWin
                for (uint256 i = 0; i < ListPayments.length; i++) {
                    if (Payments[i]._option == 1) {
                        Payments[i]._prize =
                            ((Payments[i]._money / Money_Win) * Prize) /
                            2;
                        address payable receiver = payable(Payments[i]._payer);
                        (bool success, ) =
                            receiver.call{
                                value: (Payments[i]._prize +
                                    Payments[i]._money) * 1 wei
                            }("");
                        if (success) {
                            Payments[i]._status = 1;
                        }
                    }
                }
            } else {
                for (uint256 i = 0; i < ListPayments.length; i++) {
                    if (Payments[i]._option == 1) {
                        Prize = Prize + Payments[i]._money;
                        Payments[i]._status = 2;
                    }
                    if (Payments[i]._option == 0) {
                        Money_Win = Money_Win + Payments[i]._money;
                    }
                }

                // Prize -  100
                // .money/moneyWin
                for (uint256 i = 0; i < ListPayments.length; i++) {
                    if (Payments[i]._option == 0) {
                        Payments[i]._prize =
                            ((Payments[i]._money / Money_Win) * Prize) /
                            2;
                        address payable receiver = payable(Payments[i]._payer);
                        (bool success, ) =
                            receiver.call{
                                value: (Payments[i]._prize +
                                    Payments[i]._money) * 1 wei
                            }("");
                        if (success) {
                            Payments[i]._status = 1;
                        }
                    }
                }
            }

            (bool success, ) =
                owner.call{value: address(this).balance * 1 wei}("");
        } else {
            CHECK = 999999;
        }
    }
}
