// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

/**
 * Strings processing library
 *
 */
library Strings {

    // Type used for UNIX epoch quantities
    type Epoch is uint40;

    // Type used to represent "quarters-of-an-hour" (used for timezone offset specification)
    type Quarters is int8;

    /**
     * Convert the given boolean value to string (ie. "true" / "false")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bool value) external pure returns (string memory) {
        return value ? "true" : "false";
    }

    /**
     * Convert the given uint value to string
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(uint256 value) external pure returns (string memory) {
        return _toString(value);
    }

    /**
     * Convert the given int value to string
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(int256 value) external pure returns (string memory) {
        return _toString(value);
    }

    /**
     * Convert the given bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes memory value) external pure returns (string memory) {
        return _toString(value);
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes1 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes2 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes3 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes4 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes5 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes6 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes7 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes8 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes9 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes10 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes11 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes12 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes13 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes14 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes15 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes16 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes17 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes18 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes19 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes20 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes21 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes22 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes23 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes24 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes25 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes26 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes27 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes28 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes29 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes30 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes31 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given fixed-size bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(bytes32 value) external pure returns (string memory) {
        unchecked {
            bytes memory temp = new bytes(value.length);
            for (uint8 i = 0; i < value.length; i++) temp[i] = value[i];
            return _toString(temp);
        }
    }

    /**
     * Convert the given address value to string (ie. "<...>")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toString(address value) external pure returns (string memory) {
        return _toString(value);
    }

    /**
     * Extract the date/time components from the given epoch value
     *
     * @param value  The value to extract components from
     * @return year  The year the given epoch encodes
     * @return month  The month the given epoch encodes
     * @return day  The day the given epoch encodes
     * @return hour  The hour the given epoch encodes
     * @return minute  The minute the given epoch encodes
     * @return second  The second the given epoch encodes
     * @return tzHours  The timezone offset hours (always 0 for this overload)
     * @return tzMinutes  The timezone offset minutes (always 0 for this overload)
     */
    function toDateTimeParts(Epoch value) external pure returns (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second, int256 tzHours, uint256 tzMinutes) {
        return _toDateTimeParts(value, Quarters.wrap(0));
    }

    /**
     * Extract the date/time components from the given epoch value
     *
     * @param value  The value to extract components from
     * @param tzOffset  The number of quarters-of-an-hour to offset
     * @return year  The year the given epoch encodes
     * @return month  The month the given epoch encodes
     * @return day  The day the given epoch encodes
     * @return hour  The hour the given epoch encodes
     * @return minute  The minute the given epoch encodes
     * @return second  The second the given epoch encodes
     * @return tzHours  The timezone offset hours
     * @return tzMinutes  The timezone offset minutes (always multiple of 15)
     */
    function toDateTimeParts(Epoch value, Quarters tzOffset) external pure returns (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second, int256 tzHours, uint256 tzMinutes) {
        return _toDateTimeParts(value, tzOffset);
    }

    /**
     * Convert the given epoch value to ISO8601 format (ie. "0000-00-00T00:00:00Z")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function toIso8601(Epoch value) external pure returns (string memory) {
        return _toIso8601(value, Quarters.wrap(0));
    }

    /**
     * Convert the given epoch value to ISO8601 format (ie. "0000-00-00T00:00:00+00:00")
     *
     * @param value  The value to convert to string
     * @param tzOffset  The number of quarters-of-an-hour to offset
     * @return  The resulting string
     */
    function toIso8601(Epoch value, Quarters tzOffset) external pure returns (string memory) {
        return _toIso8601(value, tzOffset);
    }

    bytes10 internal constant DEC_DIGITS = "0123456789";
    bytes16 internal constant HEX_DIGITS = "0123456789abcdef";

    /**
     * Convert the given uint256 value to string
     *
     * Mostly taken from: openzeppelin/contracts/utils/Strings.sol
     *
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function _toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            if (value == 0) {
                return "0";
            }
            uint256 digits;
            for (uint256 temp = value; temp != 0; temp /= 10) {
                digits++;
            }
            bytes memory buffer = new bytes(digits);
            for (; 0 < digits; digits--) {
                buffer[digits - 1] = DEC_DIGITS[value % 10];
                value /= 10;
            }
            return string(buffer);
        }
    }

    /**
     * Convert the given int256 value to string
     *
     * A minus sign will be added in case the value is negative, nothing will be added if positive.
     *
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function _toString(int256 value) internal pure returns (string memory) {
        return string.concat(value < 0 ? '-' : '', _toString(uint256(value)));
    }

    /**
     * Convert the given bytes value to string (ie. "[...]")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function _toString(bytes memory value) internal pure returns (string memory) {
        unchecked {
            uint256 len = value.length;
            bytes memory buffer = new bytes(len * 2 + 2);
            buffer[0] = '[';
            for ((uint256 i, uint256 j, uint256 k) = (0, 1, 2); i < len; (i, j, k) = (i + 1, j + 2, k + 2)) {
                uint8 val = uint8(value[i]);
                (buffer[j], buffer[k]) = (HEX_DIGITS[val >> 4], HEX_DIGITS[val & 0x0f]);
            }
            buffer[len * 2 + 1] = ']';
            return string(buffer);
        }
    }

    /**
     * Convert the given address value to string (ie. "<...>")
     *
     * @param value  The value to convert to string
     * @return  The resulting string
     */
    function _toString(address value) internal pure returns (string memory) {
        unchecked {
            bytes20 nValue = bytes20(value);
            bytes memory buffer = new bytes(42);
            buffer[0] = '<';
            for ((uint256 i, uint256 j, uint256 k) = (0, 1, 2); i < 20; (i, j, k) = (i + 1, j + 2, k + 2)) {
                uint8 val = uint8(nValue[i]);
                (buffer[j], buffer[k]) = (HEX_DIGITS[val >> 4], HEX_DIGITS[val & 0x0f]);
            }
            buffer[41] = '>';
            return string(buffer);
        }
    }

    /**
     * Extract the date/time components from the given epoch value
     *
     * Mostly taken from: https://howardhinnant.github.io/date_algorithms.html#civil_from_days
     *
     *
     * @param value  The value to extract components from
     * @param tzOffset  The number of quarters-of-an-hour to offset
     * @return year  The year the given epoch encodes
     * @return month  The month the given epoch encodes
     * @return day  The day the given epoch encodes
     * @return hour  The hour the given epoch encodes
     * @return minute  The minute the given epoch encodes
     * @return second  The second the given epoch encodes
     * @return tzHours  The timezone offset hours
     * @return tzMinutes  The timezone offset minutes (always multiple of 15)
     */
    function _toDateTimeParts(Epoch value, Quarters tzOffset) internal pure returns (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second, int8 tzHours, uint8 tzMinutes) {
        unchecked {
            require(-48 <= Quarters.unwrap(tzOffset), "Strings: timezone offset too small");
            require(Quarters.unwrap(tzOffset) <= 56, "Strings: timezone offset too big");

            int256 tzOffsetInSeconds = int256(Quarters.unwrap(tzOffset)) * 900;
            uint256 nValue;
            if (tzOffsetInSeconds < 0) {
                require(uint256(-tzOffsetInSeconds) <= Epoch.unwrap(value), "Strings: epoch time too small for timezone offset");
                nValue = Epoch.unwrap(value) - uint256(-tzOffsetInSeconds);
            } else {
                nValue = Epoch.unwrap(value) + uint256(tzOffsetInSeconds);
            }

            require(nValue <= 253402311599, "Strings: epoch time too big");

            {
                uint256 z = nValue / 86400 + 719468;
                uint256 era = z / 146097;
                uint256 doe = z - era * 146097;
                uint256 yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365;
                uint256 doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
                uint256 mp = (5 * doy + 2) / 153;
                //
                year = yoe + era * 400 + (mp == 10 || mp == 11 ? 1 : 0);
                month = mp < 10 ? mp + 3 : mp - 9;
                day = doy - (153 * mp + 2) / 5 + 1;
            }

            {
                uint256 w = nValue % 86400;
                //
                hour = w / 3600;
                minute = (w % 3600) / 60;
                second = w % 60;
            }

            tzHours = int8(tzOffsetInSeconds / 3600);
            tzMinutes = uint8((uint256(tzOffsetInSeconds < 0 ? -tzOffsetInSeconds : tzOffsetInSeconds) % 3600) / 60);
        }
    }

    /**
     * Convert the given epoch value to ISO8601 format (ie. "0000-00-00T00:00:00+00:00")
     *
     * @param value  The value to convert to string
     * @param tzOffset  The number of quarters-of-an-hour to offset
     * @return  The resulting string
     */
    function _toIso8601(Epoch value, Quarters tzOffset) internal pure returns (string memory) {
        unchecked {
            (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second, int8 tzHours, uint8 tzMinutes) = _toDateTimeParts(value, tzOffset);

            bytes memory buffer = "0000-00-00T00:00:00";

            buffer[0] = DEC_DIGITS[(year / 1000) % 10];
            buffer[1] = DEC_DIGITS[(year / 100) % 10];
            buffer[2] = DEC_DIGITS[(year / 10) % 10];
            buffer[3] = DEC_DIGITS[year % 10];
            //
            buffer[5] = DEC_DIGITS[(month / 10) % 10];
            buffer[6] = DEC_DIGITS[month % 10];
            //
            buffer[8] = DEC_DIGITS[(day / 10) % 10];
            buffer[9] = DEC_DIGITS[day % 10];
            //
            buffer[11] = DEC_DIGITS[(hour / 10) % 10];
            buffer[12] = DEC_DIGITS[hour % 10];
            //
            buffer[14] = DEC_DIGITS[(minute / 10) % 10];
            buffer[15] = DEC_DIGITS[minute % 10];
            //
            buffer[17] = DEC_DIGITS[(second / 10) % 10];
            buffer[18] = DEC_DIGITS[second % 10];

            if (Quarters.unwrap(tzOffset) == 0) {
                return string.concat(string(buffer), "Z");
            } else {
                bytes memory tzBuffer = " 00:00";
                uint8 tzh;
                if (Quarters.unwrap(tzOffset) < 0) {
                    tzBuffer[0] = "-";
                    tzh = uint8(-tzHours);
                } else {
                    tzBuffer[0] = "+";
                    tzh = uint8(tzHours);
                }

                tzBuffer[1] = DEC_DIGITS[(tzh / 10) % 10];
                tzBuffer[2] = DEC_DIGITS[tzh % 10];
                //
                tzBuffer[4] = DEC_DIGITS[(tzMinutes / 10) % 10];
                tzBuffer[5] = DEC_DIGITS[tzMinutes % 10];

                return string.concat(string(buffer), string(tzBuffer));
            }
        }
    }
}
