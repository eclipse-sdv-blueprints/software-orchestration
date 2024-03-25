// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
// SPDX-License-Identifier: MIT

// Note: This code was manually written based on the structure of the
// vehicle model in "../dtdl/trailer.json"
// In the future this code could be generated from a DTDL spec.

pub mod trailer {
    pub mod trailer_weight {
        pub const ID: &str = "dtmi:sdv:Trailer:Weight;1";
        pub const NAME: &str = "TrailerWeight";
        pub const DESCRIPTION: &str = "The weight of the trailer";
        pub type TYPE = i32;
    }

    pub mod is_trailer_connected {
        pub const ID: &str = "dtmi:sdv:Trailer:IsTrailerConnected;1";
        pub const NAME: &str = "IsTrailerConnected";
        pub const DESCRIPTION: &str = "Is trailer connected?";
        pub type TYPE = bool;
    }
}
