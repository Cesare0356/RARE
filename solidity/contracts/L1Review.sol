// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract L1Review {
    struct ReviewData {
        uint8 rating;   // 1..5
        bytes review;   // raw text/bytes (stored in storage)
    }

    /// @dev Unique mode: one entry per computed key.
    mapping(bytes32 => ReviewData) public revByKey;

    event ReviewStoredUnique(
        bytes32 indexed key,
        address indexed toAddress,
        address indexed userAddress,
        uint8 rating,
        uint256 len
    );

    /// @notice Always writes to a new slot (key = keccak(user_address, to_address, nonce)).
    /// @dev Validates input and then saves to storage.
    function leave_review_unique(
        address user_address,
        address to_address,
        uint256 nonce,
        uint8 rating,          // strictly typed
        string calldata text
    ) external {
        // --- validations ---
        // rating between 1 and 5
        require(rating >= 1 && rating <= 5, "rating out of range [1..5]");

        // maximum length 1024
        bytes memory b = bytes(text);
        uint256 len = b.length;
        require(len <= 1024, "text too long (>1024)");

        // printable ASCII characters: 32..126
        // (empty string allowed)
        for (uint256 i = 0; i < len; ) {
            uint8 c = uint8(b[i]);
            require(c >= 32 && c <= 126, "non-printable ASCII char");
            unchecked { ++i; }
        }

        // --- unique key to avoid overwrite (new storage slots) ---
        bytes32 key = keccak256(abi.encode(user_address, to_address, nonce));

        // --- write to STORAGE ---
        // Assign struct: rating and bytes go into storage (length slot + ceil(len/32) data slots)
        revByKey[key] = ReviewData({
            rating: rating,
            review: b
        });

        emit ReviewStoredUnique(key, to_address, user_address, rating, len);
    }

    function get_review_unique(bytes32 key)
        external
        view
        returns (uint8 rating, string memory text, bool exists)
    {
        ReviewData storage d = revByKey[key];
        // Since valid rating is [1..5], we can use rating == 0 as "does not exist".
        if (d.rating == 0) {
            return (0, "", false);
        }
        return (d.rating, string(d.review), true);
    }
}