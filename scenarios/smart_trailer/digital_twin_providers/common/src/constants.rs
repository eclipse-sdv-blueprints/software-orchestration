// Copyright (c) Microsoft Corporation.
// Licensed under the Apache License, Version 2.0.
// SPDX-License-Identifier: Apache-2.0

/// Supported digital twin operations.
pub mod digital_twin_operation {
    pub const GET: &str = "Get";
    pub const SET: &str = "Set";
    pub const SUBSCRIBE: &str = "Subscribe";
    pub const UNSUBSCRIBE: &str = "Unsubscribe";
    pub const INVOKE: &str = "Invoke";
    pub const STREAM: &str = "Stream";
    pub const MANAGEDSUBSCRIBE: &str = "ManagedSubscribe";
}

// Supported digital twin protocols.
pub mod digital_twin_protocol {
    pub const GRPC: &str = "grpc";
    pub const MQTT: &str = "mqtt";
}

pub mod chariott {
    pub const INVEHICLE_DIGITAL_TWIN_SERVICE_NAMESPACE: &str = "sdv.ibeji";
    pub const INVEHICLE_DIGITAL_TWIN_SERVICE_NAME: &str = "invehicle_digital_twin";
    pub const INVEHICLE_DIGITAL_TWIN_SERVICE_VERSION: &str = "1.0";
    pub const INVEHICLE_DIGITAL_TWIN_SERVICE_COMMUNICATION_KIND: &str = "grpc+proto";
    pub const INVEHICLE_DIGITAL_TWIN_SERVICE_COMMUNICATION_REFERENCE: &str = "https://github.com/eclipse-ibeji/ibeji/blob/main/interfaces/digital_twin/v1/digital_twin.proto";
}

/// Recognized constraint types for subscribe requests.
pub mod constraint_type {
    pub const FREQUENCY_MS: &str = "frequency_ms";
}
