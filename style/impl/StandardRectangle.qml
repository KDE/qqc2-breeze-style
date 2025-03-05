/* SPDX-FileCopyrightText: 2025 Seshan Ravikumar <seshan@sineware.ca>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
import QtQuick

// This is the base visual rectangle.
Rectangle {
    // On systems with fractional scaling, pixelAligned causes borders widths to be
    // inconsistently sized due to rounding. This causes the border to be randomly
    // wider and narrower depending on the edge. Curves are especially affected.
    border.pixelAligned: false

    // Some controls (ex. DialogButtonBox) set a border by default.
    border.width: 0
}
