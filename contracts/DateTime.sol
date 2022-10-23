// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

// Type used for UNIX epoch quantities
type Epoch is uint40;

// Type used to represent "quarters-of-an-hour" (used for timezone offset specification)
type Quarters is int8;

/**
 * Set of parts of a date/time value encoded by a given epoch
 *
 * @custom:member year  The year the given epoch encodes
 * @custom:member month  The month the given epoch encodes
 * @custom:member day  The day the given epoch encodes
 * @custom:member hour  The hour the given epoch encodes
 * @custom:member minute  The minute the given epoch encodes
 * @custom:member second  The second the given epoch encodes
 * @custom:member tzHours  The timezone offset hours
 * @custom:member tzMinutes  The timezone offset minutes (always multiple of 15)
 * @custom:member epoch  Calculated epoch value, taking timezoneOffset into account
 */
struct DateTimeParts {
    uint256 year;
    uint256 month;
    uint256 day;
    uint256 hour;
    uint256 minute;
    uint256 second;
    int8 tzHours;
    uint256 tzMinutes;
    uint256 epoch;
}

/**
 * Extract the date/time components from the given epoch value
 *
 * @param value  The value to extract components from
 * @return dateTimeParts  The DateTimeParts the given epoch encodes
 */
function dateTimeParts(Epoch value) pure returns (DateTimeParts memory) {
    return dateTimeParts(value, Quarters.wrap(0));
}

/**
 * Extract the date/time components from the given epoch value and timezone offset
 *
 * Mostly taken from: https://howardhinnant.github.io/date_algorithms.html#civil_from_days
 *
 * @param value  The value to extract components from
 * @param tzOffset  The number of quarters-of-an-hour to offset
 * @return dateTimeParts  The DateTimeParts the given epoch encodes
 */
function dateTimeParts(Epoch value, Quarters tzOffset) pure returns (DateTimeParts memory) {
    unchecked {
        require(-48 <= Quarters.unwrap(tzOffset), "Strings: timezone offset too small");
        require(Quarters.unwrap(tzOffset) <= 56, "Strings: timezone offset too big");

        DateTimeParts memory result;

        int256 tzOffsetInSeconds = int256(Quarters.unwrap(tzOffset)) * 900;
        if (tzOffsetInSeconds < 0) {
            require(uint256(-tzOffsetInSeconds) <= Epoch.unwrap(value), "Strings: epoch time too small for timezone offset");
            result.epoch = Epoch.unwrap(value) - uint256(-tzOffsetInSeconds);
        } else {
            result.epoch = Epoch.unwrap(value) + uint256(tzOffsetInSeconds);
        }

        {
            uint256 z = result.epoch / 86400 + 719468;
            uint256 era = z / 146097;
            uint256 doe = z - era * 146097;
            uint256 yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365;
            uint256 doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
            uint256 mp = (5 * doy + 2) / 153;
            //
            result.year = yoe + era * 400 + (mp == 10 || mp == 11 ? 1 : 0);
            result.month = mp < 10 ? mp + 3 : mp - 9;
            result.day = doy - (153 * mp + 2) / 5 + 1;
        }

        {
            uint256 w = result.epoch % 86400;
            //
            result.hour = w / 3600;
            result.minute = (w % 3600) / 60;
            result.second = w % 60;
        }

        result.tzHours = int8(tzOffsetInSeconds / 3600);
        result.tzMinutes = uint8((uint256(tzOffsetInSeconds < 0 ? -tzOffsetInSeconds : tzOffsetInSeconds) % 3600) / 60);

        return result;
    }
}
