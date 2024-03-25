// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
// SPDX-License-Identifier: MIT

pub mod digital_twin_get_provider {
    pub mod v1 {
        #![allow(clippy::derive_partial_eq_without_eq)]
        tonic::include_proto!("digital_twin_get_provider");
    }
}
