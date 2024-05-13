// Copyright (c) Microsoft Corporation.
// Licensed under the Apache License, Version 2.0.
// SPDX-License-Identifier: Apache-2.0

pub mod invehicle_digital_twin {
    pub mod v1 {
        tonic::include_proto!("invehicle_digital_twin");
    }
}

pub mod module {
    pub mod managed_subscribe {
        pub mod v1 {
            tonic::include_proto!("managed_subscribe");
        }
    }
}

pub mod service_discovery {
    pub mod core {
        pub mod v1 {
            tonic::include_proto!("service_registry");
        }
    }
}
